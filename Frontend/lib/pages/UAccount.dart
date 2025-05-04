import 'package:flutter/material.dart';
import 'package:bookbazaar/Widget/SettingButtons.dart';
import 'package:bookbazaar/Widget/Gen_Appbar.dart';
import 'package:bookbazaar/pages/sellAndearn.dart';

class UAccountPage extends StatelessWidget {
  const UAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'User Account',
        showBackArrow: false,
        showTitle: true,
      ),
      body: Column(
        children: [

          CustomSettingsButton(
            icon: Icons.edit,
            title: 'Update Profile',

            onTap: () {

            },
          ),
          Divider(color: Colors.white54),
          CustomSettingsButton(
            icon: Icons.sell,
            title: 'Sell & Earn',

            onTap: () {

              Navigator.pushNamed(context, "/createseller");
            },
          ),
          Divider(color: Colors.white54),
          CustomSettingsButton(
            icon: Icons.shopping_bag,
            title: 'Ordered Book',

            onTap: () {
              Navigator.pushNamed(context, "/vieworder");
            },
          ),
          Divider(color: Colors.white54),
          CustomSettingsButton(
            icon: Icons.delete,
            title: 'Delete Account',

            onTap: () {
              // Navigate to Close Friends Page
              // Navigator.push(
              //
              // );
            },
          ),
          Divider(color: Colors.white38),
        ],
      ),
    );
  }
}
