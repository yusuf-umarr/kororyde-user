import 'package:flutter/material.dart';
import '../../../../app/app.dart';
import '../../../../common/common.dart';
import '../../../../env/flavor_config.dart';

Future<void> main() async {
  const values = FlavorValues(
    baseUrl: AppConstants.baseUrl,
    logNetworkInfo: true,
    authProvider: ' ',
  );

  FlavorConfig(
    flavor: Flavor.dev,
    name: 'DEV',
    color: Colors.white,
    values: values,
  );
  await commonSetup();
  runApp(const MyApp());
}
/*
com.kororyde.user
android   1:139626065830:android:0298191b6d516db1a72967
ios       1:139626065830:ios:8c47c1b2b49533cea72967
*/