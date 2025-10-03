# Unownmon
For 40005 Advanced iOS Development: Assignment Task 3. Unownmon is a Pokemon wordle-like application for Apple iOS, where the player has 6 attempts to guess the hidden Pokemon (includes all 1025 Pokemon as of 3rd October 2025, with no alternate forms). When a guess is made, they are provided with an attribute comparison between that Pokemon and the hidden one (hidden's attribute is higher, lower, equal, or wrong).

This application uses [PokeAPI](https://pokeapi.co/) to obtain a full list of Pokemon, as well as individual Pokemon data. This application is also heavily inspired by [Squirdle](https://github.com/Fireblend/squirdle), and uses their image assets to indicate stat comparisons in the main game (please message me if this is a problem. Thank you :>).

## Supporting Platforms
This application supports the Apple iOS platform, designed on iPhone 17 Pro (this does not limit usage to only this model, however. See dependencies for further information). iPadOS should also be fine.

## Installation
1. Clone this repository using the web URL: `https://github.com/Payayaing/40005-AssessmentTask3-Unownmon.git`
2. Open the project on XCode.
3. Select a simulator: recommended on iPhone 17 Pro.
4. Run the application.

## Dependencies
- Uses Swift and SwiftUI for implementation.
- Minimum deployment is iOS 18.6+
- Application must be connected to the internet to properly fetch data.

## Error Handling
This application prioritises a smooth, intuitive, and informative user experience. When an error occurs (usually from fetching data from the API), the application tends to handle the error silently, preventing fatal crashes by returning default or nil values. If a page is dependent on fetched data, and there was an error obtaining this, the application alerts the user that an error has occurred and takes them back to the previous page.

## Usage
When the user runs the application, they are brought to a home page. If they have not played the game, they can view some usage instructions and credits by pressing the `About` button. Pressing `Play` takes them to the main game page.

On this page, they can view the number of attempts remaining at the very top of the screen, and are informed that if they tap on one of their guesses, they can view that Pokemon's detailed stats. The guesses that they have made are visible in the middle of the screen. At the bottom of the page, there are three buttons:

- **Make a Guess**: the user is taken to a selector page, where they are shown a list of Pokemon and their sprites. They are able to search for a specific Pokemon using the search bar at the top of the screen. They can tap on a specific Pokemon, which takes them to a detailed view of their stats. On this page, the player can bring up their personal notes to check whether that Pokemon matches their criteria, and can choose that Pokemon to make their guess.

- **Reset Game**: Completely resets game progress and selects a new hidden Pokemon.

- **Show Notes**: This provides a sheet that the user can make personal notes on, which persists throughout the entire application and saves between guesses. These notes are automatically saved, but also provides a manual save button to close the sheet, as well as a clear notes option to reset the notes content.

Each Pokemon that the player guesses automatically shows up on this screen, as well as the hidden Pokemon's stats comparative to their guess. They are provided hints about generation, typings, height, and weight. If the user selects the correct Pokemon, they are shown an alert which informs them of their victory, and disables any further guess making. If the user runs out of guesses, then they are shown what the correct Pokemon actually was, and cannot submit any further guesses. From this point, users are encouraged to use the Reset Game button to play again.

The application automatically saves all game related data, so users are able to close and re-open the game without losing any progress.
