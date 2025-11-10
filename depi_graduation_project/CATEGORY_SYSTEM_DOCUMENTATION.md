# نظام تصنيف الأماكن - Browse by Category

## نظرة عامة
يقوم النظام بجلب الأماكن القريبة من موقع المستخدم الحالي، ثم يصنفها تلقائياً إلى فئات مختلفة بناءً على نوع المكان.

## آلية العمل

### 1. جلب الأماكن القريبة
- يتم استخدام Google Places API لجلب الأماكن القريبة
- النطاق الحالي: 5 كيلومتر من موقع المستخدم
- الملف: `lib/core/utils/constants/api_constants.dart`

### 2. تصنيف الأماكن
يتم تصنيف الأماكن تلقائياً بناءً على الأولوية التالية (من الأعلى للأقل):

1. **المتاحف** (museum) - أعلى أولوية للأماكن الثقافية
2. **المكتبات** (library)
3. **السينما ودور العرض** (movie_theater, cinema)
4. **المساجد** (mosque)
5. **الأماكن التاريخية والدينية** (church, synagogue, hindu_temple, place_of_worship)
6. **المطاعم** (restaurant, food, meal_takeaway, meal_delivery)
7. **الكافيهات** (cafe, coffee_shop)
8. **الفنادق** (lodging, hotel, resort, hostel)
9. **الحدائق والمنتزهات** (park, amusement_park, aquarium, zoo)
10. **مراكز التسوق** (shopping_mall, shopping_center, department_store)
11. **المعالم السياحية** (tourist_attraction)
12. **نقاط الاهتمام العامة** (point_of_interest) - تُصنف كمعالم سياحية
13. **أخرى** (others) - للأماكن غير المصنفة

الملف: `lib/features/home/data/models/place_model.dart` - دالة `_detectCategory()`

### 3. تجميع الأماكن حسب الفئات
- يتم تجميع الأماكن في خريطة (Map) حيث المفتاح هو اسم الفئة والقيمة هي قائمة الأماكن
- الملف: `lib/features/home/presentation/cubit/places_cubit.dart` - دالة `_groupByCategory()`

### 4. عرض الفئات
- يتم عرض الفئات التي تحتوي على أماكن فقط
- فئة "Others" تظهر في النهاية دائماً
- الملف: `lib/features/home/presentation/views/widgets/build_category_list.dart`

### 5. عرض الأماكن داخل الفئة
- عند الضغط على فئة معينة، يتم الانتقال إلى صفحة تعرض جميع الأماكن في هذه الفئة
- الملف: `lib/features/home/presentation/views/places_list_view.dart`

### 6. عرض تفاصيل المكان
- عند الضغط على مكان معين، يتم جلب تفاصيله من Google Places API
- يتم عرض: الصورة، التقييم، العنوان، رقم الهاتف، الموقع الإلكتروني، الوصف، التقييمات
- الملف: `lib/features/home/presentation/views/place_details_view.dart`

## الفئات المدعومة

| المفتاح | الاسم العربي | الاسم الإنجليزي |
|---------|-------------|-----------------|
| tourist_attraction | معالم سياحية | Tourist Attractions |
| historical | أماكن تاريخية | Historical Places |
| museum | متاحف | Museums |
| restaurant | مطاعم | Restaurants |
| cafe | كافيهات | Cafes |
| hotel | فنادق | Hotels |
| park | حدائق | Parks |
| shopping_mall | مراكز تسوق | Shopping Malls |
| library | مكتبات | Libraries |
| mosque | مساجد | Mosques |
| cinema | سينما | Cinemas |
| others | أخرى | Others |

الملف: `lib/core/utils/constants/app_constants.dart`

## ملاحظات مهمة

1. **الأولوية في التصنيف**: إذا كان المكان يحتوي على أكثر من نوع (مثلاً مطعم وكافيه)، سيتم تصنيفه حسب الأولوية الأعلى
2. **النطاق الجغرافي**: يمكن تعديل النطاق من ملف `api_constants.dart`
3. **التصنيف التلقائي**: يتم التصنيف تلقائياً بناءً على البيانات المستلمة من Google Places API
4. **فئة Others**: أي مكان لا يطابق الفئات المحددة يتم وضعه في فئة "Others"

## التحسينات المطبقة

### التحسين الأول: إصلاح منطق التصنيف
- **المشكلة**: كان يرجع `'other'` بدلاً من `'others'`
- **الحل**: تم تصحيح القيمة المرجعة لتطابق المفتاح في `AppConstants`

### التحسين الثاني: إضافة دعم لجميع الفئات
- **المشكلة**: لم يكن يدعم بعض الفئات مثل `library`, `cinema`, `mosque`
- **الحل**: تم إضافة دعم كامل لجميع الفئات المحددة في `AppConstants`

### التحسين الثالث: تحسين الأولويات
- **المشكلة**: الأولويات كانت عشوائية
- **الحل**: تم ترتيب الأولويات بشكل منطقي من الأكثر تحديداً للأقل

### التحسين الرابع: تحسين API endpoint
- **المشكلة**: كان يستخدم `type` parameter بشكل غير صحيح
- **الحل**: تم إزالة `type` parameter للسماح بجلب جميع الأماكن القريبة، ثم تصنيفها في التطبيق

## كيفية الاختبار

1. تأكد من تفعيل GPS على الجهاز
2. امنح التطبيق إذن الوصول للموقع
3. افتح الصفحة الرئيسية
4. انتظر تحميل الأماكن القريبة
5. تحقق من ظهور الفئات المختلفة
6. اضغط على فئة معينة للتحقق من الأماكن داخلها
7. اضغط على مكان معين للتحقق من تفاصيله

## الملفات المعدلة

1. `lib/features/home/data/models/place_model.dart` - تحسين دالة `_detectCategory()`
2. `lib/core/utils/constants/api_constants.dart` - تحسين API endpoint

## الملفات ذات الصلة (بدون تعديل)

1. `lib/features/home/presentation/cubit/places_cubit.dart` - منطق تجميع الأماكن
2. `lib/features/home/presentation/views/widgets/build_category_list.dart` - عرض الفئات
3. `lib/features/home/presentation/views/places_list_view.dart` - عرض الأماكن داخل الفئة
4. `lib/features/home/presentation/views/place_details_view.dart` - عرض تفاصيل المكان
5. `lib/core/utils/constants/app_constants.dart` - تعريف الفئات
