Product Catalog

The app allows users to browse products, search for items, open product details, refresh the list, and load more products as they scroll.

1. Required Features

* Product list with title, thumbnail, and price
* Infinite scroll pagination using the skip parameter
* Product detail screen with full description, price, rating, and images
* Loading, error, empty, and success states
* Retry button when a request fails
* Debounced product search
* Separation between data and presentation layers

2. Bonus Features

* Pull-to-refresh
* Image loading placeholder
* Image error fallback
* Unit test for product model parsing

3. Additional Features

I also added a few small features beyond the assessment requirements to improve the overall user experience:

* Favorite products
* Favorite button available from both the product list and detail screen
* Favorite state stays synchronized between screens
* Filter to show favorite products only
* Product sorting:
    * Price: Low to High
    * Price: High to Low
    * Rating: High to Low
* Clear button for the search field
* Swipeable product images on the detail screen
* Pagination loading indicator while keeping existing products visible

4. Tech Stack

* Flutter
* Dart
* Provider
* http package
* DummyJSON API
* Material 3

5. API Endpoints

Product list:

GET https://dummyjson.com/products?limit=20&skip=0

Product detail:

GET https://dummyjson.com/products/{id}

Search:

GET https://dummyjson.com/products/search?q=phone

6. Project Structure

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

Data Layer

The data layer handles API communication and converts JSON responses into Dart models.

The repository sits between the API service and presentation layer so that API-related logic stays separate from the UI.

Presentation Layer

The presentation layer contains the controller, screens, and reusable widgets.

The controller manages UI-related state such as loading, pagination, search, refresh, favorites, and sorting.

7. Search Decision

I used the DummyJSON search endpoint instead of filtering only the products already loaded in the app.

This allows the search to work across the available product dataset instead of only the current paginated list.

The search input is debounced before making the API request. This reduces unnecessary requests while the user is still typing.

8. Pagination

The app initially loads 20 products.

When the user scrolls near the bottom of the list, the next batch is requested using the current number of loaded products as the skip value.

Example:

limit=20&skip=0
limit=20&skip=20
limit=20&skip=40

Existing products remain visible while the next page is loading, with a small loading indicator displayed at the bottom of the list.

9. App States

The app visually handles four main states:

* Loading
* Error
* Empty
* Success

If a request fails, an error message and Retry button are displayed.

If a search returns no results, the app shows an empty state instead of leaving the screen blank.

10. Pull-to-Refresh

Users can pull down on the product list to reload the data.

Refreshing loads the product list again from the beginning.

11. Image Handling

Network images show a loading indicator while they are loading.

If an image fails to load, a fallback icon is displayed.

The detail screen also handles products that do not have any images available.

12. How to Run

Make sure Flutter is installed and configured.

Check the Flutter setup:

flutter doctor

Install dependencies:

flutter pub get

Run the app:

flutter run

13. Testing

Run the unit tests with:

flutter test

The current unit test checks that JSON product data is correctly parsed into the Product model.

You can also run:

flutter analyze

to check for Dart and Flutter analysis issues.

14. Known Limitations / Future Improvements

The main assessment requirements are complete.

With more time, I would consider adding:

* More unit and widget tests
* Persistent favorites using local storage
* Offline caching
* Category filtering
* Improved tablet and large-screen layouts
* More detailed API error handling

15. AI Assistance

I used AI assistance for guidance, debugging support, and documentation review during parts of the development process.

I reviewed and tested the implementation and made sure I understood the code and architectural decisions included in the project.