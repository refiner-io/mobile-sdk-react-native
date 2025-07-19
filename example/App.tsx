/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useEffect} from 'react';
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

import {NativeModules, NativeEventEmitter} from 'react-native';

const {RNRefiner} = NativeModules;
const refinerEventEmitter = new NativeEventEmitter(RNRefiner);

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

  useEffect(() => {
    // User traits object
    const userTraits = {
      email: 'hello@hello.com',
      a_number: 123,
      a_date: '2022-16-04 12:00:00',
    };

    // Identify user
    RNRefiner.identifyUser('my-user-id', userTraits, null, null);


    // Add contextual data
    const contextualData = {
      some_data: 'hello',
      some_more_data: 'hello again',
    };

    RNRefiner.addToResponse(contextualData);

    // Show form
    RNRefiner.showForm('616fc500-5d32-11ea-8fd5-f140dbcb9780', true);

    // Event listeners setup
    const beforeShowListener = refinerEventEmitter.addListener(
      'onBeforeShow',
      event => {
        console.log('onBeforeShow');
        console.log(event.formId);
        console.log(event.formConfig);
      },
    );

    const navigationListener = refinerEventEmitter.addListener(
      'onNavigation',
      event => {
        console.log('onNavigation');
        console.log(event.formId);
        console.log(event.formElement);
        console.log(event.progress);
      },
    );

    const showListener = refinerEventEmitter.addListener('onShow', event => {
      console.log('onShow');
      console.log(event.formId);
    });

    const dismissListener = refinerEventEmitter.addListener(
      'onDismiss',
      event => {
        console.log('onDismiss');
        console.log(event.formId);
      },
    );

    const closeListener = refinerEventEmitter.addListener('onClose', event => {
      console.log('onClose');
      console.log(event.formId);
    });

    const completeListener = refinerEventEmitter.addListener(
      'onComplete',
      event => {
        console.log('onComplete');
        console.log(event.formId);
        console.log(event.formData);
      },
    );

    const errorListener = refinerEventEmitter.addListener('onError', event => {
      console.log('onError');
      console.log(event.message);
    });

    // Cleanup function to remove listeners when component unmounts
    return () => {
      beforeShowListener.remove();
      navigationListener.remove();
      showListener.remove();
      dismissListener.remove();
      closeListener.remove();
      completeListener.remove();
      errorListener.remove();
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
