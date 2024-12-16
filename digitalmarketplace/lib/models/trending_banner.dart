import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingBanner extends StatefulWidget {
  final String title;
  final String imagePath;
  
  const TrendingBanner({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  _TrendingBannerState createState() => _TrendingBannerState();
}

class _TrendingBannerState extends State<TrendingBanner> with AutomaticKeepAliveClientMixin {

  bool _isLiked = false;
  
  @override
  bool get wantKeepAlive => true; 

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Container(
      width: 400,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(widget.imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.title,
                style: GoogleFonts.spicyRice(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}