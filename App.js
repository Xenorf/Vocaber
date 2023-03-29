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
  console.log("copying to clipboard");
  let result = text.replace(/,/g, "\n");
  Clipboard.setString(result);
}

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

async function storeWord(word) {
  try {
    await AsyncStorage.setItem(capitalizeFirstLetter(word.trim()), "");
  } catch (error) {
    console.error("Error saving the word locally");
    console.error(error);
  }
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
        <Tab.Screen name="Revision" component={RevisionScreenNavigator} />
        <Tab.Screen name="Export" component={ExportScreen} />
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
          if (word) storeWord(word);
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
    console.log("GET DEFINITIONS");
    let url =
      "https://www.larousse.fr/dictionnaires/francais/" + word.toLowerCase();
    console.log(url);
    const response = await fetch(url, { redirect: "follow" });
    const html = await response.text();
    var parsedDocument = new DOMParser.DOMParser().parseFromString(
      html,
      "text/html"
    );
    const definitionsDiv = parsedDocument.getElementById("definition");
    if (definitionsDiv == null) {
      setDefinition("Definition not found");
      console.log("Definition not found");
      await AsyncStorage.removeItem(word);
      return;
    }
    definitions = definitionsDiv.getElementsByClassName("DivisionDefinition");
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
    console.log(clean_definitions);
    console.log("DEFINITIONS GET");
    setDefinition(clean_definitions);
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
    try {
      let tmpWords = [];
      const keys = await AsyncStorage.getAllKeys();
      const result = await AsyncStorage.multiGet(keys);
      for (let i = 0; i < result.length; i++) {
        tmpWords.push(result[i][0]);
      }
      console.log(tmpWords);
      setAllWords(tmpWords);
      setCurrentWord(tmpWords[0]);
    } catch (error) {
      console.error(error);
    }
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
          nextPosition = Math.floor(Math.random() * (allWords.length - 1));
          currentPosition = allWords.indexOf(currentWord);
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
    try {
      let tmpWords = [];
      const keys = await AsyncStorage.getAllKeys();
      const result = await AsyncStorage.multiGet(keys);
      console.log(result);
      for (let i = 0; i < result.length; i++) {
        tmpWords.push(result[i][0]);
      }
      console.log(tmpWords);
      setAllWords(tmpWords);
    } catch (error) {
      console.error(error);
    }
  };

  const storeList = async () => {
    importArray = importList.split("\n").filter((str) => str !== "");
    for (let i = 0; i < importArray.length; i++) {
      console.log(importArray[i]);
      storeWord(importArray[i]);
    }
  };
  return (
    <SafeAreaView style={styles.container}>
      <FlatList
        data={allWords}
        renderItem={({ item }) => <Text>{item}</Text>}
      />
      <TextInput
        style={styles.input}
        onChangeText={onChangeImportList}
        placeholder="Your list"
        value={importList}
      />
      <Button title="Import" onPress={() => storeList()} />
      <Button
        title="Export"
        onPress={() => copyToClipboard(allWords.toString())}
      />
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
