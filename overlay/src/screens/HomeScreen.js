// 코드 주석에 이모티콘은 사용하지 않습니다.
import React from 'react';
import { View, Text, Button } from 'react-native';
import { useVoiceAgent } from '../hooks/useVoiceAgent';

export default function HomeScreen() {
  const { status, partial, startWake, stopAll } = useVoiceAgent();
  return (
    <View style={{ flex: 1, padding: 16, gap: 12 }}>
      <Text style={{ fontSize: 18, fontWeight: 'bold' }}>Jarvis Android</Text>
      <Text>상태: {status}</Text>
      <Text>부분 인식: {partial}</Text>
      <View style={{ height: 12 }} />
      <Button title="웨이크워드 시작" onPress={startWake} />
      <View style={{ height: 8 }} />
      <Button title="중지" onPress={stopAll} />
    </View>
  );
}
