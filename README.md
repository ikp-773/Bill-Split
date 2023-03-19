# Bill Split App

[![wakatime](https://wakatime.com/badge/user/fac0edb0-504c-4b92-b3c9-891f4dc941d5/project/5cf27c96-63e1-43e1-9f0a-56f11b0d3b84.svg)](https://wakatime.com/badge/user/fac0edb0-504c-4b92-b3c9-891f4dc941d5/project/5cf27c96-63e1-43e1-9f0a-56f11b0d3b84) ![GitHub top language](https://img.shields.io/github/languages/top/ikp-773/Bill-Split?color=b) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/ikp-773/Bill-Split)

The "Bill Split" app is a mobile application developed using Flutter and Firebase. It allows users to manage and split bills among group members. With a clean and intuitive user interface, users can easily sign up and sign in to the app to start managing their expenses.

[![Apk](https://img.shields.io/badge/APK-Bill%20Split-brightgreen?color=purple&style=for-the-badge)](https://drive.google.com/file/d/1SnOLLshoMSutoIqyF92og3S2h0vRpr6V/view?usp=share_lin)

[![Video Demo](https://img.shields.io/badge/Video-Demo-yellowgreen?style=for-the-badge)](https://drive.google.com/file/d/1ffdj7Quu0keJsmwd6HAjQ4B5imae0Caa/view?usp=share_link)

## Features

- User Authentication: Users can sign up and sign in to the app using their email and password.
- Bill Management: Users can add, delete, and update bills they have split against another user(s).
- Group Management: Users can create groups and split bills among group members as a whole or selectively.
- Summary Screen: A summary screen is available in groups which shows who owes the app user how much.

## Technologies Used

The "Bill Split" app is developed using the following technologies:

- Flutter: A mobile app development framework that enables the creation of high-performance, visually attractive apps for both iOS and Android platforms.
- Firebase: A cloud-based platform that provides various backend services, such as authentication, database, storage, and hosting, which are used to power the app.

## Pending Task

* Debt simplification view couldn't be completed.

## Libraries used

* get: 4.6.5
* firebase_core : 2.7.1
* firebase_auth : 4.2.10
* cloud_firestore : 4.4.4
* fluid_bottom_nav_bar : 1.4.0
* dropdown_button2: 2.0.0
* get_storage : 2.1.1
* flutter_expandable_fab : 1.7.1
* h_alert_dialog : 1.1.2
* pull_to_refresh:^2.0.0

## How to configure

Make sure flutter is set up. If not set it using [Flutter Environment Setup](https://flutter.dev/docs/get-started/install).

To get started with the "Bill Split" app, follow these steps:

1. Clone the repo

   ```bash
   $ git clone https://github.com/ikp-773/My-Doc.git
   $ cd My-Doc/
   ```
2. Configure Firebase services for the app, authentication and add `google-services.json`  inside `android/app/` .
3. Run the flutter app using

   ```bash
   $flutter pub get
   $flutter run
   ```
