# JarvisAndroid (React Native, Android-only) — Bootstrap Overlay

이 압축파일은 **React Native 프로젝트를 자동 생성하고, 웨이크워드/STT/TTS/SSE 연동**을 덮어씌우는 **오버레이**입니다.
iOS는 사용하지 않습니다(폴더는 생성되지만 무시).

## 폴더구조

JarvisAndroid/
├─ android/
│ └─ app/src/main/
│ ├─ AndroidManifest.xml # 권한/usesCleartextTraffic 추가한 곳
│ └─ res/xml/network_security_config.xml
├─ ios/ # iOS는 안 써도 기본 생성됨
├─ web/ # 웹 프리뷰 전용
│ ├─ index.html
│ ├─ webpack.config.js
│ └─ shims/
│ ├─ empty.js # 네이티브 모듈 목 처리
│ └─ tts-web.js # 브라우저 SpeechSynthesis 대체
├─ src/
│ ├─ App.js
│ ├─ components/ # 공용 UI 컴포넌트(옵션)
│ ├─ screens/ # 화면 단위(옵션)
│ ├─ utils/
│ │ └─ sentenceSplit.js
│ ├─ services/
│ │ ├─ sseClient.ts # SSE 연결/이벤트 처리(옵션)
│ │ ├─ wakeword.js
│ │ ├─ stt.ts # STT 래퍼(옵션; 웹에선 목)
│ │ └─ tts.ts # TTS 래퍼(장치/웹 분기)
│ ├─ hooks/
│ │ └─ useVoiceAgent.ts # 스트림 훅(옵션)
│ └─ config/
│ └─ env.js
├─ assets/ # 아이콘/사운드 등(옵션)
├─ App.tsx # 기본 화면(입력→SSE→문장단위 TTS)
├─ index.js # RN 엔트리(기본)
├─ index.web.js # 웹 엔트리
├─ .env # BACKEND_SSE_URL=...
├─ package.json
├─ babel.config.js
├─ metro.config.js
├─ react-native.config.js # 필요 시(폰트/네이티브 설정 등)
└─ tsconfig.json # TS 사용 시

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

##작업전 웹화면체크
1.npm run web
2.localhost:8080
