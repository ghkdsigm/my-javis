// 코드 주석에 이모티콘은 사용하지 않습니다.
import Voice from '@react-native-voice/voice';

export function attachHandlers(onPartial, onFinal, onError) {
  Voice.onSpeechPartialResults = (e) => onPartial(e.value?.[0] ?? '');
  Voice.onSpeechResults = (e) => onFinal(e.value?.[0] ?? '');
  Voice.onSpeechError = () => onError();
}

export async function startSTT(locale = 'ko-KR') {
  await Voice.start(locale, { EXTRA_PARTIAL_RESULTS: true });
}

export async function stopSTT() {
  try { await Voice.stop(); } catch {}
}
