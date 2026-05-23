import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkealo/views/base/CustomAppbar/custom_appbar.dart';
import '../../../../../helpers/route.dart';

class SwitchToHostScreen extends StatefulWidget {
  const SwitchToHostScreen({super.key});

  @override
  State<SwitchToHostScreen> createState() => _SwitchToHostScreenState();
}

class _SwitchToHostScreenState extends State<SwitchToHostScreen> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nidController =
  TextEditingController(text: "879787808****");
  final TextEditingController referenceController = TextEditingController();

  XFile? frontImage;
  XFile? backImage;

  final ImagePicker picker = ImagePicker();

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );

    if (date != null) {
      dobController.text =
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }
  }

  Future<void> pickImage(bool isFront) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (isFront) {
          frontImage = image;
        } else {
          backImage = image;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3faf6),
      appBar: CustomAppBar(title: "Switch to Host"),
      body: Column(
          children: [
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                color: Color(0xff184aa5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios, color: Colors.white),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Switch to Host",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "If you want to become a Host, please provide the\nrequired details below.",
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 22),

                    const Text("Date of birth"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: dobController,
                      readOnly: true,
                      onTap: pickDate,
                      decoration: InputDecoration(
                        hintText: "dd/mm/yy",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month_outlined),
                          onPressed: pickDate,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    const Text(
                      "ID Information*",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Please upload real and valid information",
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),

                    const SizedBox(height: 18),
                    const Text("NID Number"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nidController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: uploadBox(
                            title: "ID Card Front",
                            image: frontImage,
                            onTap: () => pickImage(true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: uploadBox(
                            title: "ID Card Back",
                            image: backImage,
                            onTap: () => pickImage(false),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Text("Reference Name(Optional)"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: referenceController,
                      decoration: InputDecoration(
                        hintText: "Fill the number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.hostBottomNavScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1198f6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget uploadBox({
    required String title,
    required XFile? image,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue.shade100,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xff184aa5),
                child: Icon(
                  image == null ? Icons.camera_alt : Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
