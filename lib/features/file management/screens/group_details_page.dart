import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:share_pool/common/utils/alert_boxes.dart';
import 'package:share_pool/common/utils/enum_data.dart';
import 'package:share_pool/common/utils/nav_transition_utils.dart';
import 'package:share_pool/features/authentication/widgets/custom_place_holder.dart';
import 'package:share_pool/features/file%20management/model/message_model.dart';
import 'package:share_pool/features/file%20management/screens/select_group_page.dart';
import 'package:share_pool/features/file%20management/utils/file_mng_utils.dart';
import 'package:share_pool/features/file%20management/utils/group_role_helper.dart';
import 'package:share_pool/features/file%20management/widgets/file_card_item.dart';
import 'package:share_pool/features/group%20management/model/group_model.dart';
import 'package:share_pool/features/group%20management/model/privileage_model.dart';
import 'package:share_pool/features/home/utils/home_utils.dart';
import 'package:share_pool/features/notifications/model/activity_model.dart';
import 'package:share_pool/features/notifications/services/notification_service.dart';
import 'package:share_pool/features/users%20management/utils/usermng_utils.dart';
import '../../../common/widgets/bottom_sheets.dart';
import '../../authentication/providers/authentication_provider.dart';
import '../services/group_files_service.dart';
import 'package:path_provider/path_provider.dart';

