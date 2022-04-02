import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

SwiperController useSwiperController() => use(
      const _SwiperController(),
    );

class _SwiperController extends Hook<SwiperController> {
  const _SwiperController();

  @override
  _SwiperControllerState createState() => _SwiperControllerState();
}

class _SwiperControllerState
    extends HookState<SwiperController, _SwiperController> {
  late SwiperController _swiperController;

  @override
  void initHook() {
    _swiperController = SwiperController();
  }

  @override
  SwiperController build(BuildContext context) => _swiperController;

  @override
  void dispose() => _swiperController.dispose();
}
