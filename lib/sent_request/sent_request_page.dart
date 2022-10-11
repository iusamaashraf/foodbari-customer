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
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: requestController.sending!.length,
                  itemBuilder: (context, index) {
                    print(
                        "length of sent request is:${requestController.activeList.value!.length}");
                    return requestController.sending != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Customer Name: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: requestController
                                                  .sending![index]
                                                  .customer_name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Title: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: requestController
                                                  .sending![index].title!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Description: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: requestController
                                                  .sending![index].description!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Address: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: requestController
                                                  .sending![index]
                                                  .customer_address!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Price: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: requestController
                                                      .sending![index].price
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
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Estimated Delivery Fee: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: requestController
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
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
        },
      ),
    );
  }
}
