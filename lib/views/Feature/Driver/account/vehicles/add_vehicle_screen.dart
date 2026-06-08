import 'package:flutter/material.dart';

import 'vehicle_form_page.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const VehicleFormPage(mode: VehicleFormMode.add);
  }
}
