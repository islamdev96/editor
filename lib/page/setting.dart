import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String text = "1080p";
  @override
  Widget build(BuildContext context) {
    Widget contanirMarker(String text, Widget icon,{bool xicon = true, String xtext = ""}) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        height: MediaQuery.of(context).size.height * 0.09,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 5,),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            Spacer(),
            xicon
                ? const Icon(
                    Icons.chevron_right_outlined,
                    color: Colors.blue,
                    size: 40,
                  )
                : Text(xtext,style: TextStyle(fontSize: 13),)
          ],
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))),
      body: Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("img/bgSetting.jpg"),filterQuality: FilterQuality.high,
          fit: BoxFit.fill,
          colorFilter: ColorFilter.srgbToLinearGamma())
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: const Text(
                "Settings",
                style: TextStyle(fontSize: 35, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  contanirMarker(
                    "Add me on Snap",
                    const Icon(Icons.add_box_rounded,
                        color: Colors.blue, size: 30),
                  ),
                  InkWell(
                    onTap: () {
                      try
                      {
                        showDialog(context: context, builder: (context) {
                        return AlertDialog(

                          backgroundColor: Colors.transparent,
                          content: FractionallySizedBox(
                           heightFactor: 0.85,
                            child: Container(
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width*0.7,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(onPressed: (){
                                    setState(() {
                                      text = "1080p";
                                    });
                                    Navigator.pop(context);
                                  }, 
                                  child: Text("1080p",style: TextStyle(fontSize: 19,color: Colors.white),),),
                                  Divider(color: Colors.white,),
                                  TextButton(onPressed: (){
                                    setState(() {
                                      text = "720p";
                                    });
                                    Navigator.pop(context);
                                  },
                                   child: Text("720p",style: TextStyle(fontSize: 19,color: Colors.white),),),
                                  Divider(color: Colors.white,),
                                  TextButton(onPressed: (){
                                    setState(() {
                                      text = "480p";
                                    });
                                    Navigator.pop(context);
                                  }, 
                                  child: Text("480p",style: TextStyle(fontSize: 19,color: Colors.white),),),
                                  Divider(color: Colors.white,),
                                  TextButton(onPressed: (){
                                    setState(() {
                                      text = "360p";
                                    });
                                    Navigator.pop(context);
                                  },
                                   child: Text("360p",style: TextStyle(fontSize: 19,color: Colors.white),),),
                                  Divider(color: Colors.white,),
                                  TextButton(onPressed: (){
                                    setState(() {
                                      text = "240p";
                                    });
                                    Navigator.pop(context);
                                  },
                                   child: Text("240p",style: TextStyle(fontSize: 19,color: Colors.white),),),
                                  Divider(color: Colors.white,),
                                  TextButton(onPressed: (){
                                    setState(() {
                                      text = "Low Quality";
                                    });
                                    Navigator.pop(context);
                                  },
                                   child: Text("Low Quality",style: TextStyle(fontSize: 19,color: Colors.white),),),
                                  Divider(color: Colors.white,),
                                  const SizedBox(height: 10,),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("Cancel",style: TextStyle(fontSize: 19,color: Colors.red),))
                                ],
                              ),
                            ),
                          ),
                        );
                      },);
                      }
                      catch(e)
                      {
      
                      }
                    },
                    child: contanirMarker(
                        "Video Quality",
                        const Icon(Icons.high_quality,
                            color: Colors.blue, size: 30),
                        xicon: false,
                        xtext: text),
                  ),
                  contanirMarker("www.KenEditor.com",
                      const Icon(Icons.language, color: Colors.blue, size: 30)),
                  contanirMarker(
                      "App  Privacy Policy",
                      const Icon(Icons.back_hand_outlined,
                          color: Colors.blue, size: 30)),
                  contanirMarker(
                      "App  Terms of Use",
                      const Icon(Icons.back_hand_outlined,
                          color: Colors.blue, size: 30)),
                  const Text("")
                ],
              ),
            ),
            Spacer(),
            Text("Version 1.1",style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
