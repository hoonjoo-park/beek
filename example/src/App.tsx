import * as React from 'react';

import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  type TextStyle,
  type ViewStyle,
} from 'react-native';
import { openScanner } from 'beek';

export default function App() {
  const onPressScanButton = () => {
    openScanner();
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Beek</Text>

      <TouchableOpacity style={styles.scanButton} onPress={onPressScanButton}>
        <Text style={styles.buttonText}>Start Scanning</Text>
      </TouchableOpacity>
    </View>
  );
}

type Style = {
  container: ViewStyle;
  title: TextStyle;
  scanButton: ViewStyle;
  buttonText: TextStyle;
  nativeTitleView: ViewStyle;
};

const styles = StyleSheet.create<Style>({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#fff',
  },
  title: {
    marginBottom: 20,
    fontSize: 24,
    fontWeight: '700',
  },
  scanButton: {
    height: 48,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 20,
    paddingVertical: 10,
    backgroundColor: '#ff5500',
    borderRadius: 8,
  },
  buttonText: {
    fontSize: 17,
    fontWeight: '500',
    color: '#fff',
  },
  nativeTitleView: {
    width: 100,
    height: 100,
    backgroundColor: 'red',
  },
});
