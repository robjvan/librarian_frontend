import 'package:flutter/material.dart';
import 'package:librarian_frontend/models/entity.dart';
import 'package:librarian_frontend/models/enums/filter_key_model.dart';
import 'package:librarian_frontend/models/enums/sort_method_model.dart';

class SettingsStateRepository extends Entity<SettingsStateRepository> {
  final bool useDarkMode;
  final bool useGridView;
  final bool searchBoxVisible;
  final bool filterBarVisible;
  final bool resizeModalVisible;
  final double gridItemSize;
  final SortMethod sortMethod;
  final String searchTerm;
  final FilterKey filterKey;
  final Color userColor;

  SettingsStateRepository({
    required this.useDarkMode,
    required this.useGridView,
    required this.searchBoxVisible,
    required this.sortMethod,
    required this.filterBarVisible,
    required this.resizeModalVisible,
    required this.searchTerm,
    required this.filterKey,
    required this.userColor,
    required this.gridItemSize,
  });

  @override
  factory SettingsStateRepository.createEmpty() => SettingsStateRepository(
        useDarkMode: true,
        useGridView: true,
        searchBoxVisible: false,
        filterBarVisible: false,
        resizeModalVisible: false,
        sortMethod: SortMethod.authorAsc,
        searchTerm: '',
        filterKey: FilterKey.all,
        userColor: Colors.green,
        gridItemSize: 125.0,
      );

  @override
  SettingsStateRepository copyWith({
    final bool? useDarkMode,
    final bool? useGridView,
    final bool? searchBoxVisible,
    final bool? filterBarVisible,
    final bool? resizeModalVisible,
    final String? searchTerm,
    final FilterKey? filterKey,
    final SortMethod? sortMethod,
    final Color? userColor,
    final double? gridItemSize,
  }) =>
      SettingsStateRepository(
        useDarkMode: useDarkMode ?? this.useDarkMode,
        useGridView: useGridView ?? this.useGridView,
        searchBoxVisible: searchBoxVisible ?? this.searchBoxVisible,
        searchTerm: searchTerm ?? this.searchTerm,
        sortMethod: sortMethod ?? this.sortMethod,
        filterKey: filterKey ?? this.filterKey,
        filterBarVisible: filterBarVisible ?? this.filterBarVisible,
        resizeModalVisible: resizeModalVisible ?? this.resizeModalVisible,
        userColor: userColor ?? this.userColor,
        gridItemSize: gridItemSize ?? this.gridItemSize,
      );

  @override
  bool get isNotValid => !isValid;

  @override
  bool get isValid => !isNotValid;

  @override
  Map<String, dynamic> toJson() => {
        'useDarkMode': useDarkMode,
        'useGridView': useGridView,
        'searchBoxVisible': false,
        'filterBarVisible': false,
        'resizeModalVisible': false,
        'sortMethod': SortMethod.authorAsc.index,
        'filterKey': FilterKey.all.index,
        'searchTerm': '',
        'gridItemSize': gridItemSize,
        'userColor': userColor.toString().substring(6, 16),
      };

  @override
  SettingsStateRepository.fromJson(final dynamic json)
      : useDarkMode = json['useDarkMode'] as bool? ?? true,
        userColor = Color(json['userColor']),
        useGridView = json['useGridView'] as bool? ?? true,
        searchBoxVisible = json['searchBoxVisible'] as bool? ?? false,
        filterBarVisible = json['filterBarVisible'] as bool? ?? false,
        resizeModalVisible = false,
        searchTerm = json['searchTerm'] ?? '',
        gridItemSize = Entity.parseJsonDouble(json['gridItemSize'])!,
        sortMethod = SortMethod.values.elementAt(json['sortMethod']),
        filterKey = FilterKey.values.elementAt(json['filterKey']);
}
