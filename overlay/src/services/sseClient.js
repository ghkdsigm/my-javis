// 코드 주석에 이모티콘은 사용하지 않습니다.
import EventSource from 'react-native-event-source';
import { BACKEND_SSE_URL } from '../config/env';

export function openChatStream(text, onDelta, onTool, onClose) {
  const url = `${BACKEND_SSE_URL}?sessionId=android&text=${encodeURIComponent(text)}`;
  const es = new EventSource(url);

  es.onmessage = (e) => {
    try {
      const { text: delta } = JSON.parse(e.data);
      if (typeof delta === 'string') onDelta(delta);
    } catch {}
  };
  es.addEventListener('tool', (e) => {
    try {
      const data = JSON.parse(e.data);
      if (onTool) onTool(data);
    } catch {}
  });
  es.onerror = () => {
    es.close();
    if (onClose) onClose();
  };
  return () => es.close();
}
