import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:screenshot/screenshot.dart';


class TopRow
{
  static Widget row(BuildContext context,ScreenshotController screenshotController)
  {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Cancel", style: TextStyle(fontSize: 20)),),
            Text("Edit", style: TextStyle(fontSize: 20, color: Colors.white)),
          TextButton(
              onPressed: () async {
                try {
                  var downloadsPath =  (await DownloadsPath.downloadsDirectory())!.path;
                  int i = Random().nextInt(1000);
                  screenshotController.capture().then((dynamic image) async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          content: FractionallySizedBox(
                            heightFactor: 0.3,
                            child: Container(
                            padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30)
                              ),
                              width: MediaQuery.of(context).size.width*0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Save in Gallery",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  Divider(height: 50, color: Colors.white),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(fontSize: 19),
                                      )),
                                      Container(width: 3,height: 40,color: Colors.white,),
                                      
                                      TextButton(
                                      onPressed: () async {     
                                                                   
                                        await File("$downloadsPath/Edit$i.jpg")
                                            .writeAsBytes(image);                                       
                                        Navigator.pop(context);      
                                        showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.black,
                                          content: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.done_outline_sharp,size: 70,color: Colors.white,),
                                            const SizedBox(width: 5,),
                                            Text("saved",style: TextStyle(fontSize: 25,color: Colors.white),)
                                          ],
                                        ),
                                        );
                                      },);  
                                      },
                                      child: Text(
                                        "Done",
                                        style: TextStyle(fontSize: 19),
                                      )),  
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        
                        );
                      },
                    );
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 20),
              ),
            ),
        ],
      ),
    );
  }
}