import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:get/get.dart';

class SentRequestPage extends StatefulWidget {
  const SentRequestPage({Key? key}) : super(key: key);

  @override
  State<SentRequestPage> createState() => _SentRequestPageState();
}

class _SentRequestPageState extends State<SentRequestPage> {
  RequestController requestController = Get.put(RequestController());

  @override
  void initState() {
    requestController.sendingRequestsFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: GetX<RequestController>(
        init: RequestController(),
        builder: (controller) {
          if (controller.sending == null || controller.sending!.isEmpty) {
            return SizedBox(
              // height: size.height * 0.4,
              width: size.width * 1,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.15,
                  ),
                  Image.asset(
                    "assets/images/no_data.png",
                    height: size.height * 0.2,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Text("No Sending offer found yet ...",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20, bottom: 100),
                    itemCount: requestController.sending!.length,
                    itemBuilder: (context, index) {
                      print(
                          "length of sent request is:${requestController.sending!.length}");
                      return requestController.sending!.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 12)
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            requestController.sending![index]
                                                    .request_image!.isNotEmpty
                                                ? Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 2,
                                                        )),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        requestController
                                                            .sending![index]
                                                            .request_image!,
                                                        // scale: 4,
                                                        height: 200,
                                                        fit: BoxFit.fill,
                                                        // width: double.infinity,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 2,
                                                        )),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        'https://img.freepik.com/free-vector/way-concept-illustration_114360-1191.jpg?w=2000&t=st=1665469064~exp=1665469664~hmac=f18cfd14cfdc7389b9238600501c87cd28798d2e6fbb6058d4b699309ebce3b9',
                                                        height: 200,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  requestController
                                                      .sending![index].title!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
                                                      .copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Price:',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption!
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "\$" +
                                                          requestController
                                                              .sending![index]
                                                              .price
                                                              .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1!
                                                          .copyWith(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: Text(
                                                    requestController
                                                        .sending![index]
                                                        .description!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.grey,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    requestController
                                                        .sending![index]
                                                        .pickAddress!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            ...List.generate(
                                                5,
                                                (index) => Padding(
                                                      padding: EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.011),
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(1),
                                                        height: 3,
                                                        width: 3,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                shape: BoxShape
                                                                    .circle),
                                                      ),
                                                    )),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.grey,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    requestController
                                                        .sending![index]
                                                        .dropAddress!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Estimated Delivery Fee:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(color: Colors.grey),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "\$" +
                                                  requestController
                                                      .sending![index]
                                                      .deliveryfee
                                                      .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text('No data found'),
                            );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