class GroupDetailsPage extends StatefulWidget {
  GroupModel group;
  GroupDetailsPage({super.key, required this.group, });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  StreamSubscription<List<GroupRole>?>? _subscription;
  String groupRole = GroupRoleType.UNKNOWN.name;
  GroupModel? destinationGroupData;
  Stream<QuerySnapshot>? _messageStream;
  MessageModel m = MessageModel();
  List<MessageModel> messages  =  [
  ];
  late final LocalAuthentication auth;
  bool _supportState =false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
      _supportState = isSupported;
      if(_supportState){
        getAvailableBiometrics();
      }
    }));
    // Start listening to changes
    _subscribeToGetGroupRoles();


  }

  Future<void> getAvailableBiometrics() async{
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
    if(!mounted){
      return;
    }
  }

  Future<bool> _authenticate() async{
    try{
      bool authenticated = await auth.authenticate(localizedReason: "Authenticate to access SharePool.", options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false
      )
      );
      log("Authenticated: $authenticated");
      return authenticated;

    }catch(e){
      if(e.toString() == "PlatformException(NotAvailable, Security credentials not available., null, null)"){
        return true;
      }
      log(e.toString());
      return false;
    }

  }



  @override
  void dispose() {
    // Cancel the stream subscription to prevent memory leaks
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _subscribeToGetGroupRoles() async {
    // Subscribe to the stream of groups for the current user's email
    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    _subscription = GroupFilesService.getGroupRoleStreamByGroupIdAndEmail(widget.group.groupId!, authProvider.getCurrentUser()!.email!)?.listen((groupRoles) {
      // Handle changes to groups
      if (groupRoles != null) {
        groupRole = GroupRolesHelper.getGroupRole(groupRoles);
        print("User found in the group.");
        print(groupRoles.length);
      } else {
        print("User not found in the group.");
        groupRole = GroupRoleType.UNKNOWN.name;
      }
      log(groupRole);

    });
  }


  Future<void> _openFilePicker(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        // type: FileType.custom, // You can specify the file types you want to allow
        // allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png','jpge','zip','rar',], // Example of allowed file extensions
      );

      if (result != null) {
        // The user picked a file
        PlatformFile file = result.files.first;
        print('File path: ${file.path}');
        //create message instance

        final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);

        try{
            setState(() {
              m.isUploading = true;
            });
          m.destinationGroupId = destinationGroupData!.groupId!;
          m.destinationGroupName = destinationGroupData!.groupName;
          m.sourceGroupId = widget.group.groupId!;
          m.sourceGroupName = widget.group.groupName!;
          m.sentById = authProvider.getCurrentUser()!.uid;
          m.sentByName = authProvider.userData.name;
          m.uploadedDate = DateTime.now().toString();
          m.fileName = file.name;
          m.fileSize = FileMngUtils.formatFileSize(file.size);
          m.participants = [widget.group.groupId!,destinationGroupData!.groupId!];
          if( groupRole ==  GroupRoleType.TEAMLEAD.name || authProvider.userData.userRole == Role.ADMIN.name){
            m.approvedByName = authProvider.userData.name!;
            m.approvedDateTime = DateTime.now().toString();
            m.isApproved = true;
          }
          bool isSucceed =  await GroupFilesService.uploadFile(file, m);
            //write a log
            ActivityModel ac = ActivityModel();
            ac.groupId = widget.group.groupId;
            ac.groupName = widget.group.groupName;
            ac.description = "${authProvider.userData.name} sent a new file '${m.fileName}' to group '${destinationGroupData!.groupName}'";
            ac.subDescription = "Waiting for approval";
            ac.dateTime = DateTime.now().toString();
            addActivity(ac);


        }catch(e){
          AlertBoxes.showAlert(
            context,
            "Error",
            e.toString(),
                () {
              Navigator.pop(context);
            },
          );
        }
        finally{
          setState(() {
            m.isUploading = false;
          });
        }


      } else {
        // The user canceled the picker
        print('User canceled');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }


  Future<void> markFileAsApproved(String messageId, String fileName) async {
    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);

    try{
     await GroupFilesService.updateApprovalStatus(messageId, authProvider.userData.name??"");
     //write a log
     ActivityModel ac = ActivityModel();
     ac.groupId = widget.group.groupId;
     ac.groupName = widget.group.groupName;
     ac.description = "${authProvider.userData.name} approved the file '${fileName}' in group '${widget.group.groupName}'";
     ac.subDescription = "File approved";
     ac.dateTime = DateTime.now().toString();
     addActivity(ac);
      AlertBoxes.showAlert(
        context,
        "Success",
        "Your approval has been recorded, granting access to this file for others.",
            () {
          Navigator.pop(context);
        },
      );


    }catch(e){
      AlertBoxes.showAlert(
        context,
        "Error",
        e.toString(),
            () {
          Navigator.pop(context);
        },
      );
    }
  }



  Future<void> addActivity(ActivityModel data) async {
    try{
      await NotificationService.addNewActivityLog(data);
    }catch(e){
     log(e.toString());
    }
  }

  // Function to download file
  void _startDownload(String fileUrl, String fileName) async {
    try {
      String savedDir = await _findLocalPath();
      // Check if the file already exists in the download directory
      if (File('$savedDir/$fileName').existsSync()) {
        fileName = ' $fileName'; // Add a suffix to the filename if it already exists
      }

      // Append filename correctly
      savedDir = '$savedDir${Platform.pathSeparator}$fileName';

      Dio dio = Dio();
      // Hide any existing SnackBar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // Show Snackbar with download progress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child:   Text('Downloading... $fileName', style: TextStyle(color:Colors.white)),),
              SizedBox(height: 15,width:15,child: CircularProgressIndicator(),)
            ],
          ),
          duration: Duration(seconds: 10000000), // Adjust duration as needed
        ),
      );
      await dio.download(
        fileUrl,
        savedDir,
        onReceiveProgress: (receivedBytes, totalBytes) {
        },
        options: Options(
          responseType: ResponseType.bytes,
          receiveDataWhenStatusError: true,
          followRedirects: false,
        ),
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // Show Snackbar for download completion with download time
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child:   Text('Download complete: $fileName', style: TextStyle(color:Colors.white)),),
              SizedBox(height: 20,width:20,child: Icon(Icons.done))
            ],
          ),
          duration: Duration(seconds:3), // Adjust duration as needed
        ),
      );
      //write a log
      final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
      ActivityModel ac = ActivityModel();
      ac.groupName = widget.group.groupName;
      ac.groupId = widget.group.groupId;
      ac.description = "${authProvider.userData.name} accessed the file '$fileName' from the group '${widget.group.groupName}'";
      ac.subDescription = "File accessed";
      ac.dateTime = DateTime.now().toString();
      addActivity(ac);
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // Show Snackbar for download failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e', style: TextStyle(color:Colors.white)),
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );
    }
  }


