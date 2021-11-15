import 'package:botapp/controllers/media_analytic_controller.dart';
import 'package:botapp/models/media.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryDetails extends StatelessWidget {
  final int currentIndex;
  final List<Media> imgList;

  GalleryDetails({Key? key, required this.currentIndex, required this.imgList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GalleryDetailController galleryDetailController =
        Get.put<GalleryDetailController>(
            GalleryDetailController(index: currentIndex));
    Get.put<MediaAnalyticController>(MediaAnalyticController(
        mediaType: "picture")); // for now only support pictures
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        //TODO: Check if they prefer fit cover and cut the image
                        // or contain and have some white spaces but like no
                        // image cut
                        Image.network(item.link,
                            fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            child: Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return Scaffold(
      body: AppHeader(
        key: key,
        hasBackButton: true,
        hasLogOut: false,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    initialPage: currentIndex,
                    onPageChanged: (index, reason) {
                      galleryDetailController.setCurrIndex(index);
                    },
                  ),
                  items: imageSliders,
                ),
                Obx(
                  () => Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      imgList[galleryDetailController.currIndex.value]
                          .description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GalleryDetailController extends GetxController {
  var index;

  GalleryDetailController({required this.index});

  @override
  void onInit() {
    setCurrIndex(index);
    super.onInit();
  }

  var currIndex = 0.obs;

  void setCurrIndex(int value) {
    currIndex.value = value;
  }
}
