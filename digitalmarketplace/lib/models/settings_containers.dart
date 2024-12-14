import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class SettingsContainers extends StatelessWidget {
  final Widget navigateTo;
  final String sectionTitle;
  const SettingsContainers({super.key, required this.navigateTo, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          width: 385,
          height: 65,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 190, 169, 227), borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                 sectionTitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: onSecondaryColor,
                  size: 24.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
