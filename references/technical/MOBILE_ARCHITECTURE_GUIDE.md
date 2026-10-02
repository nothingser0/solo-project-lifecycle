# Mobile-Specific Architecture Guide

> **Scope**: Push notifications, deep linking, app distribution, and mobile-specific concerns for iOS/Android native apps and React Native/Flutter cross-platform.

---

## 1. Push Notifications Architecture

### Platform Requirements

| Platform | Service | Setup Complexity | Cost |
|----------|---------|------------------|------|
| **iOS** | APNs (Apple Push Notification service) | High (certificates, provisioning) | Free |
| **Android** | FCM (Firebase Cloud Messaging) | Medium | Free (Firebase tier) |
| **Cross-platform** | OneSignal / Expo Notifications | Low (unified API) | Free <10K users |

---

### Implementation Ladder (Boring Tech First)

**Option A: Firebase Cloud Messaging (FCM)** - Recommended for most projects
- **Pros**: Unified API for iOS+Android, free tier generous, analytics included
- **Cons**: Google dependency, requires Firebase project setup
- **Best for**: MVP, small-medium apps (<100K users)

**Option B: OneSignal** - Best for feature-rich needs
- **Pros**: Richer segmentation, A/B testing, in-app messaging, scheduling
- **Cons**: Free tier limits (10K push subscribers), vendor lock-in
- **Best for**: Marketing-heavy apps, growth experiments

**Option C: AWS SNS + Platform SDKs** - Enterprise control
- **Pros**: No vendor lock-in, full control, scales infinitely
- **Cons**: Complex setup (APNs certs, FCM keys), no analytics
- **Best for**: Enterprise with existing AWS infrastructure

---

### Setup: Firebase Cloud Messaging (Recommended)

**Backend Setup** (Node.js example):
```bash
pnpm add firebase-admin
```

```typescript
// lib/firebase-admin.ts
import admin from 'firebase-admin';

admin.initializeApp({
  credential: admin.credential.cert({
    projectId: process.env.FIREBASE_PROJECT_ID,
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
  }),
});

export const messaging = admin.messaging();
```

**Send Notification**:
```typescript
// app/api/notifications/send/route.ts
import { messaging } from '@/lib/firebase-admin';

export async function POST(request: Request) {
  const { token, title, body, data } = await request.json();
  
  await messaging.send({
    token, // Device FCM token from client
    notification: {
      title,
      body,
    },
    data, // Custom payload (e.g., {"orderId": "12345"})
    apns: {
      payload: {
        aps: {
          sound: 'default',
          badge: 1,
        },
      },
    },
    android: {
      priority: 'high',
      notification: {
        sound: 'default',
        channelId: 'orders', // Android 8+ requires channel
      },
    },
  });
  
  return Response.json({ success: true });
}
```

---

### Client Setup

**React Native (Expo)**:
```bash
npx expo install expo-notifications expo-device expo-constants
```

```typescript
// hooks/usePushNotifications.ts
import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';
import { useEffect } from 'react';

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

export function usePushNotifications() {
  useEffect(() => {
    registerForPushNotificationsAsync();
    
    // Handle notification received while app foregrounded
    const subscription = Notifications.addNotificationReceivedListener(notification => {
      console.log('Notification received:', notification);
    });
    
    // Handle notification tapped
    const responseSubscription = Notifications.addNotificationResponseReceivedListener(response => {
      const data = response.notification.request.content.data;
      // Navigate to screen based on data (deep linking)
      if (data.orderId) {
        router.push(`/orders/${data.orderId}`);
      }
    });
    
    return () => {
      subscription.remove();
      responseSubscription.remove();
    };
  }, []);
}

async function registerForPushNotificationsAsync() {
  if (!Device.isDevice) {
    alert('Push notifications only work on physical devices');
    return;
  }
  
  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;
  
  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }
  
  if (finalStatus !== 'granted') {
    alert('Failed to get push token for push notification!');
    return;
  }
  
  const token = (await Notifications.getExpoPushTokenAsync({
    projectId: 'your-project-id', // From app.json
  })).data;
  
  // Send token to your backend
  await fetch('https://api.yourapp.com/users/me/push-token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ token }),
  });
}
```

