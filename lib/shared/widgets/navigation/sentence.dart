import 'package:flutter/material.dart';

class SentenceComponent extends StatelessWidget {
  final AnimationController controller;
  final bool isExpanded;

  const SentenceComponent({
    super.key,
    required this.controller,
    required this.isExpanded,
  });

  // Breakpoints definition
  static const double mobilePortraitBreakpoint = 400;
  static const double mobileLandscapeBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  // Get device type
  DeviceType _getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobilePortraitBreakpoint) {
      return DeviceType.mobilePortrait;
    } else if (width < mobileLandscapeBreakpoint) {
      return DeviceType.mobileLandscape;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // Get responsive values based on device type
  ResponsiveValues _getResponsiveValues(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobilePortrait:
        return ResponsiveValues(
          maxWidth: 350,
          maxHeightFactor: 0.6,
          contentHeightFactor: 0.35,
          margin: 4.0,
          padding: 4.0,
          spacing: 4.0,
          buttonSize: 24.0,
          borderRadius: 8.0,
          fontSize: 12.0,
          saveButtonHeight: 28.0,
          saveButtonWidthFactor: 0.3,
        );
      case DeviceType.mobileLandscape:
        return ResponsiveValues(
          maxWidth: 450,
          maxHeightFactor: 0.8,
          contentHeightFactor: 0.4,
          margin: 6.0,
          padding: 6.0,
          spacing: 6.0,
          buttonSize: 28.0,
          borderRadius: 10.0,
          fontSize: 13.0,
          saveButtonHeight: 32.0,
          saveButtonWidthFactor: 0.25,
        );
      case DeviceType.tablet:
        return ResponsiveValues(
          maxWidth: 600,
          maxHeightFactor: 0.7,
          contentHeightFactor: 0.35,
          margin: 8.0,
          padding: 8.0,
          spacing: 8.0,
          buttonSize: 32.0,
          borderRadius: 12.0,
          fontSize: 14.0,
          saveButtonHeight: 36.0,
          saveButtonWidthFactor: 0.2,
        );
      case DeviceType.desktop:
        return ResponsiveValues(
          maxWidth: 800,
          maxHeightFactor: 0.6,
          contentHeightFactor: 0.3,
          margin: 12.0,
          padding: 12.0,
          spacing: 10.0,
          buttonSize: 36.0,
          borderRadius: 15.0,
          fontSize: 16.0,
          saveButtonHeight: 40.0,
          saveButtonWidthFactor: 0.15,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) return const SizedBox.shrink();

    final deviceType = _getDeviceType(context);
    final values = _getResponsiveValues(deviceType);
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(values.margin),
          constraints: BoxConstraints(
            maxWidth: values.maxWidth,
            maxHeight: screenSize.height * values.maxHeightFactor,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF99C6E5),
            borderRadius: BorderRadius.circular(values.borderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMainContent(context, values),
              _buildSaveButton(context, values),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ResponsiveValues values) {
    final screenSize = MediaQuery.of(context).size;
    final deviceType = _getDeviceType(context);

    // Khusus untuk android portrait, gunakan fixed height yang lebih kecil
    final contentHeight = deviceType == DeviceType.mobilePortrait
        ? 150.0 // Fixed height untuk portrait mode
        : screenSize.height * values.contentHeightFactor;

    return Container(
      padding: EdgeInsets.all(values.padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: contentHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(values.borderRadius / 2),
              ),
            ),
          ),
          SizedBox(width: values.spacing),
          _buildControlButtons(context, values),
        ],
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context, ResponsiveValues values) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCircularButton(Icons.play_arrow, values),
        SizedBox(height: values.spacing),
        _buildCircularButton(Icons.stop, values),
        SizedBox(height: values.spacing),
        _buildCircularButton(Icons.pause, values),
      ],
    );
  }

  Widget _buildCircularButton(IconData icon, ResponsiveValues values) {
    return Container(
      width: values.buttonSize,
      height: values.buttonSize,
      decoration: BoxDecoration(
        color: const Color(0xFF19A7CE),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: values.buttonSize * 0.5,
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, ResponsiveValues values) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth = screenSize.width * values.saveButtonWidthFactor;

    return Padding(
      padding: EdgeInsets.only(bottom: values.padding),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF354EAB),
          minimumSize: Size(buttonWidth, values.saveButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(values.borderRadius),
          ),
        ),
        child: Text(
          'Simpan',
          style: TextStyle(
            color: Colors.white,
            fontSize: values.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Enums and classes for responsive design
enum DeviceType {
  mobilePortrait,
  mobileLandscape,
  tablet,
  desktop,
}

class ResponsiveValues {
  final double maxWidth;
  final double maxHeightFactor;
  final double contentHeightFactor;
  final double margin;
  final double padding;
  final double spacing;
  final double buttonSize;
  final double borderRadius;
  final double fontSize;
  final double saveButtonHeight;
  final double saveButtonWidthFactor;

  ResponsiveValues({
    required this.maxWidth,
    required this.maxHeightFactor,
    required this.contentHeightFactor,
    required this.margin,
    required this.padding,
    required this.spacing,
    required this.buttonSize,
    required this.borderRadius,
    required this.fontSize,
    required this.saveButtonHeight,
    required this.saveButtonWidthFactor,
  });
}
