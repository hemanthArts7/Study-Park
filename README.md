# Study Park

Study Park is a Flutter-based educational app designed to provide students with structured course materials, unit-wise PDFs, and related YouTube videos for easy learning. The app dynamically fetches courses, semesters, subjects, and units from Firebase Firestore and stores PDFs on GitHub.

![image alt](https://github.com/hemanthArts7/Study-Park/blob/84c3ed222ce8ef26d967caca8d245149b74a1132/ss/SplashScreen.jpg) ![image alt](https://github.com/hemanthArts7/Study-Park/blob/84c3ed222ce8ef26d967caca8d245149b74a1132/ss/Homepage.jpg)

## Features

- 📚 **Course Selection** – Choose from various courses available in the app.
- 🎓 **Semester & Subject Selection** – Navigate through semesters and subjects dynamically.
- 📄 **Unit-wise PDFs** – Access unit-wise study materials stored on GitHub.
- 🎥 **YouTube Video Integration** – Watch related YouTube videos under each unit.
- 🔍 **Search Bar** – Search subjects dynamically from Firebase Firestore while typing.
- 📢 **Google Ads Integration** – Monetization through Google Ads.
- 💡 **Affiliate Marketing** – Earn through book recommendations.
- 📲 **Firebase Firestore Backend** – Manage app content dynamically with real-time updates.



![Home Screen](screenshots/home_screen.png)
![Semester Selection](screenshots/semester_selection.png)
![Subject List](screenshots/subject_list.png)
![Unit PDFs](screenshots/unit_pdfs.png)

## Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/study_park.git
   ```
2. **Navigate to the project directory:**
   ```sh
   cd study_park
   ```
3. **Install dependencies:**
   ```sh
   flutter pub get
   ```
4. **Run the app:**
   ```sh
   flutter run
   ```

## Firebase Setup

1. Create a Firebase project and enable Firestore.
2. Add the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) in the respective directories.
3. Structure Firestore collections for courses, semesters, subjects, units, and PDF URLs.

## Folder Structure

```
study_park/
│-- lib/
│   │-- main.dart
│   │-- screens/
│   │-- widgets/
│   │-- models/
│   │-- services/
│-- assets/
│-- firebase/
│-- pubspec.yaml
│-- README.md
```

## Tech Stack

- **Flutter** – Frontend framework
- **Dart** – Programming language
- **Firebase Firestore** – Backend database
- **GitHub** – PDF storage
- **Google Ads SDK** – Monetization

## Contribution

Contributions are welcome! Follow these steps:

1. **Fork the repository**
2. **Create a new branch:**
   ```sh
   git checkout -b feature-name
   ```
3. **Commit changes:**
   ```sh
   git commit -m "Add new feature"
   ```
4. **Push to the branch:**
   ```sh
   git push origin feature-name
   ```
5. **Create a Pull Request**



🚀 Happy Learning with Study Park! 📖✨

