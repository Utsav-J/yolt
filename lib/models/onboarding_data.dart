import 'package:flutter/material.dart';

class OnboardingData {
  final String? userName;
  final TimeWindow planningWindow;
  final TimeWindow reflectionWindow;

  OnboardingData({
    this.userName,
    required this.planningWindow,
    required this.reflectionWindow,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'planningWindow': planningWindow.toJson(),
      'reflectionWindow': reflectionWindow.toJson(),
    };
  }

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      userName: json['userName'],
      planningWindow: TimeWindow.fromJson(json['planningWindow']),
      reflectionWindow: TimeWindow.fromJson(json['reflectionWindow']),
    );
  }
}

class TimeWindow {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  TimeWindow({required this.startTime, required this.endTime});

  Map<String, dynamic> toJson() {
    return {
      'startHour': startTime.hour,
      'startMinute': startTime.minute,
      'endHour': endTime.hour,
      'endMinute': endTime.minute,
    };
  }

  factory TimeWindow.fromJson(Map<String, dynamic> json) {
    return TimeWindow(
      startTime: TimeOfDay(
        hour: json['startHour'],
        minute: json['startMinute'],
      ),
      endTime: TimeOfDay(hour: json['endHour'], minute: json['endMinute']),
    );
  }
}
