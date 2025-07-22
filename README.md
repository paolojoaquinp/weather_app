# Flutter Weather App

A mobile application developed in Flutter that provides real-time weather information with a modern and user-friendly interface.

## 📱 Features

- **Current Weather**: Real-time weather information
- **Extended Forecast**: Weather forecast for the upcoming days
- **Location Search**: Find weather for any city
- **Geolocation**: Automatic weather based on your current location
- **Modern Interface**: Intuitive and responsive design
- **Multiple Units**: Celsius/Fahrenheit, km/h, mph
- **Dark/Light Mode**: Adaptive theme based on preferences

## 🚀 Installation

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_weather_app.git
   cd flutter_weather_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**
   - Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
   - Create a `.env` file in the project root
   - Add your API key:
     ```
     WEATHER_API_KEY=your_api_key_here
     ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── weather_model.dart
│   └── forecast_model.dart
├── services/                 # Services and APIs
│   ├── weather_service.dart
│   └── location_service.dart
├── screens/                  # Application screens
│   ├── home_screen.dart
│   ├── search_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Reusable components
│   ├── weather_card.dart
│   ├── forecast_item.dart
│   └── custom_app_bar.dart
├── utils/                    # Utilities and helpers
│   ├── constants.dart
│   └── helpers.dart
└── themes/                   # Themes and styles
    ├── app_theme.dart
    └── colors.dart
```

## 📦 Main Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0              # HTTP requests
  geolocator: ^10.1.0       # Geolocation
  flutter_dotenv: ^5.1.0    # Environment variables
  provider: ^6.1.1          # State management
  cached_network_image: ^3.3.0  # Image caching
  intl: ^0.19.0             # Internationalization
```

## 🌐 API Used

This project uses the [OpenWeatherMap API](https://openweathermap.org/api) to get weather data:

- **Current Weather Data**: Current weather information
- **5 Day Weather Forecast**: 5-day forecast
- **Geocoding API**: Convert city names to coordinates

## 📱 Screenshots

| Main Screen | Search | Settings |
|:-----------:|:------:|:--------:|
| *[Add screenshot]* | *[Add screenshot]* | *[Add screenshot]* |

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the project root:

```env
WEATHER_API_KEY=your_openweathermap_api_key
BASE_URL=https://api.openweathermap.org/data/2.5
```

### Permissions

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show local weather.</string>
```

## 🧪 Testing

Run tests with:

```bash
# Unit tests
flutter test

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 🚀 Build and Deploy

### Android
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## 👨‍💻 Author

**Paolo Joaquin P**
- GitHub: [@paolojoaquinp](https://github.com/paolojoaquinp)

## 🙏 Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for providing the weather API
- [Flutter Team](https://flutter.dev/) for the amazing framework
- Flutter community for resources and documentation

---

⭐ If you like this project, give it a star!
