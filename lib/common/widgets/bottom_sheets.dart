
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/common/theme/app_theme.dart';

class CustomBottomSheets{

  static void showBottomMenu({required BuildContext context, required List<Widget> widgets}){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.clear))),

              ...widgets,


            ],
          ),
        );
      },
    );

  }

  static void showUploadBottomSheet({required BuildContext context, required void Function() onUploadBtnTap}){
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.withOpacity(0.5), // Set bottom sheet background color to transparent
      isScrollControlled:  true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            height: 200, // Adjust height as needed
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     const Text(  "Upload to different group",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                    //     const SizedBox(width: 10,),
                    //     FloatingActionButton(
                    //
                    //       onPressed: (){}, child: const Icon(Icons.upcoming),),
                    //   ],
                    // ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(  "Upload a file",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                        const SizedBox(width: 10,),
                        FloatingActionButton(
                          onPressed: (){
                            onUploadBtnTap();
                          }, child: const Icon(Icons.upload),),
                      ],
                    ),
                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(  "Close",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),),
                        const SizedBox(width: 10,),
                        FloatingActionButton(

                          onPressed: (){
                            Navigator.pop(context);
                          }, child: const Icon(Icons.close),),
                      ],
                    ),

                    // Add more widgets for bottom sheet content as needed
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );}
}