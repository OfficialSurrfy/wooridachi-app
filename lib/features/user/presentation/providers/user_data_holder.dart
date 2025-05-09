import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';

class UserDataHolder extends ChangeNotifier {
  UserEntity? _user;

  UserEntity? get user => _user;

  void setUser(UserEntity? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
