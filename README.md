Deepseek Chatbot with Firebase & Flutter

A simple and powerful chatbot application built with Flutter, powered by the Deepseek API, and featuring a persistent chat history with full CRUD (Create, Read, Update, Delete) functionality backed by Firebase.

Features

Conversational AI: Integrates the Deepseek API for intelligent, human-like responses.

Persistent Chat History: All conversations are saved to a Firebase backend (Firestore).

Real-time Updates: Chats sync in real-time across devices.

Cross-Platform: Built with Flutter, enabling a single codebase for iOS, Android, and (optionally) Web/Desktop.

Full Chat CRUD:

Create: Start new, independent chat sessions.

Read: View a list of all your past chat sessions.

Update: Rename chat sessions for better organization.

Delete: Remove chat sessions you no longer need.

Secure: (Optional: Add if you implemented Firebase Auth) User authentication to keep chats private.

Technology Stack

Frontend: Flutter

Backend: Firebase

Firestore: NoSQL database for storing chat history.

Firebase Authentication: (Optional) For user management.

AI: Deepseek API

Getting Started

Follow these instructions to get a local copy up and running.

Prerequisites

Flutter SDK (v3.0 or later)

An editor like VS Code or Android Studio.

A Firebase account with a new project created.

A Deepseek API account and API key.

Firebase CLI (for FlutterFire configuration).

Installation

Clone the repository:

git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
cd your-repo-name


Install dependencies:

flutter pub get


Configure Firebase (FlutterFire):

If you haven't already, link your Firebase project to this Flutter app.

# Log in to Firebase
firebase login

# Install/update the FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure your app
flutterfire configure


This will guide you through selecting your Firebase project and will automatically generate the lib/firebase_options.dart file.

Set up environment variables:

This project likely uses a package like flutter_dotenv to manage keys.

Create a .env file in the root of your project:

# Deepseek API Key
DEEPSEEK_API_KEY=your-deepseek-api-key

# Note: Firebase keys are typically handled by the
# 'firebase_options.dart' file and don't need to be in here.


(Remember to add .env to your .gitignore file!)

Configure Firebase Security Rules:

For your app to work, you must set up security rules in your Firestore database. A basic example to get started (which you should later secure) might look like this:

// rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow reads/writes only for authenticated users on their own data
    match /users/{userId}/chats/{chatId} {
      allow read, write, delete: if request.auth != null && request.auth.uid == userId;
    }
     match /users/{userId}/chats/{chatId}/messages/{messageId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}


Running the App

Connect a device or start an emulator.

Run the app:

flutter run


Firebase Backend (CRUD)

This application uses Firestore to manage chat sessions.

Data Model: The data is structured to be user-centric. A top-level users collection holds documents for each user. Inside each user document, a chats sub-collection stores individual chat sessions.

/users/{userId}/chats/{chatId}
    - title (string)
    - createdAt (timestamp)
    - messages (array of objects)
        - { role: "user", content: "Hello" }
        - { role: "model", content: "Hi! How can I help?" }


Create: When a user starts a new conversation, a new document is created in the /users/{userId}/chats collection.

Read: The application fetches all documents from this collection to display the chat history list.

Update: Renaming a chat updates the title field of the corresponding chat document.

Delete: Deleting a chat removes the entire chat document (and its messages array).

Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.

Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)

Commit your Changes (git commit -m 'Add some AmazingFeature')

Push to the Branch (git push origin feature/AmazingFeature)

Open a Pull Request

License

Distributed under the MIT License. See LICENSE for more information.
