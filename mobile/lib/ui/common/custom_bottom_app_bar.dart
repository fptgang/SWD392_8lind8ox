import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/core/theme/theme.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomAppBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double bottomBarHeight = screenSize.height * 0.11;

    return SizedBox(
      height: bottomBarHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(screenSize.width, bottomBarHeight),
            painter: BottomNavPainter(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: bottomBarHeight * 0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem('Home', Icons.home, selectedIndex == 0, screenSize, () => onItemSelected(0)),
                _buildNavItem('Search', Icons.search, selectedIndex == 1, screenSize, () => onItemSelected(1)),
                SizedBox(width: screenSize.width * 0.15), // Space for center item
                _buildNavItem('Features', Icons.star, selectedIndex == 3, screenSize, () => onItemSelected(3)),
                _buildNavItem('Account', Icons.person, selectedIndex == 4, screenSize, () => onItemSelected(4)),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: -bottomBarHeight * 0.25, // Raise the Cart icon
            child: Center(
              child: _buildCenterCartButton(screenSize, selectedIndex == 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, bool isSelected, Size screenSize, VoidCallback onTap) {
    final double iconSize = 24;
    final double fontSize = 12.sp;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: isSelected ? getColorSkin().primaryRed950 : Colors.grey,
          ),
          SizedBox(height: screenSize.height * 0.005),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: isSelected ? getColorSkin().primaryRed950 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterCartButton(Size screenSize, bool isSelected) {
    return GestureDetector(
      onTap: () => onItemSelected(2),
      child: Container(
        width: screenSize.width * 0.14,
        height: screenSize.width * 0.14,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? getColorSkin().primaryRed800 : getColorSkin().primaryRed600,
          borderRadius: BorderRadius.circular(screenSize.width * 0.07),
          boxShadow: [
            BoxShadow(
              color: getColorSkin().grey.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          Icons.shopping_cart,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }
}

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Start drawing the curve
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.35, 0);

    // Curve up
    path.quadraticBezierTo(
      size.width * 0.50, // Control point
      size.height * 0.6, // Control point height
      size.width * 0.65, // End point x
      0, // End point y
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
