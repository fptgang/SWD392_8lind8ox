
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/cart/widget/cart_screen.dart';
import 'package:mobile/ui/core/theme/theme.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().lightGrey100,
      appBar: AppBar(
        backgroundColor: getColorSkin().transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: getColorSkin().black),
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
                  const Text(
                    "Labubu Blind Box",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        "From: \$975.00",
                        style: TextStyle(fontSize: 16, color: getColorSkin().grey),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: getColorSkin().grey),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {},
                            ),
                            const Text(
                              "01",
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
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
                            backgroundColor: type == "Bu"
                                ? getColorSkin().accentColor
                                : getColorSkin().lightGrey200,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 16,
                              color: type == "Bu" ? Colors.black : getColorSkin().black,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  const Text(
                    "Xin lưu ý: những sản phẩm này được gọi là Blind box' - bạn sẽ không thể chọn mẫu mà bạn sẽ nhận được. Bạn sẽ không biết mình nhận được gì cho đến khi mở nó ra. Sự bất ngờ sẽ là một gia vị không thể thiếu cho cuộc chơi thêm thú vị.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Read more", style: TextStyle(color: getColorSkin().primaryColor)),
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: getColorSkin().backgroundColor,
                            side: BorderSide(color: getColorSkin().grey),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(color: getColorSkin().black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: getColorSkin().accentColor,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Text(
                            "Buy Now",
                            style: TextStyle(color:getColorSkin().black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
