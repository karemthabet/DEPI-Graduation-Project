import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';

class CategoriesViewDetailsBody extends StatefulWidget {
  final ItemModel itemModel;
  const CategoriesViewDetailsBody({super.key, required this.itemModel});

  @override
  State<CategoriesViewDetailsBody> createState() =>
      _CategoriesViewDetailsBodyState();
}

class _CategoriesViewDetailsBodyState extends State<CategoriesViewDetailsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.itemModel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: '${item.image}_${item.name}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                  child: Image.network(
                    item.image,
                    height: 330.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),

              // ===== المربع الأصفر اللي فيه التفاصيل =====
              Positioned(
                bottom: 0,
                left: 20.w,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF9CF),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    item.location,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '10:30 AM - 9:30 PM',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '• Open Now',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Row(
                                  children: [
                                    Text(
                                      item.rating,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 14.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.grey[700],
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ===== الـ Tabs =====
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [Tab(text: 'Description'), Tab(text: 'Reviews')],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ---- Description ----
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Timeless Wonders of Egypt',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---- Reviews ----
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow.shade700),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sarah Ahmed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Absolutely breathtaking! Seeing the Pyramids in person felt like stepping back in time.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[800],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE66D),
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text(
                'Find Your Way',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
