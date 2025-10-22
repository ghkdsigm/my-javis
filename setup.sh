#!/usr/bin/env bash
set -euo pipefail

APP_NAME="JarvisAndroid"
PROJECT_DIR="./JarvisAndroid"
BACKEND_SSE_URL="https://yourpc.ts.net:4000/api/chat/stream"
PORCUPINE_ACCESS_KEY="CHANGE_ME"

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --app-name) APP_NAME="$2"; shift 2;;
    --project-dir) PROJECT_DIR="$2"; shift 2;;
    --backend-sse-url) BACKEND_SSE_URL="$2"; shift 2;;
    --porcupine-access-key) PORCUPINE_ACCESS_KEY="$2"; shift 2;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

echo "[1/7] Create React Native project: $APP_NAME at $PROJECT_DIR"
npx react-native init "$APP_NAME"
if [[ "$PROJECT_DIR" != "./$APP_NAME" ]]; then
  mv "./$APP_NAME" "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

echo "[2/7] Install dependencies"
npm i react-native-voice react-native-tts @picovoice/porcupine-react-native react-native-event-source react-native-config

echo "[3/7] Write .env"
cat > .env <<EOF
BACKEND_SSE_URL=${BACKEND_SSE_URL}
PORCUPINE_ACCESS_KEY=${PORCUPINE_ACCESS_KEY}
EOF

echo "[4/7] Apply overlay sources"
mkdir -p src
cp -R ../overlay/src/* ./src/ 2>/dev/null || true
cp ../overlay/index.js ./index.js

# Ensure jsconfig.json for nicer editor behavior
cp ../overlay/jsconfig.json ./jsconfig.json

# Ensure android raw/ and xml files
mkdir -p android/app/src/main/res/raw
cp ../overlay/android/xml/network_security_config.xml android/app/src/main/res/xml/network_security_config.xml

echo "[5/7] Patch AndroidManifest.xml (permissions & network security)"
MANIFEST="android/app/src/main/AndroidManifest.xml"

# Insert permissions if missing
grep -q 'android.permission.RECORD_AUDIO' "$MANIFEST" || \
  sed -i'' '0,/<application/{s//<uses-permission android:name="android.permission.RECORD_AUDIO"\/>\n<uses-permission android:name="android.permission.POST_NOTIFICATIONS"\/>\n<uses-permission android:name="android.permission.INTERNET"\/>\n&/}' "$MANIFEST"

# Ensure application attributes for cleartext + network security (dev convenience)
if ! grep -q 'networkSecurityConfig' "$MANIFEST"; then
  sed -i'' 's/<application /<application android:usesCleartextTraffic="true" android:networkSecurityConfig="@xml\/network_security_config" /' "$MANIFEST"
fi

echo "[6/7] Patch android/build.gradle with Picovoice maven repo"
TOPGRADLE="android/build.gradle"
if ! grep -q 'https://github.com/Picovoice/maven' "$TOPGRADLE"; then
  sed -i'' '0,/mavenCentral()/{s//mavenCentral()\n        maven { url "https:\/\/github.com\/Picovoice\/maven" }\n/}' "$TOPGRADLE"
fi

echo "[7/7] Clean & build Android"
cd android
./gradlew clean
cd ..

echo "Done. Now run:"
echo "  npm start -- --reset-cache"
echo "  npm run android"