**iOS Native (Swift)**:
```swift
// AppDelegate.swift
import UserNotifications

func application(_ application: UIApplication, 
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
    if granted {
      DispatchQueue.main.async {
        application.registerForRemoteNotifications()
      }
    }
  }
  return true
}

func application(_ application: UIApplication, 
                 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
  // Send token to backend
  APIClient.shared.updatePushToken(token)
}
```

**Android Native (Kotlin)**:
```kotlin
// MainActivity.kt
class MainActivity : AppCompatActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    
    FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
      if (!task.isSuccessful) {
        Log.w(TAG, "Fetching FCM registration token failed", task.exception)
        return@addOnCompleteListener
      }
      
      val token = task.result
      // Send to backend
      apiClient.updatePushToken(token)
    }
  }
}

// MyFirebaseMessagingService.kt
class MyFirebaseMessagingService : FirebaseMessagingService() {
  override fun onMessageReceived(remoteMessage: RemoteMessage) {
    // Handle notification data payload
    remoteMessage.data.isNotEmpty().let {
      val orderId = remoteMessage.data["orderId"]
      // Show notification or handle silently
    }
  }
}
```

---

### Notification Patterns

**Transactional** (time-sensitive, high priority):
- Order confirmation
- Payment success/failure
- Delivery updates
- Security alerts

**Marketing** (lower priority, can be batched):
- New feature announcements
- Promotional offers
- Content recommendations

**Segmentation**:
```typescript
// Backend: Send to users who haven't ordered in 7 days
const inactiveUsers = await db.users.findMany({
  where: {
    lastOrderAt: { lt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) },
    pushToken: { not: null },
  },
  select: { pushToken: true },
});

await messaging.sendEachForMulticast({
  tokens: inactiveUsers.map(u => u.pushToken),
  notification: {
    title: 'We miss you!',
    body: 'Get 20% off your next order',
  },
});
```

---

## 2. Deep Linking Architecture

### Universal Links (iOS) + App Links (Android)

**Purpose**: Open app from web URLs (email, SMS, social media)

**Example Flow**:
1. User taps `https://yourapp.com/orders/12345` in email
2. OS checks if app installed + domain verified
3. If yes: Opens app directly to order detail screen
4. If no: Opens web browser (fallback)

---

### Setup: Universal Links (iOS)

**Step 1: Apple App Site Association (AASA) file**

Host at: `https://yourapp.com/.well-known/apple-app-site-association`

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.yourapp.app",
        "paths": [
          "/orders/*",
          "/products/*",
          "/profile"
        ]
      }
    ]
  }
}
```

**Step 2: Xcode Configuration**

- Target → Signing & Capabilities → Add Capability → Associated Domains
- Add: `applinks:yourapp.com`

**Step 3: Handle in App (React Native)**

```typescript
// App.tsx
import { Linking } from 'react-native';
import { useEffect } from 'react';

function App() {
  useEffect(() => {
    // Handle initial URL (app opened from link)
    Linking.getInitialURL().then(url => {
      if (url) handleDeepLink(url);
    });
    
    // Handle URL while app running
    const subscription = Linking.addEventListener('url', ({ url }) => {
      handleDeepLink(url);
    });
    
    return () => subscription.remove();
  }, []);
  
  function handleDeepLink(url: string) {
    const route = url.replace(/.*?:\/\//g, ''); // yourapp.com/orders/123
    const [path, id] = route.split('/').slice(1); // ['orders', '123']
    
    if (path === 'orders' && id) {
      navigation.navigate('OrderDetail', { orderId: id });
    } else if (path === 'products' && id) {
      navigation.navigate('ProductDetail', { productId: id });
    }
  }
}
```

---

### Setup: App Links (Android)

**Step 1: Digital Asset Links file**

Host at: `https://yourapp.com/.well-known/assetlinks.json`

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.yourapp.app",
    "sha256_cert_fingerprints": [
      "YOUR_SHA256_FINGERPRINT_FROM_PLAY_CONSOLE"
    ]
  }
}]
```

**Step 2: AndroidManifest.xml**

```xml
<activity android:name=".MainActivity">
  <intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data 
      android:scheme="https"
      android:host="yourapp.com"
      android:pathPrefix="/orders" />
    <data 
      android:scheme="https"
      android:host="yourapp.com"
      android:pathPrefix="/products" />
  </intent-filter>
