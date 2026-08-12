// lib/features/layout/domain/entities/navigation_tab_entity.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// كيان يمثل عنصر التنقل في شريط التبويبات
class NavigationTabEntity extends Equatable {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String initialLocation;

  const NavigationTabEntity({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.initialLocation,
  });

  @override
  List<Object> get props => [label, icon, selectedIcon, initialLocation];
}