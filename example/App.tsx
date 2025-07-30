/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useEffect, useState} from 'react';
import type {PropsWithChildren} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

import RNRefiner from 'refiner-react-native';
import {NativeEventEmitter} from 'react-native';

const RNRefinerEventEmitter = new NativeEventEmitter(RNRefiner);

type SectionProps = PropsWithChildren<{
  title: string;
}>;

function Section({children, title}: SectionProps): JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {title}
      </Text>
      <Text
        style={[
          styles.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark,
          },
        ]}>
        {children}
      </Text>
    </View>
  );
}

function App(): JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';
  const [isModuleLoaded, setIsModuleLoaded] = useState(false);

  useEffect(() => {
    // Check module availability
    if (!RNRefiner) {
      return;
    }

    setIsModuleLoaded(true);

    // IMPORTANT: Set up event listeners BEFORE initializing the SDK
    // This prevents the "Sending event with no listeners registered" warnings
    // The order matters: listeners -> initialize -> SDK operations
    let listeners: any[] = [];

    if (RNRefinerEventEmitter) {
      const beforeShowListener = RNRefinerEventEmitter.addListener(
        'onBeforeShow',
        (event: any) => {
          console.log('onBeforeShow');
          console.log(event.formId);
          console.log(event.formConfig);
        },
      );

      const navigationListener = RNRefinerEventEmitter.addListener(
        'onNavigation',
        (event: any) => {
          console.log('onNavigation');
          console.log(event.formId);
          console.log(event.formElement);
          console.log(event.progress);
        },
      );

      const showListener = RNRefinerEventEmitter.addListener(
        'onShow',
        (event: any) => {
          console.log('onShow');
          console.log(event.formId);
        },
      );

      const dismissListener = RNRefinerEventEmitter.addListener(
        'onDismiss',
        (event: any) => {
          console.log('onDismiss');
          console.log(event.formId);
        },
      );

      const closeListener = RNRefinerEventEmitter.addListener(
        'onClose',
        (event: any) => {
          console.log('onClose');
          console.log(event.formId);
        },
      );

      const completeListener = RNRefinerEventEmitter.addListener(
        'onComplete',
        (event: any) => {
          console.log('onComplete');
          console.log(event.formId);
          console.log(event.formData);
        },
      );

      const errorListener = RNRefinerEventEmitter.addListener(
        'onError',
        (event: any) => {
          console.log('onError');
          console.log(event.message);
        },
      );

      // Store listeners for cleanup
      listeners = [
        beforeShowListener,
        navigationListener,
        showListener,
        dismissListener,
        closeListener,
        completeListener,
        errorListener,
      ];
    }

    try {
      // User traits object
      const userTraits = {
        email: 'hello@hello.com',
        a_number: 123,
        a_date: '2022-16-04 12:00:00',
      };

      // Identify user
      RNRefiner.identifyUser('my-user-id', userTraits, null, null, null);

      // Add contextual data
      const contextualData = {
        some_data: 'hello',
        some_more_data: 'hello again',
      };

      RNRefiner.addToResponse(contextualData);

      RNRefiner.showForm('616fc500-5d32-11ea-8fd5-f140dbcb9780', true);
    } catch (error) {
      // Handle error silently
    }

    // Cleanup function to remove listeners when component unmounts
    return () => {
      listeners.forEach(listener => listener.remove());
    };
  }, []); // Empty dependency array means this runs once on mount

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <Header />
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          <Section title="Step One">
            Edit <Text style={styles.highlight}>App.tsx</Text> to change this
            screen and then come back to see your edits.
          </Section>
          <Section title="See Your Changes">
            <ReloadInstructions />
          </Section>
          <Section title="Debug">
            <DebugInstructions />
          </Section>
          <Section title="Learn More">
            Read the docs to discover what to do next:
          </Section>
          <LearnMoreLinks />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
