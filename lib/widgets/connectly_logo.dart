import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConnectlyLogo extends StatelessWidget {
  final double fontSize;
  final bool showIcon;

  const ConnectlyLogo({
    super.key,
    this.fontSize = 24,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showIcon) ...[
          Container(
            padding: EdgeInsets.all(fontSize * 0.2),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPink.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.connect_without_contact_rounded,
              color: Colors.white,
              size: fontSize * 0.75,
            ),
          ),
          SizedBox(width: fontSize * 0.35),
        ],
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'Connectly',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Colors.white, // Masked by shader
            ),
          ),
        ),
      ],
    );
  }
}
