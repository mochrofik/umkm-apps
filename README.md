# UMKM Store - Flutter Application

A modern and robust mobile application built with Flutter for UMKM (Micro, Small, and Medium Enterprises) management. This app provides a seamless experience for users to manage categories, products, and authentication.

---

## 🚀 Key Features

- **Complete Authentication**: Supports manual login and registration as well as **Google Sign-In** integration.
- **State Management**: Solid implementation of **Bloc (flutter_bloc)** for separation of business logic and UI.
- **Master Data**: Organized product category management.
- **Modern Design**: Clean and responsive UI using a custom color scheme.
- **Local Storage**: Uses `shared_preferences` for session management and user preferences.
- **API Integration**: Efficient data communication using **Dio**.
- **Geolocation**: Location tracking feature for store mapping or location-based services.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **Language**: [Dart](https://dart.dev)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Auth**: [google_sign_in](https://pub.dev/packages/google_sign_in)
- **Utility**: [equatable](https://pub.dev/packages/equatable), [geolocator](https://pub.dev/packages/geolocator)

---

## 📂 Project Structure

```text
lib/
├── bloc/            # Business logic (State, Event, Bloc)
├── constans/        # Constant variables and configuration
├── model/           # Data models (POJO)
├── repository/      # Data fetching handling (API/Local)
├── screen/          # App pages (Login, Home, Category, etc.)
├── services/        # Supporting services (Auth, Storage, API Service)
├── utils/           # Helper classes (GlobalColor, Formatters)
├── widgets/         # Reusable UI components
└── main.dart        # Application entry point
```

---

## 🏁 Getting Started

### Prerequisites

- Flutter SDK (Latest version recommended)
- Android Studio / VS Code
- Internet connection (to fetch dependencies)

### Installation

1. **Clone this repository**

   ```bash
   git clone https://github.com/mochrofik/umkm-apps.git
   ```

2. **Enter the project directory**

   ```bash
   cd umkm_app
   ```

3. **Install dependencies**

   ```bash
   flutter pub get
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

---

## ⚙️ API Configuration

This application connects to a Laravel backend. You can adjust the API base URL in the following file:
`lib/constans/Constans.dart`

---

## 📝 Contributing

Contributions are always welcome! Please fork this repository and create a pull request for new features or bug fixes.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

**Made with ❤️ by [mochrofik](https://github.com/mochrofik)**
