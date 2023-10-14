# ``Fresh Reminder``

This app will help you track the expiration dates of your food products. 

## Overview

Food waste is the issue that we are trying to alleviate. It is easy to forget about what is in our fridge. With our app we aim to help reduce this waste by providing the user an easy-to-use and simple interface that will help track and notify them as the expiration date approaches. The main feature of this app will be its use of machine learning to determine what the user has taken a photo of. The app will then automatically add the item to the list with the appropriate expiration date.

## Topics

### ViewModel
- ``ImageClassifierViewModel.swift``
- ``CoreDataViewModel.swift``
- ``CalendarViewModel.swift``
- ``FoodieAPIViewModel.swift``

### View

- ``ImagePicker.swift``
- ``ContentView.swift``
- ``FridgeView.swift``
- ``ItemSheet.swift``
- ``NewItemView.swift``
- ``ItemSearchView.swift``
- ``ItemGuideView.swift``
- ``CalendarGrid.swift``
- ``CalendarView.swift``
- ``CalendarViewController.swift``
- ``SettingsView.swift``

### Model
- ``Classifier.swift``
- ``FreshReminderImageClassifier.mlmodel``
- ``Model.xcdatamodeld``
- ``Persistence.swift``
- ``FoodieAPIModel.swift``
- ``ItemCategory.swift``
- ``AppDelegate.swift``

### Util
- ``Search.swift``
- ``CalendarDates.swift``
