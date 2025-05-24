# MindMate - A Mobile based virtual companion for early screening and support of Anxiety & Depression.

Overview

MindMate is a cross-platform Flutter mobile application that helps users and clinicians monitor and improve mental health.  It combines self-screening quizzes (PHQ-9, GAD-7), Clinically Certified recommendations, an AI-powered chat companion, creative art therapy, resource management, and an SOS emergency link.  Doctors can log in to a dedicated dashboard to review patient data and certify recommendations.

Project Structure
 
<img width="949" alt="Screenshot 2025-05-24 at 4 32 15 PM" src="https://github.com/user-attachments/assets/64d5c358-1f58-4880-9f07-5da0b801ac3d" />


Setup Instructions
	1.	Install Flutter
	•	Flutter SDK ≥ 3.0.0; follow https://flutter.dev/docs/get-started/install
	2.	Clone & Dependencies

git clone : https://github.com/Nadil2022/MindMate---Mobile-App
cd mindmate
flutter pub get


	3.	Add Asset Files
	•	Place all required images into assets/.
	•	In pubspec.yaml, under flutter.assets, list each file path.
	4.	Configure API Key
	•	In lib/chat_screen.dart, replace static const _apiKey = 'YOUR_API_KEY_HERE'; with your real Gemini API key.
	5.	Run the App

flutter run

	•	On an Android emulator, iOS Simulator, or a connected device.

Reviewer Notes
	•	Core Functionality lives in the lib/ directory—focus review here.
	•	Doctor Login triggers on exactly doctor@gmail.com; all other emails go to user flow.
	•	Screening Logic: PHQ-9 and GAD-7 questions compute _depressionScore and _anxietyScore variables.
	•	AI Chat uses direct REST calls to generativelanguage.googleapis.com; verify network access and valid API key.
	•	Asset Naming must match exactly with pubspec.yaml entries to avoid “unable to load asset” errors.
	•	Theme Toggle in Settings updates the app’s themeMode via a callback in main.dart.
	•	Doctor Dashboard uses sample data; extend with real database connectivity in future iterations.
	•	File Picker integration is pending—currently the “My Collection” UI is scaffolded for future implementation.