// Future<void> _startDownload(String downloadUrl, String fileName) async {
  //   try {
  //     final savedDir = await _findLocalPath();
  //     // Check if the file already exists in the download directory
  //     if (File('$savedDir/$fileName').existsSync()) {
  //       fileName = ' $fileName'; // Add a suffix to the filename if it already exists
  //     }
  //     // Start downloading the file
  //     final taskId = await FlutterDownloader.enqueue(
  //       url: downloadUrl,
  //       savedDir: savedDir,
  //       fileName: fileName,
  //       showNotification: true,
  //       openFileFromNotification: true,
  //     );
  //     print('Download task id: $taskId');
  //   } catch (e) {
  //     print('Error starting download: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to start download')),
  //     );
  //   }
  // }


  Future<String> _findLocalPath() async {
    // Determine download directory based on platform
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download/';
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }



  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 30, width: 30,
              decoration: BoxDecoration(
                color: HomeUtils.getRandomColor(),
                borderRadius: BorderRadius.circular(6),
              ),
              child:   Center(child: Text(UserMngUtils.getInitials(widget.group.groupName!??""), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11,), ),) ,
            ),
            const SizedBox(width: 10,),
             Text(  widget.group.groupName!,style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
          ],
        ),
      ),
      body: SafeArea(child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(children: [
          //fake uploading one
         m.fileName!=null? Visibility(
            visible: m.isUploading==true,
            child: FileCardItem(
              fileDesc:"${m.fileSize}, uploaded by ${m.sentByName} on ${FileMngUtils.formatDateString(m.uploadedDate!)} " ,
              fileName: m.fileName??"",
              isUploading: m.isUploading,
              popupMenuWidgets: [

              ],
              status: m.isUploading==null || m.isUploading==false? "Waiting for approval to send to ${m.destinationGroupName}" : "Approved and sent" ,

            ),
          ):SizedBox(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').where("participants", arrayContains: widget.group.groupId!)
                  .orderBy('uploadedDate', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style:  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator()); // Display loading indicator while data is being fetched
                }

                if( snapshot.data!=null){
                  messages = snapshot.data!.docs.map((DocumentSnapshot document) {
                    return MessageModel.fromJson(document.data() as Map<String, dynamic>);
                  }).toList();
                }

                return  messages.isEmpty?Center(
                  child: CustomPlaceHolder(title: "No files found!", icon: Icons.not_interested_outlined ),
            
                ) :ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var data = messages[index];
                    return FileCardItem(
                      fileDesc:"${data.fileSize}, uploaded by ${data.sentByName} from ${data.sourceGroupName} to ${data.destinationGroupName} on ${FileMngUtils.formatDateString(data.uploadedDate!)} " ,
                      fileName: data.fileName??"",
                      isUploading: data.isUploading,
                      isDownloading: data.isDownloading,
                      popupMenuWidgets: [
                        ListTile(
                          leading: const Icon(Icons.download, size: 19,),
                          title: const Text('Download',style: TextStyle(fontSize:14,  ),),
                          onTap: () async {

                            if(await _authenticate()){
                              if(data.isApproved == true || groupRole ==  GroupRoleType.TEAMLEAD.name || authProvider.userData.userRole == Role.ADMIN.name){
                                if(groupRole ==  GroupRoleType.SENDER.name && authProvider.userData.userRole == Role.USER.name){
                                  //write a log
                                  final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
                                  ActivityModel ac = ActivityModel();
                                  ac.groupId = widget.group.groupId;
                                  ac.groupName = widget.group.groupName;
                                  ac.description = "${authProvider.userData.name} tried to access the file '${data.fileName}' from the group '${widget.group.groupName}'";
                                  ac.subDescription = "Access permission denied";
                                  ac.dateTime = DateTime.now().toString();
                                  addActivity(ac);
                                  Navigator.pop(context);
                                  AlertBoxes.showAlert(
                                    context,
                                    "Access permission denied",
                                    "You don't have permission to access files in this group. Please contact the team lead for further assistance.",
                                        () {
                                      Navigator.pop(context);
                                    },
                                  );

                                }
                                else{
                                  Navigator.pop(context);
                                  _startDownload(data.fileUrl!, data.fileName!);
                                }
                              }
                              else{

                                //write a log
                                final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
                                ActivityModel ac = ActivityModel();
                                ac.groupId = widget.group.groupId;
                                ac.groupName = widget.group.groupName;
                                ac.description = "${authProvider.userData.name} tried to access the file '${data.fileName}' from the group '${widget.group.groupName}'";
                                ac.subDescription = "Tried to access";
                                ac.dateTime = DateTime.now().toString();
                                addActivity(ac);
                                Navigator.pop(context);
                                AlertBoxes.showAlert(
                                  context,
                                  "Waiting for approval",
                                  "File can only be downloaded after it has been approved by the team lead. Please contact the team lead for further assistance.",
                                      () {
                                    Navigator.pop(context);
                                  },
                                );
                              }
                            }


                            // Add your edit logic here
                          },
                        ),
                        Visibility(
                        visible: groupRole ==  GroupRoleType.TEAMLEAD.name || authProvider.userData.userRole == Role.ADMIN.name,
                          child: ListTile(
                            leading: const Icon(Icons.delete, size: 19,),
                            title:const Text('Delete',style: TextStyle(fontSize:14, ),),
                            onTap: () async {
                              if(await _authenticate()){
                                final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
                                ActivityModel ac = ActivityModel();
                                ac.groupId = widget.group.groupId;
                                ac.groupName = widget.group.groupName;
                                ac.description = "${authProvider.userData.name} deleted the file '${data.fileName}' from the group '${widget.group.groupName}'";
                                ac.subDescription = "File deleted";
                                ac.dateTime = DateTime.now().toString();
                                addActivity(ac);
                                Navigator.pop(context); // Close the bottom sheet
                                // Add your delete logic here
                              }
                              GroupFilesService.deleteMessage(data.id!);
                              //write a log

                            },
                          ),
                        ),
                        Visibility(
                          visible: groupRole ==  GroupRoleType.TEAMLEAD.name || authProvider.userData.userRole == Role.ADMIN.name && data.isApproved!=true,
                          child: ListTile(
                            leading: const Icon(Icons.done_all, size: 19,),
                            title: const Text('Approve',style: TextStyle(fontSize:14,  ),),
                            onTap: () async {
                              if(await _authenticate()){
                              markFileAsApproved(data.id!,data.fileName!);
                              Navigator.pop(context); // Close the bottom sheet
                              // Add your edit logic here
                              }

                            },
                          ),
                        ),
                      ],
                      status: data.isApproved==null || data.isApproved==false? "Waiting for approval" : "Approved by ${data.approvedByName}" ,
            
                    );
                  },
                );
              },
            ),
          ),
       
               
            ],),
      ),),
    floatingActionButton: FloatingActionButton(onPressed: (){
      CustomBottomSheets.showUploadBottomSheet(context: context,onUploadBtnTap: () async{
        if(await _authenticate()){
          if(groupRole== GroupRoleType.TEAMLEAD.name || groupRole== GroupRoleType.SENDER.name ||  groupRole== GroupRoleType.SENDERNVIEWER.name || authProvider.userData.userRole == Role.ADMIN.name){
            Navigator.push(
              context,
              TransitionUtils.slideTransitionFromRightToLeft(builder: (_) => SelectGroupPage(onGroupTap: (val){
                destinationGroupData = val;
                Navigator.pop(context);
                _openFilePicker(context);
                Navigator.pop(context);
              },)),
            );
          }
          else{
            AlertBoxes.showAlert(
              context,
              "Access Denied",
              "You don't have permission to upload files to this group. Please contact the team lead for assistance.",
                  () {
                Navigator.pop(context);
              },
            );

          }
        }


      } );

    },child: const Icon(Icons.add),),
    );
  }
}
