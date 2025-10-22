# JarvisAndroid (React Native, Android-only) — Bootstrap Overlay

이 압축파일은 **React Native 프로젝트를 자동 생성하고, 웨이크워드/STT/TTS/SSE 연동**을 덮어씌우는 **오버레이**입니다.
iOS는 사용하지 않습니다(폴더는 생성되지만 무시).

## 준비물

-   Node.js 18.x 또는 20.x
-   JDK 17
-   Android Studio (SDK / platform-tools 설치)
-   ADB 사용 가능 상태
-   Picovoice(포큐파인) Access Key, 키워드(ppn), 파라미터(pv) 파일
-   Tailscale로 연결된 백엔드(SSE 엔드포인트)

## 빠른 설치 (Windows PowerShell)

```powershell
# 1) 압축을 푼 폴더에서 실행
.\setup.ps1 -AppName "JarvisAndroid" -ProjectDir ".\JarvisAndroid" `
  -BackendSseUrl "https://yourpc.ts.net:4000/api/chat/stream" `
  -PorcupineAccessKey "YOUR_PICOVOICE_ACCESS_KEY"
```

## 빠른 설치 (macOS/Linux bash)

```bash
# 1) 압축을 푼 폴더에서 실행
bash setup.sh   --app-name JarvisAndroid   --project-dir ./JarvisAndroid   --backend-sse-url https://yourpc.ts.net:4000/api/chat/stream   --porcupine-access-key YOUR_PICOVOICE_ACCESS_KEY
```

## 실행

```bash
cd JarvisAndroid
npm start -- --reset-cache
npm run android
```

실기기 USB 디버깅 허용 또는 에뮬레이터를 실행하세요.

## Porcupine 리소스 배치

생성된 프로젝트 경로:

```
JarvisAndroid/android/app/src/main/res/raw/
```

여기에 아래 파일 2개를 복사하세요:

-   `porcupine_params_ko.pv` (또는 사용 언어 파라미터 .pv)
-   `hey_jarvis.ppn` (당신이 생성한 키워드 파일명)

## 주의

-   코드 주석에 이모티콘은 사용하지 않습니다.
-   셋업 스크립트는 AndroidManifest와 build.gradle에 필요한 설정을 자동으로 삽입합니다.
-   문제가 생기면 `android/gradlew clean` 후 재시도하세요.

##폴더경로
A터미널

1. cd "D:\workspace_2\my-javis\JarvisAndroid"
2. Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass >> .\setup.ps1 -AppName "JarvisAndroid" -ProjectDir ".\JarvisAndroid" >> -BackendSseUrl "https://yourpc.ts.net:4000/api/chat/stream" >> -PorcupineAccessKey "YOUR_PICOVOICE_ACCESS_KEY" (셋팅)
3. npm start -- --reset-cache

B터미널

1. cd "D:\workspace_2\my-javis\JarvisAndroid"
2. npm run android
