# Vocaber

<p align="left">
  <img src="assets/icon/app_icon.png" alt="Vocaber App Icon" width="200"/>
</p>

*Stop guessing. Start learning, one word at a time.*

<a href="https://play.google.com/store/apps/details?id=fr.xenorf.vocaber">
  <img src="docs/google-play.svg" alt="Get it on Google Play" style="height: 60px; display: block; margin-bottom: 10px;" />
</a>
<a href="https://apps.apple.com/app/id1234567890">
  <img src="docs/app-store-unavailable.svg" alt="App Store Unavailable" style="height: 60px; display: block;" />
</a>


## ✨ Features

<table>
  <tr>
    <td style="vertical-align: top; padding-right: 15px;">
      <img src="docs/demo.gif" width="220" />
    </td>
    <td style="vertical-align: top;">
      <ul>
        <li>🔍 <strong>Instant Definitions:</strong> Search for words and get definitions in multiple languages.</li>
        <li>⏰ <strong>Spaced Repetition:</strong> Review your words at optimal intervals, making your learning more efficient.</li>
        <li>📊 <strong>Progress Tracking:</strong> See your streak, XP, and review stats.</li>
        <li>🖼️ <strong>Custom Profile:</strong> Personalize your username and avatar.</li>
        <li>📤 <strong>Export/Import:</strong> Backup or transfer your vocabulary with one tap.</li>
        <li>🌙 <strong>Offline-first:</strong> Works without internet for reviewing and managing your words.</li>
        <li>🧩 <strong>Multi-language Support:</strong> Currently supports <strong>English</strong> and <strong>French</strong>.</li>
      </ul>
    </td>
  </tr>
</table>

## 📥 Build from source

If you want bleeding edge features, you can build Vocaber from source:

```sh
git clone https://github.com/Xenorf/vocaber.git
cd vocaber
flutter pub get
flutter run
```

## 🛠️ Tech Stack

- **Flutter** (cross-platform mobile).
- **Hive** (local database).
- **image_picker, cached_network_image, fl_chart** (media & charts).
- **Intl** (Multiple language support).

## 🌍 Language Support

Vocaber is designed to be extensible for multiple languages.
Currently, **English** and **French** are supported.
If you'd like to help add support for your language, see the below!

## 🤝 Contributing

Contributions are welcome! I am by no means a UI/UX expert nor a professional mobile developer.

**How to add a new display language:**
1. Copy `intl_en.arb` to `intl_xx.arb` (where `xx` is your language code).
2. Translate all values.
3. Add your language to `supportedLocales` in `main.dart`.
4. Submit your PR!

**How to add a vocabulary language:**
1. Create a definition provider from your favorite dictionary in `models/definition_providers` that extends the **DefinitionProvider** class.
2. Add a case in `fromTerm` method of the **Word** class.
3. Submit your PR!

**Everything else**
1. Figure it out, don't hesitate to make an issue.
2. Submit a PR!

## 📄 License

Vocaber is licensed under the [GNU GPL v3.0](https://www.gnu.org/licenses/gpl-3.0.html).
