/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
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


import { NativeModules,NativeEventEmitter } from 'react-native';

export const RNRefiner = NativeModules.RNRefiner;

export const RNRefinerEventEmitter = new NativeEventEmitter(RNRefiner);


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

 var userTraits = { email: 'hello@hello.com', a_number: 123, a_date: '2022-16-04 12:00:00' };

  RNRefiner.initialize('56421950-5d32-11ea-9bb4-9f1f1a987a49', false);

  RNRefiner.identifyUser('my-user-id', userTraits, null, null, null);

  RNRefiner.showForm('616fc500-5d32-11ea-8fd5-f140dbcb9780', true);

  var contextualData = { some_data: "hello", some_more_data: "hello again" };
  
  RNRefiner.addToResponse(contextualData)

  RNRefinerEventEmitter.addListener('onBeforeShow', (event) => {
    console.log('onBeforeShow');
    console.log(event.formId);
    console.log(event.formConfig);
  });

  RNRefinerEventEmitter.addListener('onNavigation', (event) => {
    console.log('onNavigation');
    console.log(event.formId);
    console.log(event.formElement);
    console.log(event.progress);
  });

  RNRefinerEventEmitter.addListener('onShow', (event) => {
    console.log('onShow');
    console.log(event.formId);
  });

  RNRefinerEventEmitter.addListener('onDismiss', (event) => {
    console.log('onDismiss');
    console.log(event.formId);
  });

  RNRefinerEventEmitter.addListener('onClose', (event) => {
    console.log('onClose');
    console.log(event.formId);
  });

  RNRefinerEventEmitter.addListener('onComplete', (event) => {
    console.log('onComplete');
    console.log(event.formId);
    console.log(event.formData);
  });

    RNRefinerEventEmitter.addListener('onError', (event) => {
    console.log('onError');
    console.log(event.message);
  });

  const isDarkMode = useColorScheme() === 'dark';

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
