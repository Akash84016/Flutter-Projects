# Flutter Music Player App

A simple music player app built with Flutter, featuring two screens: Home Player View and Detail View. Users can play, pause, seek songs, and navigate between tracks. The app remembers the last played song and uses Flutter Bloc for state management. Perfect for learning and demonstrating basic Flutter music playback functionality.

## Features

### Home Player View:
- Displays the currently playing song’s title, image, and play/pause button.
- Allows for the continuation of song playback even when navigating between screens.

### Detail View:
- Provides additional controls:
  - Seek forward/backward 10 seconds.
  - Next and previous song buttons.
  - A progress bar with start and end time indicators.

### Persistent Playback:
- The app remembers the last song played. If the app is reopened, the last song played will be displayed with the correct title, image, and state (playing/paused).

### Key Functionality:
- Load Statics 4 songs in list with title, image, and URL.

## Technical Details State Management:
- Flutter Bloc is used for managing the state of the app, ensuring smooth transitions between songs and persistent data handling.
- Music Playback: Songs are played using audio libraries, with controls such as play, pause, next, and previous available on both views.
- Navigation: Simple navigation between Home Player View and Detail View.
