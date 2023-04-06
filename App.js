import React, { useState, useEffect } from "react";
import {
  StyleSheet,
  Text,
  Button,
  TextInput,
  SafeAreaView,
  FlatList,
  Clipboard,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { NavigationContainer } from "@react-navigation/native";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import DOMParser from "react-native-html-parser";

function copyToClipboard(text) {
  console.log("Copying to clipboard");
  let result = text.replace(/,/g, "\n");
  Clipboard.setString(result);
}

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

async function storeWord(word, definition) {
  try {
    await AsyncStorage.setItem(capitalizeFirstLetter(word.trim()), definition);
  } catch (error) {
    console.error("Error saving the word locally");
    console.error(error);
  }
}

async function requestDefinition(word) {
  const storedDefinition = await AsyncStorage.getItem(word.trim());
  if (storedDefinition !== null) {
    console.log("Retrieving definition of " + word + " in AsyncStorage");
    return storedDefinition;
  } else {
    return await fetchDefinition(word);
  }
}

async function getAllData() {
  try {
    let allData = [];
    const keys = await AsyncStorage.getAllKeys();
    const result = await AsyncStorage.multiGet(keys);
    for (let i = 0; i < result.length; i++) {
      allData.push(result[i][0]);
    }
    return allData;
  } catch (error) {
    console.error(error);
  }
}

async function fetchDefinition(word) {
  console.log("Fetching definition for " + word);
  let url =
    "https://www.larousse.fr/dictionnaires/francais/" + word.toLowerCase();
  const response = await fetch(url, { redirect: "follow" });
  const html = await response.text();
  var parsedDocument = new DOMParser.DOMParser().parseFromString(
    html,
    "text/html"
  );
  const definitionsDiv = parsedDocument.getElementById("definition");
  if (definitionsDiv == null) {
    console.warn("Definition not found in Larousse");
    return "Definition not found";
  }
  let definitions = definitionsDiv.getElementsByClassName("DivisionDefinition");
  let merged_definitions = "";
  for (let i = 0; i < definitions.length; i++) {
    merged_definitions +=
      "\n\n" + definitions[i].textContent.replace(/[\t\r\n]/g, "");
  }
  let clean_definitions = merged_definitions
    .replace(/Synonyme :.*/g, "")
    .replace(/Synonymes :.*/g, "")
    .replace(/Contraire :.*/g, "")
    .replace(/Contraires :.*/g, "");
  storeWord(word, clean_definitions);
  return clean_definitions;
}

const Stack = createNativeStackNavigator();
const Tab = createBottomTabNavigator();

const HomeScreenNavigator = () => {
  return (
    <Stack.Navigator>
      <Stack.Screen
        name="HomeTab"
        component={HomeScreen}
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="DefinitionTab"
        component={DefinitionScreen}
        options={{ headerShown: false }}
      />
    </Stack.Navigator>
  );
};

const RevisionScreenNavigator = () => {
  return (
    <Stack.Navigator>
      <Stack.Screen
        name="RevisionTab"
        component={RevisionScreen}
        options={{ headerShown: false }}
      />
      <Stack.Screen
        name="DefinitionTab"
        component={DefinitionScreen}
        options={{ headerShown: false }}
      />
    </Stack.Navigator>
  );
};

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator>
        <Tab.Screen name="Home" component={HomeScreenNavigator} />
        <Tab.Screen name="Learning" component={RevisionScreenNavigator} />
        <Tab.Screen name="Export/Import" component={ExportScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}

const HomeScreen = ({ navigation }) => {
  const [word, onChangeWord] = useState("");
  return (
    <SafeAreaView style={styles.container}>
      <TextInput
        style={styles.input}
        onChangeText={onChangeWord}
        placeholder="Your word"
        value={word}
      />
      <Button
        title="Fetch definition"
        onPress={() => {
          // if (word) storeWord(word);
          navigation.navigate("DefinitionTab", {
            word: capitalizeFirstLetter(word),
          });
        }}
      />
    </SafeAreaView>
  );
};

const DefinitionScreen = ({ navigation, route }) => {
  const [printableDefinitions, setDefinition] = useState("");
  useEffect(() => {
    getDefinitions(route.params.word);
  }, []);
  const getDefinitions = async (word) => {
    setDefinition(await requestDefinition(word));
  };
  return (
    <SafeAreaView style={styles.container}>
      <Text>Definition of {route.params.word}</Text>
      <Text>{printableDefinitions}</Text>
    </SafeAreaView>
  );
};

const RevisionScreen = ({ navigation, route }) => {
  const [allWords, setAllWords] = useState([]);
  const [currentWord, setCurrentWord] = useState("");
  useEffect(() => {
    importData();
  }, []);
  const importData = async () => {
    let allData = await getAllData();
    setAllWords(allData);
    setCurrentWord(allData[Math.floor(Math.random() * allData.length)]);
  };
  return (
    <SafeAreaView style={styles.container}>
      <Text>{currentWord}</Text>
      <Button
        title="Fetch definition"
        onPress={() =>
          navigation.navigate("DefinitionTab", { word: currentWord })
        }
      />
      <Button
        title="Next"
        onPress={() => {
          let nextPosition = Math.floor(Math.random() * allWords.length);
          setCurrentWord(allWords[nextPosition]);
        }}
      />
      <Button
        title="Remove"
        onPress={async () => {
          console.log("Removing " + word + " from AsyncStorage");
          await AsyncStorage.removeItem(currentWord);
          setAllWords(allWords);
          let nextPosition = Math.floor(Math.random() * allWords.length);
          setCurrentWord(allWords[nextPosition]);
        }}
      />
    </SafeAreaView>
  );
};

const ExportScreen = () => {
  const [importList, onChangeImportList] = useState("");
  const [allWords, setAllWords] = useState([]);
  useEffect(() => {
    importData();
  }, []);
  const importData = async () => {
    setAllWords(await getAllData());
  };

  const storeList = async () => {
    importArray = importList.split("\n").filter((str) => str !== "");
    for (let i = 0; i < importArray.length; i++) {
      fetchDefinition(importArray[i]);
      // storeWord(importArray[i]);
    }
  };
  return (
    <SafeAreaView style={styles.container}>
      <FlatList
        data={allWords}
        renderItem={({ item }) => <Text>{item}</Text>}
      />
      <Button
        title="Export"
        onPress={() => copyToClipboard(allWords.toString())}
      />
      <TextInput
        style={styles.input}
        onChangeText={onChangeImportList}
        placeholder="Your list"
        value={importList}
      />
      <Button title="Import" onPress={() => storeList()} />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
    padding: "3%",
  },
});
