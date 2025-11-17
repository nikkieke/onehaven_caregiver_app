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

### Run the App

``` bash

flutter run

```