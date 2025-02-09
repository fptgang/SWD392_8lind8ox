import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/cart/widget/cart_screen.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().white,
      appBar: AppBar(
        backgroundColor: getColorSkin().primaryRed650,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: getColorSkin().white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Carousel
            SizedBox(
              height: 300,
              child: PageView(
                children: [
                  Image.asset('assets/jpg/blind_box.jpg', fit: BoxFit.contain),
                  Image.asset('assets/jpg/blind_box.jpg', fit: BoxFit.contain),
                  Image.asset('assets/jpg/blind_box.jpg', fit: BoxFit.contain),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 80.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) => SizedBox(width: 16.w),
                itemBuilder: (context, index) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: getColorSkin().lightGrey200,
                    child: Image.asset('assets/jpg/blind_box.jpg'),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Labubu Blind Box",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: getColorSkin().black),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.from}: \$975.00",
                        style: TextStyle(
                            fontSize: 16, color: getColorSkin().black),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: getColorSkin().primaryRed200),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove,
                                  size: 20,
                                  color: getColorSkin().primaryRed800),
                              onPressed: () {},
                            ),
                            const Text(
                              "01",
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.add,
                                  size: 20,
                                  color: getColorSkin().primaryRed800),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...["La", "Bu", "Bu", "Baby", "Three"].map((type) {
                        return ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: type == "Baby"
                                ? getColorSkin().primaryRed600
                                : getColorSkin().primaryRed50,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 16,
                              color: type == "Baby"
                                  ? Colors.white
                                  : getColorSkin().primaryRed950,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)!.description,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Xin lưu ý: những sản phẩm này được gọi là Blind box' - bạn sẽ không thể chọn mẫu mà bạn sẽ nhận được. Bạn sẽ không biết mình nhận được gì cho đến khi mở nó ra. Sự bất ngờ sẽ là một gia vị không thể thiếu cho cuộc chơi thêm thú vị.",
                    style: TextStyle(color: getColorSkin().grey),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.readMore,
                        style: TextStyle(color: getColorSkin().primaryRed950)),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: getColorSkin().white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().white,
                    side: BorderSide(color: getColorSkin().primaryRed200),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.addToCart,
                    style: TextStyle(color: getColorSkin().primaryRed950),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().primaryRed650,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.shopNow,
                    style: TextStyle(color: getColorSkin().white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
