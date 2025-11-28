// // ============================================
// // مثال على استخدام BuildCategoryList
// // ============================================

// // الاستخدام القديم (خطأ):
// // BuildCategoryList(categories: categories)

// // الاستخدام الصحيح الجديد:
// const BuildCategoryList()

// // ملاحظة: لا تحتاج لتمرير أي parameters لأن الـ widget 
// // يستخدم BlocBuilder داخلياً للحصول على البيانات من PlacesCubit


// // ============================================
// // مثال على استخدام BuildRecommendationList
// // ============================================

// // الاستخدام القديم (خطأ):
// // BuildRecommendationList(recommendations: state.topRecommendations)

// // الاستخدام الصحيح الجديد:
// const BuildRecommendationList()

// // ملاحظة: لا تحتاج لتمرير أي parameters لأن الـ widget 
// // يستخدم BlocBuilder داخلياً للحصول على البيانات من PlacesCubit


// // ============================================
// // الحالات التي يتم معالجتها تلقائياً
// // ============================================

// /*
// 1. PlacesLoading:
//    - BuildCategoryList: يعرض CategoryShimmer
//    - BuildRecommendationList: يعرض RecommendationShimmer

// 2. PlacesLoaded:
//    - BuildCategoryList: يعرض قائمة الفئات أو رسالة "No Categories Found"
//    - BuildRecommendationList: يعرض قائمة التوصيات أو رسالة "No Recommendations Available"

// 3. PlacesError:
//    - BuildCategoryList: يعرض رسالة "Failed to load categories"
//    - BuildRecommendationList: يعرض رسالة "Failed to load recommendations" مع زر Retry

// 4. PlacesInitial:
//    - BuildCategoryList: يعرض CategoryShimmer
//    - BuildRecommendationList: يعرض RecommendationShimmer
// */


// // ============================================
// // مثال كامل للاستخدام في صفحة
// // ============================================

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // عنوان الفئات
//               const Text('Browse By Category'),
//               const SizedBox(height: 12),
              
//               // قائمة الفئات - تعرض shimmer تلقائياً أثناء التحميل
//               const BuildCategoryList(),
              
//               const SizedBox(height: 24),
              
//               // عنوان التوصيات
//               const Text('Top Recommendations'),
//               const SizedBox(height: 10),
              
//               // قائمة التوصيات - تعرض shimmer تلقائياً أثناء التحميل
//               const BuildRecommendationList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // ============================================
// // ملاحظات مهمة
// // ============================================

// /*
// 1. تأكد من وجود PlacesCubit في الـ widget tree قبل استخدام هذه الـ widgets
//    مثال:
//    BlocProvider(
//      create: (context) => PlacesCubit(repository: repository)..loadPlaces(),
//      child: MyHomePage(),
//    )

// 2. لا تحتاج لاستخدام BlocBuilder أو BlocListener في الصفحة الرئيسية
//    لأن كل widget يدير حالته الخاصة

// 3. إذا أردت إعادة تحميل البيانات:
//    context.read<PlacesCubit>().reload()

// 4. جميع الـ shimmer effects تستخدم package shimmer: ^3.0.0
//    تأكد من وجوده في pubspec.yaml
// */
