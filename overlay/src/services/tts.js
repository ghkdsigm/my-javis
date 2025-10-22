// 코드 주석에 이모티콘은 사용하지 않습니다.
import Tts from 'react-native-tts';

Tts.setDefaultLanguage('ko-KR');
Tts.setDucking(true);

export function speak(text) {
  if (!text || !text.trim()) return;
  Tts.speak(text);
}

export function stopSpeak() {
  Tts.stop();
}
