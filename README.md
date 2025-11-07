# MemoMap iOS Mobile Application

## 📱 Project Overview

**MemoMap** is an iOS app built with Swift, SwiftUI, and Firebase that lets users save and revisit memories through an interactive map, using Mapbox integration. It also allows users to share their memories publicly with followers and explore memories shared by others. The app is developed using Clean Architecture with MVVM and Dependency Injection.

## 🧩 Tech Stack

- **Language:** Swift
- **Framework:** SwiftUI
- **Local Database:** SwiftData
- **Cloud Database:** Firebase Firestore Database
- **Storage:** Firebase Cloud Storage
- **Authentication:** Firebase Authentication
- **Map Integration:** Mapbox Maps
- **Architecture:** Clean Architecture with MVVM & Dependency Injection
- **Dependency Injection:** Factory Package
- **Dependency Management:** Swift Package Manager (SPM)

## 📦 Package Dependencies

The following packages are used in this project via Swift Package Manager (SPM):

| Package Name | Description | Link |
| - | - | - |
| **Factory** | A modern approach to Container-Based Dependency Injection for Swift and SwiftUI | [Factory](https://github.com/hmlongco/Factory) |
| **Firebase** | Firebase SDK for Apple App Development | [firebase-ios-sdk](https://github.com/firebase/firebase-ios-sdk) |
| **Kingfisher** | A lightweight, pure-Swift library for downloading and caching images from the web | [Kingfisher](https://github.com/onevcat/Kingfisher) |
| **Lottie** | An iOS library to natively render After Effects vector animations | [lottie-ios](https://github.com/airbnb/lottie-ios) |
| **MapboxMaps** | Interactive, thoroughly customizable maps for iOS powered by vector tiles and Metal | [mapbox-maps-ios](https://github.com/mapbox/mapbox-maps-ios.git) |
| **SearchBar** | SearchBar Component to SwiftUI using Native Implementations from UiKit and rewritten AppKit implementation in Swift UI | [SearchBar](https://github.com/SzpakKamil/SearchBar) |
| **SwiftUI Introspect** | Introspect underlying UIKit/AppKit components from SwiftUI | [SwiftUI-Introspect](https://github.com/siteline/SwiftUI-Introspect) |
| **WrappingHStack** | WrappingHStack (FlowLayout) is a SwiftUI component similar to HStack that wraps horizontally overflowing subviews onto the next lines. | [WrappingHStack](https://github.com/ksemianov/WrappingHStack) |

## 📋 Requirements

Before running the app, ensure you meet the following system requirements:

| Requirement | Version / Info |
| - | - |
| **Device** | Mac with Intel or Apple Silicon |
| **Operating System** | macOS 26.0 (Tahoe) or newer |
| **Xcode** | Version 26.0 or newer |
| **Swift** | Swift 6.2+ |
| **iOS Deployment** | Minimum iOS 26.0 |
| **Simulator** | iOS 26.0+ recommended |
| **Network** | Internet connection for Firebase |

## ⚙️ Installation and Setup

### 1. 📦 Unzip the Project File

1. Download and unzip the provided `.zip` file.
2. Move the unzipped folder to a desired location.

### 2. 💻 Install Xcode

1. Open the Mac App Store and search for `Xcode`.  
2. Click `Get > Install` to download and install Xcode.  
3. Once installation is complete, launch Xcode to finish the initial setup process.  
4. When prompted with available simulator runtimes, review the list of built-in and downloadable options.  
5. Select `iOS 26.0` and click `Download & Install` to ensure the required simulator is available for testing.

### 3. 🧭 Open the Project in Xcode

1. Open Xcode.
2. From the menu bar, choose:  
   `File > Open...`
3. Select the `MemoMap.xcodeproj` file in the unzipped project directory.

### 4. 📦 Resolve Dependencies

1. In Xcode, go to:  
   `File > Packages > Resolve Package Versions`
2. Xcode will automatically fetch and build all required dependencies.

### 5. 📱 Run the App

1. Select a simulator (e.g., iPhone 17) from the Xcode toolbar.
2. Press `Cmd + R` or click ▶️ to build and run the application.

## 📄 License

This project was developed as part of an academic dissertation project.

---

