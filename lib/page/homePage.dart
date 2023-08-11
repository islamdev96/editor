// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:editor/page/edit_Img.dart';
import 'package:editor/page/setting.dart';
import 'package:editor/page/video.dart';
import 'package:editor/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? bytes;

  Btn(BuildContext context, String text,
      {required void Function()? onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.black,
      //minWidth: MediaQuery.of(context).size.width*0.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 15,left: 50,right: 50),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding:  EdgeInsets.only(left: 10, right: 10, top: 40, bottom: MediaQuery.of(context).size.height*0.027),
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("img/home.png"),
        filterQuality: FilterQuality.high,
        fit: BoxFit.fill,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ken EDITOR",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  Text(
                    "Unlock the power of Visual\nStorytelling with us",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Setting(),
                        ));
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 35,
                  ))
            ],
          ),
          Column(
            children: [
              Btn(context, "Photo", onPressed: () async {
                try {
                  // String? downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory())!.path;
                  // print(downloadsDirectoryPath);
                  await Permission.storage.request();
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    FilePath.putFile(File(image.path));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditingImg(
                            path: image.path,
                          ),
                        ));
                  } else {}
                } catch (e) {
                  print(e);
                }
              }),
              const SizedBox(
                height: 10,
              ),
              Btn(context, "Video", onPressed: () async {
                await Permission.storage.request();
                final ImagePicker picker = ImagePicker();
                final XFile? video =
                    await picker.pickVideo(source: ImageSource.gallery);
                if (video != null) {
                  // var controllerSlider = VideoEditorController.file(File(video.path));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoEditor(
                                file: File(video.path),
                              )
                          // VideoEditor(file: File(video.path),controllerslider: controllerSlider),
                          ));
                }
              })
            ],
          )
        ],
      ),
    ));
  }
}
