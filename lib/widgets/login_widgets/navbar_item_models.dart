import 'package:uridachi/widgets/login_widgets/rive_model.dart';

class NavItemModel {
  final String title;
  final RiveModel rive;

  NavItemModel({
    required this.title,
    required this.rive,
  });
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(
      title: 'Home',
      rive: RiveModel(
          src: "assets/images/navbar2.riv",
          artboard: "home",
          stateMachineName: 'home_Interactivity')),
  NavItemModel(
      title: 'Chat',
      rive: RiveModel(
          src: "assets/images/navbar2.riv",
          artboard: "chat",
          stateMachineName: 'chat_Interactivity')),
  NavItemModel(
      title: 'Trending',
      rive: RiveModel(
          src: "assets/images/navbar2.riv",
          artboard: "trend",
          stateMachineName: 'trend_Interactivity')),
  NavItemModel(
      title: 'Profile',
      rive: RiveModel(
          src: "assets/images/navbar2.riv",
          artboard: "profile",
          stateMachineName: 'profile_Interactivity')),
];
