# Koffee Bistro - A Flutter Coffee Ordering App ☕

Hey everyone! This is my Take Home Assignment, Koffee Bistro, a complete coffee ordering application I built using Flutter. It's been an amazing learning journey, and I'm super excited to share it. The goal was to build a beautiful, functional, and clean app from the ground up.

This wasn't just about making a UI; it was about building a *real* app with a proper architecture, state management, and a focus on a great user experience.


## ✨ About The Project

Koffee Bistro is a mobile app that simulates the experience of ordering from a modern coffee shop. It starts with a beautiful onboarding screen, handles user login, displays a dynamic menu of coffee products, and allows users to add items to a cart and proceed to an order screen.

I built everything from scratch, including a custom state management solution, to really understand how reactive apps work under the hood. The whole app is designed to be clean, responsive, and a little fun to use, thanks to some cool animations!

---

## 🚀 Key Features

* **Full Authentication Flow:** A beautiful, glassmorphism-style login screen that remembers the user's session on app restart.
* **Dynamic Home Screen:** Products and categories are loaded from a mock service. The product grid is responsive and shows 2 or 3 columns depending on the screen width.
* **Custom State Management:** Built from the ground up using a custom `ValueNotifier` and `ValueBuilder` to create a reactive UI without relying on `setState`.
* **Product Details & Animations:**
    * A stunning **Hero animation** makes the coffee image fly from the home screen to the detail screen.
    * An interactive description that can be expanded with a "Read More" button.
* **Shopping Cart & Local Storage:**
    * Add items to the cart directly from the home screen with a size selection pop-up.
    * The cart is saved to the phone's local storage using **SharedPreferences**, so items are remembered even after closing the app.
    * The cart screen features animated quantity counters and a sliding delivery toggle.
* **Modern UI & UX:**
    * Custom-themed snackbars for a professional feel.
    * A beautiful, blurred **glassmorphism dialog** for editing the user's address and adding notes.
    * Screen orientation is locked to portrait mode for a consistent mobile experience.

---

## 🛠️ Tech Stack & Architecture

This project was built with a focus on clean code and a scalable structure.

* **Framework:** **Flutter**
* **Language:** **Dart**
* **Architecture:**
    * **Clean Architecture:** The code is separated into distinct layers (UI, State, Models, API) to make it easy to manage and test.
    * **Singleton Pattern:** An `AppState` class provides a single point of access to all state managers (`AuthState`, `HomeState`, `CartState`, etc.).
* **State Management:**
    * A custom `ValueNotifier` and `ValueBuilder` solution was built from scratch to create a reactive UI.
* **Navigation:**
    * A centralized **named routing system** using Flutter's built-in router for clean navigation.
    * A persistent bottom navigation bar in the `MainScreen` that manages the primary app pages.
* **Local Storage:** **SharedPreferences** is used to persist user login sessions and cart data.

---

## 🏁 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

* You need to have the Flutter SDK installed. You can find instructions [here](https://flutter.dev/docs/get-started/install).

### Installation

1.  **Clone the repo**
    ```sh
    git clone [https://github.com/carbonFibreCode/coffee-bistro.git](https://github.com/carbonFibreCode/coffee-bistro.git)
    ```
2.  **Navigate to the project directory**
    ```sh
    cd coffee-bistro
    ```
3.  **Install packages**
    ```sh
    flutter pub get
    ```
4.  **Run the app**
    ```sh
    flutter run
    ```
    To run it on Chrome, use:
    ```sh
    flutter run
    ```

---

## 🧠 What I Learned

Building this app was an incredible experience! As an intern, I got to dive deep into:
* The fundamentals of clean architecture and why it's so important.
* How reactive state management really works by building my own `ValueNotifier`.
* Implementing beautiful and meaningful animations like `Hero` and `AnimatedSwitcher` to improve the user experience.
* Handling local data persistence with `SharedPreferences`.
* Creating a responsive UI that looks great on different screen sizes.

Thanks for checking out my project!

**Arun Kumar**
