# onehaven_caregiver_app

A new Flutter project.

## 🚀 Project Setup Guide

This project was built using:

**Flutter SDK: 3.29.0**
(You may use any recent stable version, but this is the version tested.)

## 📦 Getting Started

Follow the steps below to run the project locally.

### Clone the Repository

``` bash

git clone https://github.com/nikkieke/onehaven_caregiver_app.git
cd onehaven_caregiver_app

```

### Install Dependencies

``` bash

flutter pub get

```

### Generate Hive files 

``` bash

flutter pub run build_runner build --delete-conflicting-outputs

```

### Start the Mock Backend (Required)
This project uses a local mock server for data fetching, powered by Dart Shelf.

Start the server:

``` bash
cd mock_server
dart run bin/mock_server.dart

```

Make sure you see:

``` bash
Mock server running on http://localhost:8080

```

### Example JSON Structure

``` json
[
    {
      "id": "m001",
      "firstName": "Emma",
      "lastName": "Test",
      "birthYear": 2010,
      "relationship": "Daughter",
      "avatar": "https://ui-avatars.com/api/?name=Emma+Test&size=128",
      "status": "active",
      "screenTimeEnabled": true
    },
]

```

### Run the App

``` bash

flutter run

```

### Login Credentials

``` bash

email: gretacharles@gmail.com
pass: OneHaven

```

## 🏗️ Architecture

This project follows a clean and modular structure:

Presentation Layer: Flutter UI built with Riverpod for state management. Widgets subscribe to state through providers, keeping UI reactive and predictable.

ViewModel Layer: StateNotifiers manage business logic, including toggling member settings, handling offline changes, and updating cached data.

Data Layer:

A local cache using Hive stores members and pending offline updates.

A lightweight mock backend is built with Dart Shelf to serve and update member data.

A simple service class handles all network and cache interactions.

This separation keeps logic testable and makes the app easy to extend.


## 🎨 Design Decisions

Offline-first approach:
The app reads from cache on startup and syncs changes when the device reconnects. This creates a smooth and resilient experience.

Predictable state:
Riverpod providers keep state updates clear and traceable. Using StateNotifier allows fine control without rebuilding entire widgets unnecessarily.

Lightweight development backend:
A local Shelf server provides consistent, controllable responses for testing. It avoids external dependencies and makes the project portable.


## 🤖 AI Usage Summary

AI tools supported different stages of development:

Grok was used for guidance on technology stack, and planning the steps for building the project.

Claude generated several UI layouts and components that were later adapted and refined.

ChatGPT helped with debugging and refining logic.

All AI-generated output was reviewed and customized to match project goals and coding style.

## Assets

- [APK file](https://drive.google.com/file/d/1IpNYYtYXXe3D7438qof7smrFTREiYApi/view?usp=sharing)
- [Demo Video](https://www.loom.com/share/e8be67f860ab4368a3ca57d4b79b738f)