# Onboarding Screens

This directory contains all the individual onboarding screen components for the Task Tracker app.

## Structure

```
onboarding/
├── README.md                    # This file
├── onboarding_screens.dart      # Barrel file for easy imports
├── intro_screen.dart           # Welcome/introduction screen
├── name_input_screen.dart      # User name input screen
├── planning_time_screen.dart   # Task planning time window selection
└── reflection_time_screen.dart # Task reflection time window selection
```

## Components

### IntroScreen
- **Purpose**: Welcome users to the app
- **Props**: None (stateless)
- **Features**: App description and welcome message

### NameInputScreen
- **Purpose**: Collect user's name (optional)
- **Props**: 
  - `userName`: Current name value
  - `onNameChanged`: Callback when name changes
  - `onSkipName`: Callback when user skips name input
- **Features**: Text input field with "Rather not say" option

### PlanningTimeScreen
- **Purpose**: Select daily task planning time window
- **Props**:
  - `planningWindow`: Current time window selection
  - `onPlanningWindowChanged`: Callback when time window changes
- **Features**: Start and end time pickers with default values

### ReflectionTimeScreen
- **Purpose**: Select daily task reflection time window
- **Props**:
  - `reflectionWindow`: Current time window selection
  - `onReflectionWindowChanged`: Callback when time window changes
- **Features**: Start and end time pickers with default values

## Usage

Import all screens using the barrel file:

```dart
import 'onboarding/onboarding_screens.dart';
```

Or import individual screens:

```dart
import 'onboarding/intro_screen.dart';
import 'onboarding/name_input_screen.dart';
// etc.
```

## Design Principles

- **Separation of Concerns**: Each screen is responsible for its own UI and logic
- **Reusability**: Screens can be used independently if needed
- **Consistency**: All screens follow the same design patterns and styling
- **Accessibility**: Proper contrast and readable text sizes
- **Responsive**: Works on different screen sizes

## Styling

All screens use:
- Consistent gradient background
- White text on gradient background
- Purple accent color (#8B5CF6)
- Rounded corners and modern UI elements
- Proper spacing and typography 