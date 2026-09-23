-Product Catalog-

The app lets users browse products, search for items, open product details, refresh the list, and load more products as they scroll.

1. Features

* Product list with title, thumbnail, price, and rating
* Infinite scroll pagination using the skip parameter
* Product detail screen with description, price, rating, and images
* Debounced product search
* Pull-to-refresh
* Loading, error, empty, and success states
* Retry button when a request fails
* Image loading placeholder and error fallback
* Separation between data and presentation layers
* Unit test for product model parsing

2. Tech Stack

* Flutter
* Dart
* Provider
* http package
* DummyJSON API
* Material 3

3. API Endpoints

Product list:
GET https://dummyjson.com/products?limit=20&skip=0

Product detail:
GET https://dummyjson.com/products/{id}

Search:
GET https://dummyjson.com/products/search?q=phone

4. Project Structure

The project is separated into data and presentation layers.

lib/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
│
├── presentation/
│   ├── controllers/
│   ├── screens/
│   └── widgets/
│
└── main.dart

- Data Layer
The data layer handles API communication and converts JSON responses into Dart models.
The repository sits between the API service and presentation layer so that API-related logic is kept outside the UI.

- Presentation Layer
The presentation layer contains the controller, screens, and reusable widgets.
The controller manages states such as loading, error, pagination, search, and refresh.

- Search Decision
I used the DummyJSON search endpoint instead of filtering only the products already loaded in the app.
This allows search to work across the available product dataset instead of only the current paginated list.
The search input is debounced for a short period before making the API request. This reduces unnecessary requests while the user is typing.

- Pagination
The app initially loads 20 products.
When the user scrolls near the bottom of the list, the next batch is requested using the current number of loaded products as the skip value.

Example:
limit=20&skip=0
limit=20&skip=20
limit=20&skip=40

Existing products stay visible while the next page is loading, and a small loading indicator is shown at the bottom of the list.

5. App States
The app handles four main UI states:

* Loading
* Error
* Empty
* Success

If a request fails, an error message and Retry button are shown.
If a search returns no results, the app shows an empty-state message instead of a blank screen.

- Pull-to-Refresh
Users can pull down on the product list to reload the data.
Refreshing resets the list and loads products again from the beginning.

- Image Handling
Network images show a loading indicator while loading.
If an image fails to load, a fallback icon is displayed.
The detail screen also handles products with no images available.

6. How to Run

Make sure Flutter is installed.

Check your Flutter setup: 
flutter doctor

Install dependencies:
flutter pub get

Run the app:
flutter run

7. Testing

Run the tests with:
flutter test
The current unit test checks that product JSON data is parsed correctly into the Product model.

You can also run:
flutter analyze
to check for Dart and Flutter analysis issues.


8. AI Assistance

Specifically, I used AI for:

* Guidance on debugging a Flutter theme compatibility issue involving CardThemeData
* Reviewing the pagination and debounced search implementation
* Suggesting improvements for loading, error, empty, and image fallback states

The core implementation, project structure, API integration, state management flow, and architectural decisions were reviewed and understood by me before submission.

I also manually tested the application and verified the behavior of the main features.