import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/bluetooth-feature/bloototh_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StartDiscoveryBtn extends StatefulWidget {

  const StartDiscoveryBtn({
    Key? key,
  }) : super(key: key);

  @override
  State<StartDiscoveryBtn> createState() => _StartDiscoveryBtnState();
}

class _StartDiscoveryBtnState extends State<StartDiscoveryBtn> {
  late bool toggle;

  @override
  void initState() {
    toggle = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 final bool visible = context.select<BluetoothViewModel,bool>((instance)=>instance.enableBluetooth);
    return Visibility(
      visible: visible,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 1,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: Brand.appPadding(context: context) * 0.5),
            child: SwitchListTile(
              activeColor: Brand.darkGreyBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              title: Text(toggle ? 'Stop Discovery' : 'Start Discovery',
                  style: GoogleFonts.poppins(
                    fontSize: Brand.h4Size(context),
                    fontWeight: Brand.h4Weight,
                    color: Brand.blackGrey,
                  )),
              value: toggle,
              onChanged: (v) {
                setState(() {
                  toggle = v;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
