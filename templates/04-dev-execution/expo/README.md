# Expo / React Native M06 Guide

Use this path when the FSD locks Expo as the React Native framework. The M06
version gate currently supports Expo projects using npm and a committed
`package-lock.json`.

## Scaffold and pin

1. Read the exact Expo package pin and target SDK from `docs/specs/FSD.md`.
2. Create the project with the Expo template compatible with that locked SDK;
   do not use an unpinned SDK template that silently moves the project forward.
3. Install the FSD-locked `expo` package using npm and commit
   `package-lock.json`.
4. Keep the FSD entry machine-readable in `Framework Versions (Pinned)`:
   `- Expo: X.Y.Z` (the exact `expo` package version).
5. Run the M06 version gate. It compares the FSD and lockfile major.minor,
   then runs `npx expo install --check` and `npx expo-doctor@latest`.

## Development and verification

- Define lint, typecheck, unit test, and build scripts from the project's actual
  tooling; do not assume every Expo project has the same scripts.
- Verify app routes and native behavior with the project's Expo development
  build or a physical/simulated device. A web build alone does not verify native
  behavior.
- Keep platform-specific configuration and native modules aligned with the
  FSD. Re-run Expo compatibility checks after dependency changes.
- For CI, adapt the commented Expo section in
  `templates/04-dev-execution/PROJECT_CI_TEMPLATE.yml` and use `npm ci`.

## Optional EAS Build

EAS cloud builds are opt-in. Before enabling them, the project must select the
platform and build profile, configure `eas.json`, and provide the required
project and signing credentials. Treat cloud builds as a separate workflow
because they may consume paid build capacity. See the [EAS CI build guide](https://docs.expo.dev/build/building-on-ci/)
and [pre-packaged EAS workflows](https://docs.expo.dev/eas/workflows/pre-packaged-jobs/).

## Official checks

- [`expo install --check`](https://docs.expo.dev/more/expo-cli/)
- [Expo project creation](https://docs.expo.dev/get-started/create-a-project/)
- [EAS CI builds](https://docs.expo.dev/build/building-on-ci/)
