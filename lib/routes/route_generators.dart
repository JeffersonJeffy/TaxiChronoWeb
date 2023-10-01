
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chrono_web/controller/dashboard_controller.dart';
import 'package:taxi_chrono_web/views/add_salesperson_view.dart';
import 'package:taxi_chrono_web/views/car_view.dart';
import 'package:taxi_chrono_web/views/driver_view.dart';
import 'package:taxi_chrono_web/views/login_view.dart';
import 'package:taxi_chrono_web/views/salesperson_view.dart';
import 'package:taxi_chrono_web/views/transaction_view.dart';

import '../controller/salesperson_controller.dart';
import '../views/dashboard_view.dart';
import '../views/signup_view.dart';

class RouteGenerator {

  static PageRoute generateRoute(RouteSettings routeSettings){

    switch(routeSettings.name){

      case SignUpView.pageName:
        return MaterialPageRoute(settings: routeSettings, builder: (context) => const SignUpView());

      case LoginView.pageName:
        return MaterialPageRoute(settings: routeSettings, builder: (context) => const LoginView());

      case DashboardView.pageName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (BuildContext builder) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => DashboardController()),
            ],
            child: Builder(
              builder: (BuildContext context) {
                final arguments = routeSettings.arguments;
                if (arguments is Map && arguments.containsKey("admin")) {
                  final admin = arguments["admin"];
                  return DashboardView(admin: admin);
                } else {
                  // Gérez le cas où "admin" n'est pas présent dans les arguments
                  // ou si les arguments ne sont pas de type Map
                  return const DashboardView();
                }
              },
            ),
          ),
        );

      case SalesPersonView.pageName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (BuildContext builder) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => SalesPersonController()),
            ],
            child: Builder(
              builder: (BuildContext context) {
                final arguments = routeSettings.arguments;
                if (arguments is Map && arguments.containsKey("admin")) {
                  final admin = arguments["admin"];
                  return SalesPersonView(admin: admin);
                } else {
                  // Gérez le cas où "admin" n'est pas présent dans les arguments
                  // ou si les arguments ne sont pas de type Map
                  return const SalesPersonView();
                }
              },
            ),
          ),
        );

      case AddSalesPersonView.pageName:
        return MaterialPageRoute(settings: routeSettings, builder: (BuildContext context) {
          final arguments = routeSettings.arguments;
          if (arguments is Map && arguments.containsKey("admin")) {
            final admin = arguments["admin"];
            return AddSalesPersonView(admin: admin);
          } else {
            // Gérez le cas où "admin" n'est pas présent dans les arguments
            // ou si les arguments ne sont pas de type Map
            return AddSalesPersonView();
          }
        },
        );

      case TransactionView.pageName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (BuildContext builder) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => DashboardController()),
            ],
            child: Builder(
              builder: (BuildContext context) {
                final arguments = routeSettings.arguments;
                if (arguments is Map && arguments.containsKey("admin")) {
                  final admin = arguments["admin"];
                  return TransactionView(admin: admin);
                } else {
                  // Gérez le cas où "admin" n'est pas présent dans les arguments
                  // ou si les arguments ne sont pas de type Map
                  return const TransactionView();
                }
              },
            ),
          ),
        );

      case DriverView.pageName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (BuildContext builder) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => DashboardController()),
            ],
            child: Builder(
              builder: (BuildContext context) {
                final arguments = routeSettings.arguments;
                if (arguments is Map && arguments.containsKey("admin")) {
                  final admin = arguments["admin"];
                  return DriverView(admin: admin);
                } else {
                  // Gérez le cas où "admin" n'est pas présent dans les arguments
                  // ou si les arguments ne sont pas de type Map
                  return const DriverView();
                }
              },
            ),
          ),
        );

      case CarView.pageName:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (BuildContext builder) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => DashboardController()),
            ],
            child: Builder(
              builder: (BuildContext context) {
                final arguments = routeSettings.arguments;
                if (arguments is Map && arguments.containsKey("admin")) {
                  final admin = arguments["admin"];
                  return CarView(admin: admin);
                } else {
                  // Gérez le cas où "admin" n'est pas présent dans les arguments
                  // ou si les arguments ne sont pas de type Map
                  return const CarView();
                }
              },
            ),
          ),
        );

      default:
        return MaterialPageRoute(settings: routeSettings, builder: (context) => const LoginView());
    }

  }


}