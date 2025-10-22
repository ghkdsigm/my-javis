// 코드 주석에 이모티콘은 사용하지 않습니다.
import { PorcupineManager } from '@picovoice/porcupine-react-native';
import { PORCUPINE_ACCESS_KEY } from '../config/env';

let manager = null;

export async function startWakeword(keyword = 'res/raw/hey_jarvis.ppn', param = 'res/raw/porcupine_params_ko.pv', onDetect) {
  if (manager) return;
  manager = await PorcupineManager.fromBuiltInKeywordPaths(PORCUPINE_ACCESS_KEY, [keyword], onDetect, param);
  await manager.start();
}

export async function stopWakeword() {
  if (!manager) return;
  try { await manager.stop(); } catch {}
  try { await manager.delete(); } catch {}
  manager = null;
}
