# flutter_clean_with_provider

A Flutter demo app (Login → User Profile) built with **Clean Architecture**,
using [reqres.in](https://reqres.in) as the backend.

## Features

- Clean Architecture: `domain` → `data` → `presentation` layers per feature
- **Provider** for state management
- **Dio** for networking, with centralized error handling for 400/401/403/404/500 and timeouts
- **GoRouter** for navigation, with a simple auth-redirect guard
- **internet_connection_checker** — blocks API calls when offline, and automatically retries a request that failed due to no internet once the connection is back **and** the user reopens that screen
- **pretty_dio_logger** for readable request/response logs in debug
- **flutter_screenutil** for responsive sizing
- **fluttertoast** for lightweight user-facing error messages
- Manual dependency injection (no `get_it`) via a single `InjectionContainer`

## Getting started

```bash
flutter pub get
flutter run
```

The login screen is pre-filled with reqres.in's test credentials:
`eve.holt@reqres.in` / `cityslicka` — just tap **Login**.

## Project structure

```
lib/
  core/                 # shared: error handling, network, DI, session, widgets
  features/
    auth/               # domain / data / presentation for login
    profile/            # domain / data / presentation for user profile
  routes/               # GoRouter config
  main.dart
```

See inline comments throughout the code for how each layer talks to the next
(`Screen → Provider → UseCase → Repository → DataSource`) and how errors are
mapped from Dio exceptions all the way up to user-facing messages.

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
