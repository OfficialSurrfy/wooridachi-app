import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  Future<void> fetch();
  Future<void> clear();
}
