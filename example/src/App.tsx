import * as React from 'react';

import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  type TextStyle,
  type ViewStyle,
} from 'react-native';
import { multiply } from 'beek';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    multiply(3, 7).then(setResult);
  }, []);

  const onPressScanButton = () => {
    console.log(result);
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
});
