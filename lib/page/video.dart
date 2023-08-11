// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart'
    show OpacityTransition, SwipeTransition, AnimatedInteractiveViewer;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_editor/video_editor.dart';

class VideoEditor extends StatefulWidget {
  const VideoEditor({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  bool _exported = false;
  String _exportText = "";
  late VideoEditorController _controller;

  @override
  void initState() {
    _controller = VideoEditorController.file(widget.file,
        maxDuration: const Duration(seconds: 30))
      ..initialize().then((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openCropScreen() => Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              CropScreen(controller: _controller)));

  void _exportVideo() async {
    _exportingProgress.value = 0;
    _isExporting.value = true;
    // NOTE: To use `-crf 1` and [VideoExportPreset] you need `ffmpeg_kit_flutter_min_gpl` package (with `ffmpeg_kit` only it won't work)
    await _controller.exportVideo(
      // preset: VideoExportPreset.medium,
      // customInstruction: "-crf 17",
      onProgress: (stats, value) => _exportingProgress.value = value,
      onCompleted: (File file) async {
        _isExporting.value = false;
        if (!mounted) return;
        if (file != null) {
          var downloadsPath =(await DownloadsPath.downloadsDirectory())!.path;
          int i = Random().nextInt(1000);
          var read = await file.readAsBytes();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                content: FractionallySizedBox(
                  heightFactor: 0.46,
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
                        TextButton(
                          onPressed: () async {
                            File("$downloadsPath/EditingVideo$i.mp4")
                                .writeAsBytesSync(read);
                            await Share.shareFiles(
                                ["$downloadsPath/EditingVideo$i.mp4"],
                                text: '');
                
                          },
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Share in   ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.yellow)),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(image: AssetImage("img/snap.png"),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    )
                                  ),
                                )
                              ],
                            ),
                        ),
                        Divider(
                          height: 40,
                          color: Colors.white,
                        ),
                        Text("Save in Gallery",
                            style: TextStyle(
                                fontSize: 20, color: Colors.white)),
                        Divider(height: 40, color: Colors.white),
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
                              style: TextStyle(fontSize: 20),
                            )),
                            Container(width: 3,height: 40,color: Colors.white,),
                            TextButton(
                        onPressed: () {
                          File("$downloadsPath/EditingVideo$i.mp4")
                              .writeAsBytesSync(read);
                          Navigator.pop(context);
                          showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          content: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done_outline_sharp,size: 70,color: Colors.white,),
                            Text("saved",style: TextStyle(fontSize: 25,color: Colors.white),)
                        ],
                      ),
                      );
                    },);  
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(fontSize: 23),
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
          _exportText = "Video success export!";
        } else {
          _exportText = "Error on export video :(";
        }

        setState(() => _exported = true);
        Future.delayed(const Duration(seconds: 2),
            () => setState(() => _exported = false));
      },
    );
  }

  void _exportCover() async {
    setState(() => _exported = false);
    await _controller.extractCover(
      onCompleted: (cover) {
        if (!mounted) return;

        if (cover != null) {
          _exportText = "Cover exported! ${cover.path}";
          showDialog(
            context: context,
            builder: (_) => Padding(
              padding: const EdgeInsets.all(30),
              child: Center(child: Image.memory(cover.readAsBytesSync())),
            ),
          );
        } else {
          _exportText = "Error on cover exportation :(";
        }

        setState(() => _exported = true);
        Future.delayed(const Duration(seconds: 2),
            () => setState(() => _exported = false));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
              child: Stack(children: [
              Column(children: [
                _topNavBar(),
                Expanded(
                    child: DefaultTabController(
                        length: 2,
                        child: Column(children: [
                          Expanded(
                              child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Stack(alignment: Alignment.center, children: [
                                CropGridViewer(
                                  controller: _controller,
                                  showGrid: false,
                                ),
                                AnimatedBuilder(
                                  animation: _controller.video,
                                  builder: (_, __) => OpacityTransition(
                                    visible: !_controller.isPlaying,
                                    child: GestureDetector(
                                      onTap: _controller.video.play,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.play_arrow,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              CoverViewer(controller: _controller)
                            ],
                          )),
                          Container(
                              height: 200,
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(children: [
                                const TabBar(
                                  indicatorColor: Colors.white,
                                  tabs: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(Icons.content_cut)),
                                          Text('Trim')
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(Icons.video_label)),
                                          Text('Cover')
                                        ]),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: _trimSlider()),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [_coverSelection()]),
                                    ],
                                  ),
                                )
                              ])),
                          _customSnackBar(),
                          ValueListenableBuilder(
                            valueListenable: _isExporting,
                            builder: (_, bool export, __) => OpacityTransition(
                              visible: export,
                              child: AlertDialog(
                                backgroundColor: Colors.white,
                                title: ValueListenableBuilder(
                                  valueListenable: _exportingProgress,
                                  builder: (_, double value, __) => Text(
                                    "Exporting video ${(value * 100).ceil()}%",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ])))
              ])
            ]))
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                icon: const Icon(
                  Icons.rotate_left,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.right),
                icon: const Icon(Icons.rotate_right, color: Colors.white),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: _openCropScreen,
                icon: const Icon(Icons.crop, color: Colors.white),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: _exportVideo,
                icon: const Icon(Icons.save, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: _controller.video,
        builder: (_, __) {
          final duration = _controller.video.value.duration.inSeconds;
          final pos = _controller.trimPosition * duration;
          final start = _controller.minTrim * duration;
          final end = _controller.maxTrim * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt()))),
              const Expanded(child: SizedBox()),
              OpacityTransition(
                visible: _controller.isTrimming,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(Duration(seconds: start.toInt()))),
                  const SizedBox(width: 10),
                  Text(formatter(Duration(seconds: end.toInt()))),
                ]),
              )
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
            controller: _controller,
            height: height,
            horizontalMargin: height / 4,
            child: TrimTimeline(
                controller: _controller,
                margin: const EdgeInsets.only(top: 10))),
      )
    ];
  }

  Widget _coverSelection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: height / 4),
        child: CoverSelection(
          controller: _controller,
          height: height,
          quantity: 8,
        ));
  }

  Widget _customSnackBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SwipeTransition(
        visible: _exported,
        axisAlignment: 1.0,
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: Text(_exportText,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

//-----------------//
//CROP VIDEO SCREEN//
//-----------------//
class CropScreen extends StatelessWidget {
  const CropScreen({Key? key, required this.controller}) : super(key: key);

  final VideoEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      controller.rotate90Degrees(RotateDirection.left),
                  icon: const Icon(Icons.rotate_left),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      controller.rotate90Degrees(RotateDirection.right),
                  icon: const Icon(Icons.rotate_right),
                ),
              )
            ]),
            const SizedBox(height: 15),
            Expanded(
              child: AnimatedInteractiveViewer(
                maxScale: 2.4,
                child: CropGridViewer(
                    controller: controller, horizontalMargin: 60),
              ),
            ),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Center(
                    child: Text(
                      "CANCEL",
                      style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ),
                ),
              ),
              buildSplashTap("16:9", 16 / 9,
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              buildSplashTap("1:1", 1 / 1),
              buildSplashTap("4:5", 4 / 5,
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              buildSplashTap("NO", null,
                  padding: const EdgeInsets.only(right: 10)),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    //2 WAYS TO UPDATE CROP
                    //WAY 1:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('waiting...')),);
                    controller.updateCrop();
                    /*WAY 2:
                    controller.minCrop = controller.cacheMinCrop;
                    controller.maxCrop = controller.cacheMaxCrop;
                    */
                    Navigator.pop(context);
                  },
                  icon: const Center(
                    child: Text(
                      "OK",
                      style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget buildSplashTap(
    String title,
    double? aspectRatio, {
    EdgeInsetsGeometry? padding,
  }) {
    return InkWell(
      onTap: () => controller.preferredCropAspectRatio = aspectRatio,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.aspect_ratio, color: Colors.white),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
