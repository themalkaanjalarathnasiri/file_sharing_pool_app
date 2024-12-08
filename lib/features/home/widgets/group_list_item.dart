import 'package:flutter/material.dart';

import '../../users management/utils/usermng_utils.dart';
import '../utils/home_utils.dart';

class GroupListItemTile extends StatefulWidget {
  void Function() onGroupTap;
  void Function() onSeeMoreTap;
  List<PopupMenuEntry>? menuWidgets = [];
  String groupTitle;
  bool? showSeemore;
  GroupListItemTile({super.key, this.showSeemore,  this.menuWidgets, required this.onGroupTap, required this.onSeeMoreTap, required this.groupTitle});

  @override
  State<GroupListItemTile> createState() => _GroupListItemTileState();
}

class _GroupListItemTileState extends State<GroupListItemTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
       widget.onGroupTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5,top: 5, bottom: 5),
        child: Row(
          children: [
            Container(
              height: 50, width: 50,
              decoration: BoxDecoration(
                color: HomeUtils.getRandomColor(),
                borderRadius: BorderRadius.circular(10),
              ),
              child:  Center(child: Text(UserMngUtils.getInitials(widget.groupTitle??""), style: TextStyle(fontWeight: FontWeight.bold),),) ,


            ),
            const SizedBox(width: 15),
             Expanded(
              child: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                widget.groupTitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
            ),

            Align(
                alignment: Alignment.centerRight,
                child: Visibility(
                  visible: widget.showSeemore==true,
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return widget.menuWidgets??[];
                    },

                  ),
                ),)
          ],
        ),
      ),
    );
  }
}
