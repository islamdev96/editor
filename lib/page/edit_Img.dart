// ignore_for_file: must_be_immutable, unused_local_variable

import 'dart:io';
import 'package:editor/page/cut_image.dart';
import 'package:editor/page/draw.dart';
import 'package:editor/path.dart';
import 'package:editor/widget.dart/row.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:screenshot/screenshot.dart';

class EditingImg extends StatefulWidget {
  var path;
  EditingImg({super.key, required this.path});

  @override
  State<EditingImg> createState() => _EditingImgState();
}

class _EditingImgState extends State<EditingImg> {
  int i = 0;
  ScreenshotController screenshotController = ScreenshotController();
  int angle = 0;
  double frame = 0;
  double light = 1;
  List<Color> color = [
    Colors.transparent,
    Colors.black,
    Colors.black26,
    Colors.black45,
    Colors.black87,
    Colors.amber.shade100,
    Colors.amber.shade50,
    Colors.green.shade100,
    Colors.red.shade100,
    Colors.yellow.shade100,
    Colors.brown.shade100,
    Colors.blue.shade100,
    Colors.tealAccent.shade100,
    Colors.pink.shade100,
    Colors.deepPurple.shade100,
    Colors.grey.shade100,
  ];

  update(double value)
  {
    setState(() {
      frame = value;
    });
  }
  incressLight(double value)
  {
    setState(() {
      light=value;
    });
  }
  double w=0.0;
  double h =0.0;
  int recicle = 1;
  getMedia(BuildContext context,double h2, double w2)
  {
    w = w2;
    h = h2;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      bottomSheet: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height*0.14,
        width: double.infinity,
        child: Column(
          children: [
            Divider(color: Colors.white,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width - 0.01,
                            height: MediaQuery.of(context).size.height * 0.09,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              itemCount: color.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        i = index;
                                      });
                                    },
                                    child: ColorFiltered(
                                      colorFilter:
                                          ColorFilter.mode(color[index], BlendMode.color),
                                      child: Image.file(
                                        FilePath.file,
                                        filterQuality: FilterQuality.high,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        height: MediaQuery.of(context).size.height * 0.08,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                      },
                      icon:Icon(Icons.filter_list_outlined,size: 30),color: Colors.white,
                    ),
                    Text("Filters",style: TextStyle(color: Colors.white),)
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () async{
                        try
                        {
                          var x = await Navigator.push(context, MaterialPageRoute(builder: (context) => Cut_image(),));
                        setState(() {
                          
                        });
                      
                        }catch(e)
                        {
                          print(e);
                        }
                      },
                      icon:Icon(Icons.cut, color: Colors.white,size: 30)
                    ),
                    Text("Crop",style: TextStyle(color: Colors.white),)
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        if(recicle ==1)
                        {
                          getMedia(context, MediaQuery.of(context).size.height*0.7,
                           MediaQuery.of(context).size.width-0.001);
                           recicle = 2;
                        }
                        if(recicle ==2)
                        {
                          getMedia(context, 
                          MediaQuery.of(context).size.width,
                           MediaQuery.of(context).size.width*0.45);
                           recicle = 1;
                        }
                        setState(() {
                        if(angle == 360)
                        {
                          angle+=90;
                        }
                        else
                        {
                          angle += 90;
                        }
                      });
                      },
                      icon:Icon(Icons.u_turn_right_rounded, color: Colors.white,size: 30),
                    ),
                    Text("Rotate",style: TextStyle(color: Colors.white),)
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(context: context, builder: (context) {
                        return  StatefulBuilder(builder: (context, SetState) {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width - 0.01,
                              height: MediaQuery.of(context).size.height * 0.09,
                            child: Slider(
                              value: frame, max: 100,min: 0,label:"$frame" ,
                              divisions: 10,

                            onChanged: (value) {
                              update(value);
                              SetState(() {
                                
                              },);
                            },),  
                          );
                          },);
                        },);
                      },
                      icon:Icon(Icons.border_outer_sharp, color: Colors.white,size: 30),
                    ),
                    Text("Frame",style: TextStyle(color: Colors.white),)
                  ],
                ),

                Column(
                  children: [
                    IconButton(
                      onPressed: ()async {
                        final directory = (await getApplicationDocumentsDirectory()).path;
                        await Directory('$directory/sample').create(recursive: true);
                         final fullPath =
                            '$directory/sample/${DateTime.now().millisecondsSinceEpoch}';
                      screenshotController.capture().then((dynamic valueImage)async{
                        File f= File(fullPath);
                        await f.writeAsBytes(valueImage);
                        FilePath.putFile(f);
                        final pop = await Navigator.push(context, MaterialPageRoute(builder: (context) => FlutterPainterExample(),));
                        setState(() {
                          
                        });
                      });  
                      },
                      icon:Icon(Icons.edit, color: Colors.white,size: 30),
                    ),
                    Text("Draw",style: TextStyle(color: Colors.white),)
                  ],
                ),

                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(context: context, builder: (context) {
                        return  StatefulBuilder(builder: (context, SetState) {
                          return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width - 0.01,
                            height: MediaQuery.of(context).size.height * 0.09,
                          child: Slider(
                            value: light, max: 2,min: 0,
                            divisions: 10,

                          onChanged: (value) {
                            incressLight(value);
                            SetState(() {
                              
                            },);
                          },),  
                        );
                        },);
                      },);
                      },
                      icon:Icon(Icons.sunny, color: Colors.white,size: 30),
                    ),
                    Text("Lighting",style: TextStyle(color: Colors.white),)
                  ],
                ),
                SizedBox(),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
        child: Column(
          children: [
            TopRow.row(context,screenshotController),
            Divider(color: Colors.white,),
            const SizedBox(height: 5,),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.7,
              child: Screenshot(
                controller: screenshotController,
                child: Transform.rotate(
                  angle: angle*0.0174533,
                  child: Container(
                    width: w==0.0?MediaQuery.of(context).size.width-0.001:w,
                    height: h==0.0?h = MediaQuery.of(context).size.height*0.7:h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: frame,
                        color: Colors.white
                      )
                    ),
                    child: ColorFiltered(
                      colorFilter:ColorFilter.matrix(
                        [
                          light, 0, 0, 0, 0,
                          0, light, 0, 0, 0,
                          0, 0, light, 0, 0,
                          0, 0, 0, 1, 0,
                        ]
                      ),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(color[i], BlendMode.color),
                        child: Image.file(
                            FilePath.file,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                          ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
