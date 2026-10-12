# AI Agent Guidelines - Flutter Project

## 0. Execution Protocol — One Task Per Turn (NON-NEGOTIABLE)

- **`TODO.md` is the queue.** Work its task list **one task at a time**.
- **Per task**: implement ONLY that task → run that task's `Verify` command → paste the raw output → report task ID + files touched + result → 🛑 **END TURN**.
- **Do NOT** start the next task, open a new sprint, or batch task IDs — unless the human names the specific task IDs to run in one instruction.
- **`[x]` is the human's mark, never yours.** Only after the human confirms may you record `Approved: <date> by <name>` in that task's `Evidence`.
- **If a spec, schema, or requirement is missing, STOP and ask** — never invent it to keep the queue moving.
- **Never run `git commit`, `git push`, or `git tag`** — hand the change to the human for review and commit.

---

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

## Anti-AI-Slop Directives (ENFORCED)
1. **BANNED: Redundant Explanatory Comments** — do not narrate obvious code.
   - ❌ `// Increment counter`  |  `// Import material`
   - ❌ Stub comments: `// TODO: implement this later`  |  `// Add your logic here`
   - ✅ Comment ONLY non-obvious business logic, domain formulas, or deliberate workarounds.
   - ✅ Never leave commented-out dead code — delete it (git remembers).
2. **BANNED: Silent Failures** — no empty catch/except blocks; log, rethrow, or return a typed error.
3. **BANNED: Dead Code & Unused Imports** — remove unused variables, imports, and unreachable branches.
4. **RACE CONDITIONS (MANDATORY for any shared-state mutation)** — protect every read-modify-write on inventory, balances, counters, booking slots, or status transitions:
   - Use a DB transaction + row lock (SELECT ... FOR UPDATE), or a unique constraint / idempotency key.
   - Never "check then act" across two separate queries without a lock or constraint.
   - Webhooks and payment callbacks MUST be idempotent (dedupe on provider event ID).
   - Frontend: disable the submit button while pending + use an idempotency key to prevent double-submit.
5. **BANNED: Hallucinated APIs/Packages** — verify every import exists before using it.

---

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
