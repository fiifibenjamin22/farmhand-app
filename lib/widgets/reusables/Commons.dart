import 'package:flutter/material.dart';
import 'package:flutter_map_location/flutter_map_location.dart';

class Commons {
  static Icon customIcon(IconData icon, {double size = 24.0, Color color}) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }

  static locationState(LocationServiceStatus value) {
    switch (value) {
      case LocationServiceStatus.disabled:
      case LocationServiceStatus.permissionDenied:
      case LocationServiceStatus.unsubscribed:
        return const Icon(
          Icons.location_disabled,
          color: Colors.white,
        );
        break;
      case LocationServiceStatus.subscribed:
        return Icon(
          Icons.my_location,
          color: Colors.white,
        );
        break;
      default:
        return const Icon(
          Icons.location_searching,
          color: Colors.white,
        );
        break;
    }
  }

  static String inventoryType(int inventoryTypeId) {
    switch (inventoryTypeId) {
      case 1:
        return "Application Product";
        break;
      case 2:
        return "Equipment";
        break;
      case 3:
        return "Spare Part";
        break;
      case 4:
        return "Treatment Product";
        break;
      case 5:
        return "Vehicle";
        break;
      default:
        return "Type";
        break;
    }
  }
}
