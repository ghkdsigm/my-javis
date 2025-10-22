// 코드 주석에 이모티콘은 사용하지 않습니다.
import { useEffect, useRef, useState } from 'react';
import { PermissionsAndroid, Platform } from 'react-native';
import { startWakeword, stopWakeword } from '../services/wakeword';
import { attachHandlers, startSTT, stopSTT } from '../services/stt';
import { openChatStream } from '../services/sseClient';
import { speak, stopSpeak } from '../services/tts';
import { takeSpeakable } from '../utils/sentenceSplit';

export function useVoiceAgent() {
  const [status, setStatus] = useState('idle');
  const [partial, setPartial] = useState('');
  const accRef = useRef('');

  useEffect(() => {
    if (Platform.OS === 'android') {
      PermissionsAndroid.requestMultiple([
        PermissionsAndroid.PERMISSIONS.RECORD_AUDIO,
        PermissionsAndroid.PERMISSIONS.POST_NOTIFICATIONS,
      ]);
    }
    attachHandlers(
      (t) => setPartial(t),
      (t) => onFinal(t),
      () => setStatus('idle')
    );
    return () => { stopSpeak(); stopSTT(); stopWakeword(); };
  }, []);

  async function startWake() {
    setStatus('wake');
    await startWakeword('res/raw/hey_jarvis.ppn', 'res/raw/porcupine_params_ko.pv', onWake);
  }

  async function onWake() {
    await stopWakeword();
    setStatus('listen');
    accRef.current = '';
    stopSpeak();
    speak('네, 말씀하세요.');
    await startSTT('ko-KR');
  }

  async function onFinal(text) {
    await stopSTT();
    setStatus('stream');
    const close = openChatStream(
      text,
      (delta) => {
        accRef.current += delta;
        const { speakable, rest } = takeSpeakable(accRef.current);
        if (speakable.trim()) speak(speakable);
        accRef.current = rest;
      },
      () => speak('요청을 처리했습니다.'),
      () => {
        if (accRef.current.trim()) speak(accRef.current);
        setStatus('idle');
        startWake();
      }
    );
    return close;
  }

  async function stopAll() {
    await stopSTT();
    await stopWakeword();
    stopSpeak();
    setStatus('idle');
  }

  return { status, partial, startWake, stopAll };
}
