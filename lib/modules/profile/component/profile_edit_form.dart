import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:get/get.dart';
import '../../../widgets/primary_button.dart';

class ProfielEditForm extends StatelessWidget {
  ProfielEditForm({Key? key}) : super(key: key);
  CustomerController controller = Get.put(CustomerController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                controller.customerModel.value!.name!,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "please enter name";
                  } else {
                    return null;
                  }
                },
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    hintText: controller.customerModel.value!.name),
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: controller.customerModel.value!.email,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "please enter your phone number";
                  } else {
                    return null;
                  }
                },
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: controller.customerModel.value!.phone,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: false,
                controller: locationController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    hintText:
                        controller.customerModel.value!.address.toString()),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                  text: 'Update Account',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.updateProfile(
                          image: controller.customerModel.value!.profileImage!,
                          name: nameController.text,
                          phone: phoneController.text,
                          context: context);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
