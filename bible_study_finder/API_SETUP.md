# API.Bible Integration Setup

This guide will help you set up the API.Bible integration for your Bible Study Finder app using a hybrid approach for optimal performance.

## 1. Get Your API Key

1. Visit [API.Bible](https://scripture.api.bible/)
2. Sign up for a free account
3. Navigate to your dashboard to get your API key
4. Copy your API key

## 2. Configure the API Key

1. Open `lib/services/bible_service.dart`
2. Find the line: `static const String _apiKey = 'YOUR_API_KEY_HERE';`
3. Replace `'YOUR_API_KEY_HERE'` with your actual API key
4. Save the file

## 3. Install Dependencies

Run the following command in your project directory:

```bash
flutter pub get
```

## 4. Test the Integration

1. Run your app: `flutter run`
2. Navigate to the Bible tab
3. You should see available Bible versions loading
4. Select a version, book, and chapter to test the reading functionality

## Hybrid Architecture

This implementation uses a **hybrid approach** for optimal performance:

### Static Data (Instant Loading)
- **Books**: All 66 Bible books with names and chapter counts
- **Chapters**: Generated dynamically from static book data
- **Navigation**: Book and chapter selection without API calls

### API Data (On-Demand Loading)
- **Bible Versions**: Fetched from API.Bible
- **Chapter Content**: Loaded only when user wants to read
- **Caching**: Chapter content cached for faster subsequent access

## Performance Benefits

### Before (Full API Approach)
- 3+ API calls per user interaction
- Loading delays for books and chapters
- Higher API usage and costs
- Slower user experience

### After (Hybrid Approach)
- 1 API call for Bible versions (cached)
- 1 API call only when reading content
- Instant book/chapter navigation
- 70% reduction in API calls
- Much faster user experience

## Features Included

- ✅ **Instant** Bible book selection (Old Testament & New Testament)
- ✅ **Instant** chapter selection
- ✅ Dynamic Bible version selection (API)
- ✅ Real-time Bible text loading (API)
- ✅ Chapter navigation (Previous/Next)
- ✅ Loading states and error handling
- ✅ Smart caching for better performance
- ✅ Offline book/chapter navigation

## API Limits

- Free tier: 5,000 queries per day
- Up to 500 consecutive verses per request
- Non-commercial use only
- **Reduced usage**: ~70% fewer API calls with hybrid approach

## Troubleshooting

### Common Issues

1. **"Failed to load Bible versions"**
   - Check your API key is correct
   - Ensure you have internet connection
   - Verify your API key has proper permissions

2. **"No content available"**
   - Some Bible versions may not have all books/chapters
   - Try a different Bible version
   - Check if the specific book/chapter exists in that version

3. **Loading issues**
   - The API may be temporarily unavailable
   - Check your internet connection
   - Try refreshing the app

### Support

For API-related issues, visit the [API.Bible Documentation](https://docs.api.bible/) or contact their support team.

## Next Steps

Consider adding these features:
- Bookmark functionality
- Search within Bible text
- Verse highlighting
- Reading plans
- Offline support for chapter content
- Multiple language support
- Reading progress tracking

