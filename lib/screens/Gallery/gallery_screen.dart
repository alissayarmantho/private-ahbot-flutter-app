import 'package:botapp/controllers/media_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/screens/Gallery/gallery_details.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/zero_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//TODO: Make gallery supports video playing too. Currently gallery only supports pictures
class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User currentUser = Get.find<UserController>().currentUser.value;

    final MediaController mediaController = Get.find<MediaController>();

    mediaController.fetchAllMedia(
        mediaType: "picture", elderId: currentUser.id);
    return Scaffold(
      body: AppHeader(
        key: key,
        hasLogOut: true,
        hasBackButton: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 15, 40, 0),
              child: Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => mediaController.isLoading.value
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : mediaController.pictureList.length == 0
                      ? ZeroResult(
                          text:
                              "I think you have not uploaded anything so far...")
                      : Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return RawMaterialButton(
                                  onPressed: () {
                                    Get.to(
                                      () => GalleryDetails(
                                        currentIndex: index,
                                        imgList: mediaController.pictureList,
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: 'picture$index',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(mediaController
                                              .pictureList[index].link),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: mediaController.pictureList.length,
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
