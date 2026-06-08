import 'package:flutter/material.dart';

import 'vehicle_form_page.dart';

class EditVehicleScreen extends StatelessWidget {
  const EditVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const VehicleFormPage(mode: VehicleFormMode.edit);
  }
}
