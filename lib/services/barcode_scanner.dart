import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
/*import 'package:image_picker/image_picker.dart';*/
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wordpress_app/tabs/profile_tab.dart';
import 'package:wordpress_app/utils/next_screen.dart';

import 'app_service.dart';

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWithControllerState createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController>
    with SingleTickerProviderStateMixin {
  String? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
  );

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                child: Icon(
                  LucideIcons.chevronLeft,
                  size: 32,
                ),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: controller.torchState,
                builder: (context, state, child) {
                  if (state == null) {
                    return const Icon(
                      LucideIcons.flashlightOff,
                      color: Colors.grey,
                    );
                  }
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(
                        LucideIcons.flashlightOff,
                        color: Colors.grey,
                      );
                    case TorchState.on:
                      return const Icon(
                        LucideIcons.flashlight,
                        color: Colors.yellow,
                      );
                  }
                },
              ),
              iconSize: 25.0,
              onPressed: () => controller.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: controller.cameraFacingState,
                builder: (context, state, child) {
                  if (state == null) {
                    return const Icon(LucideIcons.switchCamera, color: Colors.purple,);
                  }
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(LucideIcons.switchCamera, color: Colors.purple);
                    case CameraFacing.back:
                      return const Icon(LucideIcons.switchCamera, color: Colors.purple);
                  }
                },
              ),
              iconSize: 25.0,
              onPressed: () => controller.switchCamera(),
            ),
            Spacer(),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(left: 8, top: 10, right: 10, bottom: 8),
                alignment: Alignment.center,
                width: 45,
                height: 30,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: Text(
                    'Go',
                    maxLines: 1,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        letterSpacing: -0.7,
                        wordSpacing: 1,
                        fontSize: 16,
                        color: Theme.of(context).backgroundColor,
                        fontWeight: FontWeight.w500),
                  ).tr(),
                ),
              ),
              onTap: ()=> AppService().openLinkWithBrowserMiniProgram(
                  context, (barcode!))
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                controller: controller,
                fit: BoxFit.contain,
                allowDuplicates: true,
                /*controller: MobileScannerController(
                   torchEnabled: true,
                   facing: CameraFacing.front,
                ),*/
                onDetect: (var barcode, args) {
                  setState(() {
                    this.barcode = barcode.rawValue;
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 200,
                          height: 50,
                          child: FittedBox(
                            child: Text(
                              barcode ?? 'Scan something',
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
