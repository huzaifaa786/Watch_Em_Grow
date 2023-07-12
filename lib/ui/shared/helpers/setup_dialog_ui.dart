import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<
      dynamic,
      Widget Function(
    BuildContext,
    DialogRequest,
    void Function(DialogResponse),
  )> builders = {
    AlertType.success: (context, request, completer) => _customDialog(
          AlertType.success,
          request,
          completer,
        ),
    AlertType.info: (context, request, completer) => _customDialog(
          AlertType.info,
          request,
          completer,
        ),
    AlertType.warning: (context, request, completer) => _customDialog(
          AlertType.warning,
          request,
          completer,
        ),
    AlertType.error: (context, request, completer) => _customDialog(
          AlertType.error,
          request,
          completer,
        ),
    AlertType.custom: (context, request, completer) => _customDialoog(
          AlertType.custom,
          request,
          completer,
        ),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

_CustomDialog _customDialog(
  AlertType dialogType,
  DialogRequest request,
  void Function(DialogResponse) completer,
) =>
    _CustomDialog(
      dialogType: dialogType,
      request: request,
      completer: completer,
      customDialogData:
          (request.customData ?? CustomDialogData()) as CustomDialogData,
    );

class _CustomDialog extends StatelessWidget {
  const _CustomDialog({
    Key? key,
    required this.dialogType,
    required this.request,
    required this.completer,
    required this.customDialogData,
  }) : super(key: key);

  final AlertType dialogType;
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final CustomDialogData customDialogData;

  @override
  Widget build(BuildContext context) {
    if (customDialogData.hasTimer) {
      Timer(const Duration(seconds: 3), () {
        completer(
          DialogResponse(confirmed: true),
        );
      });
    }

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.title ?? 'Dialog Title',
                  style: TextStyle(
                    color: titleColorSelector(dialogType),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (customDialogData.hasRichDescription)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: customDialogData.richDescription,
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: customDialogData.richData,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: customDialogData.richDescriptionExtra,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
              
                else
                  Text(
                    request.description ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
             
              ],
            ),
          ),
          if (customDialogData.hasTimer)
            const SizedBox.shrink()
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (customDialogData.isConfirmationDialog)
                    TextButton(
                      onPressed: () {
                        completer(DialogResponse());
                      },
                      child: Text(
                        request.secondaryButtonTitle ?? 'Cancel',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(
                    width: 16,
                  ),
                  TextButton(
                    onPressed: () {
                      completer(
                        DialogResponse(confirmed: true),
                      );
                    },
                    child: Text(
                      request.mainButtonTitle ?? 'Ok',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Returns a Color according to the DialogType
  Color titleColorSelector(AlertType dialogType) {
    if (dialogType == AlertType.success) {
      return Colors.green;
    } else if (dialogType == AlertType.info) {
      return Colors.blue;
    } else if (dialogType == AlertType.warning) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }
}

_CustomDialoog _customDialoog(
  AlertType dialogType,
  DialogRequest request,
  void Function(DialogResponse) completer,
) =>
    _CustomDialoog(
      dialogType: dialogType,
      request: request,
      completer: completer,
      customDialogData:
          (request.customData ?? CustomDialogData()) as CustomDialogData,
    );

class _CustomDialoog extends StatelessWidget {
  const _CustomDialoog({
    Key? key,
    required this.dialogType,
    required this.request,
    required this.completer,
    required this.customDialogData,
  }) : super(key: key);

  final AlertType dialogType;
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final CustomDialogData customDialogData;

  @override
  Widget build(BuildContext context) {
    if (customDialogData.hasTimer) {
      Timer(const Duration(seconds: 3), () {
        completer(
          DialogResponse(confirmed: true),
        );
      });
    }

    return Dialog(
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
            // color: Colors.deepOrange
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.title ?? 'Dialog Title',
                    style: TextStyle(
                      color: titleColorSelector(dialogType),
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(),
                      child: RaisedButton(
                        onPressed: () {
                          completer(
                          DialogResponse(confirmed: true),
                        );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/paypal_logo.png')
                           
                          ],
                        ),
                        color: Colors.white,
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(),
                      child: RaisedButton(
                        onPressed: () {
                          completer(
                          DialogResponse(),
                        );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/stripe_logo.png')
                           
                          ],
                        ),
                        color: Colors.white,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
               
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }

  /// Returns a Color according to the DialogType
  Color titleColorSelector(AlertType dialogType) {
    if (dialogType == AlertType.success) {
      return Colors.green;
    } else if (dialogType == AlertType.info) {
      return Colors.blue;
    } else if (dialogType == AlertType.warning) {
      return Colors.amber;
    } else if (dialogType == AlertType.custom) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }
}
