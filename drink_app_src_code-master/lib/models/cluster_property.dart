import 'package:flutter/widgets.dart';

class ClusterProperty {
  ClusterProperty(
      {this.minClusterZoom,
      this.maxClusterZoom,
      this.clusterColor,
      this.currentZoom,
      this.clusterWidth,
      this.clusterTextColor});
  final int minClusterZoom;
  final int maxClusterZoom;
  final Color clusterColor;
  final Color clusterTextColor;
  double currentZoom;
  final int clusterWidth;
}
