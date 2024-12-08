import 'package:flutter/cupertino.dart';
import 'package:share_pool/features/group%20management/model/privileage_model.dart';

class GroupFilesProvider extends ChangeNotifier {
  GroupRole _groupRole = GroupRole();
  GroupRole get groupRole => _groupRole;


  void setGroupRoles(GroupRole grpRole){
    this._groupRole = grpRole;
    notifyListeners();
  }

}