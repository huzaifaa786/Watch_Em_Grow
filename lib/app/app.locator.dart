// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:mipromo/services/date_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../api/auth_api.dart';
import '../api/database_api.dart';
import '../api/image_selector_api.dart';
import '../api/paypal_api.dart';
import '../api/storage_api.dart';
import '../services/user_service.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => AuthApi());
  locator.registerLazySingleton(() => DatabaseApi());
  locator.registerLazySingleton(() => StorageApi());
  locator.registerLazySingleton(() => PaypalApi());
  locator.registerLazySingleton(() => ImageSelectorApi());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => DateService());
}
