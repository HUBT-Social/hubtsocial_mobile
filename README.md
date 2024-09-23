# hubtsocial_mobile
 
Mobile app for HUBT Social system

## How to Use 

**Step 1:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 2:**

This project uses `inject` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```

## Hide Generated Files

In-order to hide generated files, navigate to `Android Studio` -> `Preferences` -> `Editor` -> `File Types` and paste the below lines under `ignore files and folders` section:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

In Visual Studio Code, navigate to `Preferences` -> `Settings` and search for `Files:Exclude`. Add the following patterns:
```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```
## bug fix with new xcode version build
  **Step1**
 open xcode 
 **Step2**
open project
**Step3**
reopen xcode and follow Xcode -> Product -> Clean Build Folder