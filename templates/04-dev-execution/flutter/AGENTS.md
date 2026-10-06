# AI Agent Guidelines - Flutter Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Flutter**: https://docs.flutter.dev/
- **Dart**: https://dart.dev/guides
- **State Management**: Check your choice (Riverpod, Bloc, Provider)
- **Platform Channels**: https://docs.flutter.dev/platform-integration/platform-channels

**Why**: Flutter releases new versions frequently. This project uses:
- Flutter SDK version (check pubspec.yaml)
- Dart version (check pubspec.yaml)

### Version-Specific Syntax Enforcement

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Widgets** | https://docs.flutter.dev/ui/widgets | Widget API evolves |
| **State Management** | Framework-specific | Patterns differ (Riverpod vs Bloc) |
| **Navigation** | https://docs.flutter.dev/ui/navigation | Router patterns change |
| **Platform APIs** | https://docs.flutter.dev/platform-integration | Platform channel signature |

**Enforcement Rules**:
1. Check Flutter version: `flutter --version`
2. Use `flutter pub outdated` to check package versions
3. Test on both iOS and Android
4. Follow Material Design or Cupertino guidelines

## Code Style Rules
1. **camelCase**: Variables, methods, parameters
2. **PascalCase**: Classes, enums, typedefs
3. **lowercase_with_underscores**: Libraries, file names
4. **Const Constructors**: Use const where possible (performance)
5. **Widget Composition**: Break large widgets into smaller ones

## State Management
- **Choose One**: Riverpod (recommended), Bloc, Provider, GetX
- **Immutable State**: Use immutable data classes
- **Separation**: UI widgets separate from business logic
- **Testing**: Mock state providers for unit tests

## Database
- **Local**: SQLite (sqflite), Hive, or Isar
- **Remote**: HTTP client (dio or http package)
- **Caching**: Store data locally for offline support

## Testing
- **Unit**: Test business logic with `flutter test`
- **Widget**: Test UI components with WidgetTester
- **Integration**: Test full app flows with integration_test
- **Golden**: Visual regression tests

## Security
- **API Keys**: Store in .env (not in source code)
- **Secure Storage**: Use flutter_secure_storage for tokens
- **SSL Pinning**: Implement for sensitive apps
- ❌ No secrets in pubspec.yaml or source code

## Build Commands
- **Dev**: `flutter run` (debug mode)
- **Release**: `flutter build apk` or `flutter build ios`
- **Analyze**: `flutter analyze`
- **Format**: `dart format lib/`
- **Test**: `flutter test`

## Platform-Specific
- **iOS**: Xcode required, configure signing in Xcode
- **Android**: Configure gradle, signing keys in android/app/build.gradle
- **Permissions**: Add to AndroidManifest.xml and Info.plist
- **App Icons**: Use flutter_launcher_icons package

## Performance
- **Build Modes**: Debug (hot reload), Release (optimized)
- **Avoid Rebuilds**: Use const constructors, keys, and memoization
- **Images**: Use cached_network_image for network images
- **Lists**: Use ListView.builder for long lists (lazy loading)
