param(
  [string]$AppName = "JarvisAndroid",
  [string]$ProjectDir = ".\JarvisAndroid",
  [string]$BackendSseUrl = "https://yourpc.ts.net:4000/api/chat/stream",
  [string]$PorcupineAccessKey = "CHANGE_ME"
)

$ErrorActionPreference = "Stop"

Write-Host "[1/7] Create React Native project: $AppName at $ProjectDir"
npx react-native init $AppName
if ($ProjectDir -ne ".\${AppName}") {
  Move-Item ".\${AppName}" $ProjectDir -Force
}

Set-Location $ProjectDir

Write-Host "[2/7] Install dependencies"
npm i react-native-voice react-native-tts @picovoice/porcupine-react-native react-native-event-source react-native-config

Write-Host "[3/7] Write .env"
@"
BACKEND_SSE_URL=$BackendSseUrl
PORCUPINE_ACCESS_KEY=$PorcupineAccessKey
"@ | Out-File -Encoding utf8 .\.env

Write-Host "[4/7] Apply overlay sources"
New-Item -ItemType Directory -Force -Path .\src | Out-Null
Copy-Item ..\overlay\src\* .\src\ -Recurse -Force
Copy-Item ..\overlay\index.js .\index.js -Force
Copy-Item ..\overlay\jsconfig.json .\jsconfig.json -Force

New-Item -ItemType Directory -Force -Path .\android\app\src\main\res\raw | Out-Null
New-Item -ItemType Directory -Force -Path .\android\app\src\main\res\xml | Out-Null
Copy-Item ..\overlay\android\xml\network_security_config.xml .\android\app\src\main\res\xml\network_security_config.xml -Force

Write-Host "[5/7] Patch AndroidManifest.xml"
$manifest = ".\android\app\src\main\AndroidManifest.xml"
$content = Get-Content $manifest -Raw
if ($content -notmatch "android.permission.RECORD_AUDIO") {
  $content = $content -replace "<application", '<uses-permission android:name="android.permission.RECORD_AUDIO"/>' + "`r`n" + '<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>' + "`r`n" + '<uses-permission android:name="android.permission.INTERNET"/>' + "`r`n" + "<application"
}
if ($content -notmatch "networkSecurityConfig") {
  $content = $content -replace "<application ", '<application android:usesCleartextTraffic="true" android:networkSecurityConfig="@xml/network_security_config" '
}
Set-Content $manifest -Value $content -Encoding UTF8

Write-Host "[6/7] Patch android/build.gradle"
$topGradle = ".\android\build.gradle"
$gradle = Get-Content $topGradle -Raw
if ($gradle -notmatch "https://github.com/Picovoice/maven") {
  $gradle = $gradle -replace "mavenCentral\(\)", "mavenCentral()`n        maven { url 'https://github.com/Picovoice/maven' }"
}
Set-Content $topGradle -Value $gradle -Encoding UTF8

Write-Host "[7/7] Clean & build Android"
Set-Location .\android
./gradlew clean
Set-Location ..

Write-Host "Done. Now run:"
Write-Host "  npm start -- --reset-cache"
Write-Host "  npm run android"