</activity>
```

**Step 3: Handle in App** (same as iOS code above)

---

### Deferred Deep Linking (Attribution)

**Problem**: User taps link → App not installed → Downloads from store → Opens app → **Context lost**

**Solution**: Branch.io / Firebase Dynamic Links / Adjust

**Example: Branch.io**

```typescript
// Backend: Generate attributed link
const branch = require('branch-sdk');

const link = await branch.link({
  data: {
    $desktop_url: 'https://yourapp.com/products/123',
    $ios_url: 'https://apps.apple.com/app/id123456',
    $android_url: 'https://play.google.com/store/apps/details?id=com.yourapp',
    productId: '123', // Custom data preserved after install
  },
});

// Send via email: link = "https://yourapp.app.link/abc123"
```

```typescript
// App: Retrieve data after install
import branch from 'react-native-branch';

branch.subscribe(({ params }) => {
  if (params['+clicked_branch_link']) {
    const productId = params.productId;
    // Navigate to product even if just installed
    navigation.navigate('ProductDetail', { productId });
  }
});
```

---

## 3. App Distribution & Updates

### iOS App Store

**Pre-Launch Checklist**:
- [ ] Apple Developer Account ($99/year)
- [ ] App Store Connect app created
- [ ] Provisioning profiles & certificates
- [ ] Privacy policy URL (required)
- [ ] App icon (1024×1024px)
- [ ] Screenshots (all required device sizes)
- [ ] App description (<4000 chars)

**Review Timeline**: 24-48 hours (average), can be 1-7 days

**Rejection Common Causes**:
- Crashescrashing on launch
- Missing functionality from screenshots
- Violates Design Guidelines (HIG)
- Incomplete privacy disclosures

**TestFlight Beta**:
- Internal testing: 100 testers (no review)
- External testing: 10,000 testers (requires review)
- 90-day build expiration

---

### Android Play Store

**Pre-Launch Checklist**:
- [ ] Google Play Console account ($25 one-time)
- [ ] App signing key (upload key + app signing key)
- [ ] Privacy policy URL
- [ ] Feature graphic (1024×500px)
- [ ] Screenshots (min 2, max 8 per device type)
- [ ] Content rating questionnaire

**Review Timeline**: Few hours to 7 days (faster than iOS)

**Internal/Closed Testing**:
- Internal: 100 testers (instant)
- Closed: Up to 100 email lists
- Open: Public beta track

---

### Over-the-Air (OTA) Updates

**For Non-Native Code** (React Native JS bundle, Flutter assets):

**CodePush (React Native)**:
```bash
npm install -g appcenter-cli
appcenter login
appcenter apps create -d MyApp-iOS -o iOS -p React-Native
```

```bash
# Deploy update (skips App Store review)
appcenter codepush release-react -a <username>/MyApp-iOS -d Production
```

**Limitations**:
- ❌ Cannot update native code (Swift/Kotlin)
- ❌ Cannot update app permissions
- ✅ Can update JS logic, UI, assets

**Expo Updates**:
```bash
eas update --branch production --message "Fix checkout bug"
```

---

### Force Update Strategy

**When to Force**:
- Critical security patch
- Breaking API changes
- Legal compliance requirement

**Implementation**:
```typescript
// Backend: /api/version/check
export async function GET() {
  return Response.json({
    minimumVersion: '1.2.0', // Force update below this
    latestVersion: '1.3.0',
    forceUpdate: true,
    updateMessage: 'Critical security update required',
  });
}
```

```typescript
// App: Check on launch
import { Alert, Linking } from 'react-native';
import DeviceInfo from 'react-native-device-info';

