// 코드 주석에 이모티콘은 사용하지 않습니다.
export function takeSpeakable(acc) {
  const parts = acc.split(/([.!?]\s+)/);
  if (parts.length > 2) {
    const speakable = parts.slice(0, parts.length - 2).join('');
    const rest = parts.slice(parts.length - 2).join('');
    return { speakable, rest };
  }
  return { speakable: '', rest: acc };
}
