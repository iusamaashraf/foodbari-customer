import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:foodbari_deliver_app/modules/order/model/get_offer_model.dart';
import 'package:get/get.dart';

class MoreInfoRiderPage extends StatelessWidget {
  MoreInfoRiderPage({
    Key? key,
    required this.getData,
  }) : super(key: key);
  final GetRequestModel getData;
  final RequestController controller = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          '${getData.name!}\'s Profile',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(getData.image!),
                  ),
                  SizedBox(
                    width: Get.width * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getData.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Text(
                        getData.email!,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: Get.width * 0.01,
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            SizedBox(
                              width: Get.width * 0.01,
                            ),
                            Text(
                              ((controller.ratingValue.value) /
                                      controller.rating!.length)
                                  .toStringAsFixed(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                getData.address!,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.grey),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              getData.phone!.isNotEmpty
                  ? Text(
                      "Phone: " + getData.phone!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black),
                    )
                  : const Text(
                      'Phone: No contact provided',
                      style: TextStyle(color: Colors.black),
                    ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                "Description: " + getData.offerDiscription!,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Text(
                "Price: " + getData.offerPrice!,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              const Text(
                'Overall Rating',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              // const Spacer(),
              GetX<RequestController>(
                  init: Get.put<RequestController>(RequestController()),
                  builder: (RequestController rqstController) {
                    if (rqstController != null &&
                        rqstController.rating != null) {
                      return Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: rqstController.rating!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // CircleAvatar(
                                  //   radius: 25,
                                  //   backgroundImage: NetworkImage(getData.image!),
                                  // ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: List.generate(
                                            int.parse(rqstController
                                                .rating![index].star!
                                                .toString()
                                                .split('.')
                                                .first),
                                            (index) => const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                )),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        rqstController
                                                .rating![index].reviews!.isEmpty
                                            ? 'No review'
                                            : rqstController
                                                .rating![index].reviews!,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
