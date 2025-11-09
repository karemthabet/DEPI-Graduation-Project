# Places Feature - Implementation Summary

## Overview
This document describes the complete implementation of the nearby places feature using Google Places API.

## Features Implemented

### 1. **Fetch Nearby Places**
- Uses Google Places API with user's current location (latitude, longitude)
- Radius: 5000 meters for relevant nearby results
- Filters by specific types: tourist attractions, museums, restaurants, cafes, parks, shopping malls, hotels

### 2. **Smart Categorization**
Places are automatically categorized into:
- 🏛️ Tourist Attractions
- 🏛️ Historical Places
- 🏛️ Museums
- 🍽️ Restaurants
- ☕ Cafes
- 🏨 Hotels
- 🌳 Parks
- 🛍️ Shopping Malls

**Category Detection Logic:**
- Priority-based matching (museums > cafes > restaurants > hotels > parks > shopping malls > historical > tourist attractions)
- Multiple type checking for better accuracy
- Fallback to "other" for unmatched types

### 3. **Dynamic Category Display**
- Only shows categories that have at least one place
- Displays count badge on each category
- Empty state when no categories available
- Loading state while fetching data

### 4. **Places List View**
**Features:**
- Modern card-based UI design
- Place images with fallback for missing photos
- Name, address, and rating display
- Smooth navigation to details
- Error handling with retry option
- Empty state with icon

### 5. **Place Details View**
**Features:**
- Collapsible SliverAppBar with hero image
- Rating badge
- Information cards for:
  - 📍 Address
  - 📞 Phone number
  - 🌐 Website
- Description/Overview section
- Reviews section (up to 5 reviews)
- Prominent "Open in Google Maps" button

**Google Maps Integration:**
- Uses `url_launcher` package
- Opens directions in Google Maps app
- Format: `https://www.google.com/maps/dir/?api=1&destination=lat,lng`
- Error handling if Maps cannot be opened

### 6. **Location Permissions**
**Handled by LocationService:**
- Checks if location service is enabled
- Requests permission if denied
- Handles permanently denied permissions
- Clear error messages in Arabic
- Retry dialog in HomeView

## Architecture

### Data Flow
```
User Location → Google Places API → PlacesRepository → PlacesCubit → UI
```

### Key Components

#### **PlacesCubit**
- `loadPlaces()`: Fetches nearby places and categorizes them
- `loadPlaceDetails(placeId)`: Fetches detailed information for a place
- States: Initial, Loading, Loaded, DetailsLoaded, Error

#### **PlacesRepository**
- Abstract interface for data operations
- Implementation uses Dio for HTTP requests
- Error handling with Either<Failure, Success>

#### **PlaceModel**
- Represents a place with all necessary fields
- Factory constructor for JSON parsing
- Category detection logic
- Support for reviews and photos

#### **LocationService**
- Singleton pattern
- Handles GPS and permission checks
- Returns Position with lat/lng

## UI Components

### HomeViewBody
- Initializes places loading on mount
- Shows error dialog for location/permission issues
- Displays category list with BlocBuilder

### BuildCategoryList
- Filters available categories
- Shows count badge
- Passes PlacesCubit to next screen

### PlacesListView
- Card-based layout
- Image loading with error handling
- Rating display
- Navigation to details

### PlaceDetailsView
- SliverAppBar with expandable image
- Organized information sections
- Review cards with avatars
- Google Maps button

## API Configuration

### Endpoints
```dart
// Nearby Places
GET /place/nearbysearch/json
Parameters:
  - location: lat,lng
  - radius: 5000
  - type: tourist_attraction|museum|restaurant|cafe|park|shopping_mall|lodging
  - key: API_KEY

// Place Details
GET /place/details/json
Parameters:
  - place_id: string
  - fields: name,rating,formatted_address,geometry,photos,website,
           formatted_phone_number,reviews,editorial_summary,opening_hours
  - key: API_KEY
```

### Photo URL Format
```
https://maps.googleapis.com/maps/api/place/photo
?maxwidth=400
&photoreference=PHOTO_REFERENCE
&key=API_KEY
```

## Dependencies
```yaml
dependencies:
  flutter_bloc: ^9.1.1
  dio: ^5.9.0
  geolocator: ^10.1.0
  url_launcher: ^6.3.2
  flutter_screenutil: ^5.9.3
  dartz: ^0.10.1
  get_it: ^8.2.0
```

## Permissions Required

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby places</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to show nearby places</string>
```

## Error Handling

### Location Errors
- GPS disabled: "خدمة الموقع غير مفعّلة. الرجاء تشغيل الـ GPS."
- Permission denied: "تم رفض إذن الوصول إلى الموقع."
- Permission denied forever: "تم رفض إذن الوصول إلى الموقع نهائيًا."

### Network Errors
- Connection timeout
- Server errors
- Invalid response
- Handled by ServerFailure class

### UI Error States
- Empty states with icons and messages
- Retry buttons
- Error dialogs with retry option
- Loading indicators

## Testing Checklist

- [ ] Location permission request works
- [ ] Nearby places load correctly
- [ ] Categories filter properly
- [ ] Category count badges show correct numbers
- [ ] Place list displays with images
- [ ] Place details load all information
- [ ] Google Maps button opens directions
- [ ] Error handling works for all scenarios
- [ ] Loading states display correctly
- [ ] UI is responsive on different screen sizes

## Future Enhancements

1. **Search Functionality**
   - Search by place name
   - Filter by category
   - Sort by distance/rating

2. **Favorites**
   - Save favorite places
   - Local storage with Hive/SharedPreferences

3. **Offline Support**
   - Cache place data
   - Show cached results when offline

4. **Map View**
   - Show places on Google Maps
   - Cluster markers
   - Custom markers per category

5. **More Details**
   - Opening hours
   - Price level
   - More photos gallery
   - User photos

6. **Social Features**
   - Share places
   - Add personal reviews
   - Upload photos

## Notes

- API key is currently hardcoded (should be moved to environment variables)
- Radius is set to 5000m (can be made configurable)
- Maximum 5 reviews shown (can be expanded with "Show More")
- Images use maxwidth=400 for list, 800 for details (optimized for performance)
