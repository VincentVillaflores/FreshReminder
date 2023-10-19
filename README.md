# a2-s3784709
Fresh Reminder App 

![image](https://github.com/VincentVillaflores/FreshReminder/assets/127155347/59eda985-cc63-4640-bcb3-35a1982d9123)

## Project Overview
Fresh Reminder is an app which tracks the expiration dates of foods which you have purchased in recent shopping trips, so that you can be reminded (prior to them going off/expiring). This reduces food waste, along with increasing food handling safety.
Additionally, the app uses an image classification machine learning model, in tandem with an API to get the shelf life of a given item, to determine which items you have bought on a shopping trip and then auto-populate its shelf life and other pertinent information.

MiroBoard - https://miro.com/app/board/uXjVMo2Qf70=/?share_link_id=568492534675

## Project Structure
```
├── FreshReminder_App
├── Util
│   ├── Search
│   └── CalendarDates
├── ViewModel
│   ├── ImageClassifierViewModel
│   ├── CoreDataViewModel
│   ├── CalendarViewModel
│   └── FoodieAPIViewModel
├── View
│   ├── Camera
│   │   └── FridgeView
│   ├── Item
│   │   ├── ItemSheet
│   │   ├── NewItemView
│   │   ├── ItemSearchView
│   │   └── ItemGuideView
│   ├── Fridge
│   │   └── FridgeView
│   ├── Settings
│   │   └── SettingsView
│   ├── Calendar
│   │   ├── Components
│   │   │   └── Calendar-relevant Components 
│   │   └── CalendarView
│   └── ContentView
└── Model
    ├── Classifier
    ├── FreshReminderImageClassifier
    ├── Model
    ├── NavigationUtil
    ├── Persistence
    ├── FoodieAPIModel
    ├── ItemCategory
    └── AppDelegate

```

## Requirements
- Xcode 14 or higher
- iOS 17 or higher

## Build Instructions
1. Pull the repository
2. Open in Xcode
3. Press ``⌘ + B`` to build

## Run Instructions
1. Pull the repository
2. Open in Xcode
3. Select Debug in the top menu
4. Select Run

## Credits
Matthew Soulsby s3784709@student.rmit.edu.au  
Vincent Villaflores	s3728807@student.rmit.edu.au