async function checkAppVersion() {
  const currentVersion = DeviceInfo.getVersion(); // '1.1.0'
  const response = await fetch('https://api.yourapp.com/version/check');
  const { minimumVersion, forceUpdate, updateMessage } = await response.json();
  
  if (forceUpdate && currentVersion < minimumVersion) {
    Alert.alert(
      'Update Required',
      updateMessage,
      [
        {
          text: 'Update Now',
          onPress: () => {
            const storeUrl = Platform.select({
              ios: 'https://apps.apple.com/app/id123456',
              android: 'https://play.google.com/store/apps/details?id=com.yourapp',
            });
            Linking.openURL(storeUrl);
          },
        },
      ],
      { cancelable: false }, // Cannot dismiss
    );
  }
}
```

---

## 4. Mobile-Specific Security

### Certificate Pinning (Prevent MITM)

**Problem**: Attacker intercepts HTTPS traffic with fake certificate

**Solution**: Pin expected server certificate in app

**React Native**:
```bash
pnpm add react-native-ssl-pinning
```

```typescript
import { fetch as sslFetch } from 'react-native-ssl-pinning';

await sslFetch('https://api.yourapp.com/data', {
  method: 'GET',
  sslPinning: {
    certs: ['mycert'], // mycert.cer in android/app/src/main/assets/
  },
});
```

---

### Secure Storage (Credentials, Tokens)

**Never use AsyncStorage for sensitive data** - plain text, accessible

**Use Keychain (iOS) / Keystore (Android)**:

```bash
pnpm add react-native-keychain
```

```typescript
import * as Keychain from 'react-native-keychain';

// Store
await Keychain.setGenericPassword('user', authToken, {
  service: 'com.yourapp.authtoken',
  accessible: Keychain.ACCESSIBLE.WHEN_UNLOCKED,
});

// Retrieve
const credentials = await Keychain.getGenericPassword({ service: 'com.yourapp.authtoken' });
if (credentials) {
  const token = credentials.password;
}
```

---

### Jailbreak/Root Detection

```bash
pnpm add jail-monkey
```

```typescript
import JailMonkey from 'jail-monkey';

if (JailMonkey.isJailBroken()) {
  Alert.alert('Security Warning', 'This app cannot run on jailbroken devices');
  // Disable sensitive features or exit
}
```

---

## 5. Module 10 Integration Checklist

**Add to M10 Deployment Module**:

- [ ] **Push Notifications Setup**:
  - [ ] FCM project created (iOS + Android)
  - [ ] APNs certificate uploaded to Firebase
  - [ ] Backend send endpoint tested (`/api/notifications/send`)
  - [ ] Test notification received on physical device
  - [ ] Notification permission prompt triggers correctly
  - [ ] Deep link navigation from notification works

- [ ] **Deep Linking Verified**:
  - [ ] AASA file hosted at `/.well-known/apple-app-site-association`
  - [ ] Asset Links file hosted at `/.well-known/assetlinks.json`
  - [ ] Universal Links tested (tap email link → opens app)
  - [ ] App Links tested (tap SMS link → opens app)
  - [ ] Fallback to web browser works if app not installed

- [ ] **App Store Submission**:
  - [ ] iOS: TestFlight build approved by internal testers
  - [ ] Android: Internal testing track validated
  - [ ] Privacy policy published and linked
  - [ ] Screenshots uploaded (all device sizes)
  - [ ] App description + keywords optimized
  - [ ] Content rating completed

- [ ] **OTA Updates Configured**:
  - [ ] CodePush/Expo Updates initialized
  - [ ] Force update logic implemented
  - [ ] Version check endpoint deployed

- [ ] **Mobile Security**:
  - [ ] Certificate pinning enabled (if API handles sensitive data)
  - [ ] Secure storage used for tokens (Keychain/Keystore)
  - [ ] Jailbreak detection enabled (if applicable)

---

**Created**: 2026-10-02  
**Version**: 1.0  
**Integration**: Add to M10 deployment checklist, M05 FSD mobile section
