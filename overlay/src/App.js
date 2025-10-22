// 코드 주석에 이모티콘은 사용하지 않습니다.
import React from 'react';
import { SafeAreaView, View, Text, Button } from 'react-native';
import HomeScreen from './screens/HomeScreen';

export default function App() {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={{ flex: 1 }}>
        <HomeScreen />
      </View>
    </SafeAreaView>
  );
}
