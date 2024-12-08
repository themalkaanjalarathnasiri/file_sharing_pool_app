import 'package:share_pool/common/utils/enum_data.dart';
import 'package:share_pool/features/group%20management/model/privileage_model.dart';

class GroupRolesHelper{


  static String getGroupRole(List<GroupRole> roles){
    try{
      bool _isTeamLead =false;
      bool _isSender =false;
      bool _isViewer =false;
      GroupRoleType groupRole = GroupRoleType.UNKNOWN;
      for(int i = 0; i < roles.length; i++){
        var e = roles[i];
        if(e.roleName == "Team Lead" && e.isActive==true){
          _isTeamLead = true;
        }

        if(e.roleName == "Sender" && e.isActive==true){
          _isSender = true;
        }

        if(e.roleName == "Viewer" && e.isActive==true){
          _isViewer = true;
        }
      }
      if(_isTeamLead){
        groupRole= GroupRoleType.TEAMLEAD;
        return groupRole.name;
      }
      if(_isSender && _isViewer){
        groupRole=GroupRoleType.SENDERNVIEWER;
        return groupRole.name;
      }
      if(_isSender){
        groupRole= GroupRoleType.SENDER;
        return groupRole.name;
      }
      if(_isViewer){
        groupRole= GroupRoleType.VIEWER;
        return groupRole.name;
      }
      return groupRole.name;
    }
    catch(e){
      return GroupRoleType.UNKNOWN.name;
    }
  }
}