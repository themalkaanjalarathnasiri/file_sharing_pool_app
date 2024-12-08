class MessageModel {
  String? id;
  String? sourceGroupName;
  String? sourceGroupId;
  String? sentByName;
  String? sentById;
  String? destinationGroupName;
  String? destinationGroupId;

  String? fileName;
  String? fileUrl;
  String? fileSize;
  String? uploadedDate;
  bool? isApproved;
  String? approvedByName;
  String? approvedDateTime;
  bool? isUploading;
  bool? isDownloading;
  List<String>? participants;
  List<String>? receiverGroupIds;

  MessageModel({
    this.id,
    this.sourceGroupName,
    this.sourceGroupId,
    this.sentByName,
    this.sentById,
    this.destinationGroupName,
    this.destinationGroupId,
    this.fileName,
    this.fileUrl,
    this.fileSize,
    this.uploadedDate,
    this.isApproved,
    this.approvedByName,
    this.isUploading,
    this.isDownloading,
    this.approvedDateTime,
    this.participants,
    this.receiverGroupIds
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sourceGroupName = json['sourceGroupName'];
    sourceGroupId = json['sourceGroupId'];
    sentByName = json['sentByName'];
    sentById = json['sentById'];
    destinationGroupName = json['destinationGroupName'];
    destinationGroupId = json['destinationGroupId'];
    fileName = json['fileName'];
    fileUrl = json['fileUrl'];
    fileSize = json['fileSize'];
    uploadedDate = json['uploadedDate'];
    isApproved = json['isApproved'];
    approvedByName = json['approvedByName'];
    approvedDateTime = json['approvedDateTime'];
    isUploading = json['isUploading'];
    isDownloading = json['isDownloading'];
    participants = json['participants'] != null
        ? List<String>.from(json['participants'])
        : null;
    receiverGroupIds = json['receiverGroupIds'] != null
        ? List<String>.from(json['receiverGroupIds'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'sourceGroupName': sourceGroupName,
      'sourceGroupId': sourceGroupId,
      'sentByName': sentByName,
      'sentById': sentById,
      'destinationGroupName': destinationGroupName,
      'destinationGroupId': destinationGroupId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSize': fileSize,
      'uploadedDate': uploadedDate,
      'isApproved': isApproved,
      'approvedByName': approvedByName,
      'approvedDateTime': approvedDateTime,
      'isUploading': isUploading,
      'isDownloading': isDownloading,
    };
    if (participants != null) {
      data['participants'] = participants;
    }
    if (receiverGroupIds != null) {
    data['receiverGroupIds'] = receiverGroupIds;
    }
    return data;
  }
}
