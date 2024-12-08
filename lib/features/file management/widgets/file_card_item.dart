import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../common/theme/app_theme.dart';
import '../../../common/widgets/bottom_sheets.dart';

class FileCardItem extends StatefulWidget {
  String fileName;
  String fileDesc;
  String status;
  bool? isUploading;
  bool? isDownloading;
  List<Widget> popupMenuWidgets;
   FileCardItem({ super.key, required this.fileName, required this.fileDesc, required this.status ,required this.popupMenuWidgets, this.isUploading, this.isDownloading});

  @override
  State<FileCardItem> createState() => _FileCardItemState();
}

class _FileCardItemState extends State<FileCardItem> {
  String getProgressStatus(){
    if(widget.isDownloading??false){
      return "downloading";
    }
    else{
      return "uploading";
    }
  }

  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Icon(Icons.folder, size: 40, color: AppTheme.primaryColor,),
            ),
            Visibility(
              visible: widget.isUploading==true,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10,),
         Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(  widget.fileName,overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),),
              Text(widget.isUploading==true || widget.isDownloading==true? "file ${getProgressStatus()} is in progress...":  widget.fileDesc, overflow: TextOverflow.ellipsis, maxLines: 2,style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),),
              Text( widget.isUploading==true || widget.isDownloading==true? "": widget.status, overflow: TextOverflow.ellipsis, maxLines: 1,style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),),
              const Divider(
                thickness: 0.5,
                indent: 1,
                color: Colors.grey,

              ),
            ],),
        ),
        IconButton(onPressed: (){
          CustomBottomSheets.showBottomMenu(context: context,widgets: [
            ...widget.popupMenuWidgets,

          ]);
        }, icon: const Icon(Icons.more_vert))
      ],);
  }
}
