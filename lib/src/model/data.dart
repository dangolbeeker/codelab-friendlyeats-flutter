import 'package:cloud_firestore/cloud_firestore.dart';

import './filter.dart';
import './restaurant.dart';
import './review.dart';

// This is the file that Codelab users will primarily work on.

Future<void> addRestaurant(Restaurant restaurant) {
  final restaurants = FirebaseFirestore.instance.collection('restaurants');
  return restaurants.add({
    'avgRating': restaurant.avgRating,
    'category': restaurant.category,
    'city': restaurant.city,
    'name': restaurant.name,
    'numRatings': restaurant.numRatings,
    'photo': restaurant.photo,
    'price': restaurant.price,
  });
}

Stream<QuerySnapshot> loadAllRestaurants() {
  // TODO: Complete the "Display data from Cloud Firestore" step.
  return Stream<QuerySnapshot>.value(null);
}

List<Restaurant> getRestaurantsFromQuery(QuerySnapshot snapshot) {
  // TODO: Complete the "Display data from Cloud Firestore" step.
  return [];
}

Future<Restaurant> getRestaurant(String restaurantId) {
  // TODO: Complete the "Get data" step.
  return Future.value(null);
}

Future<void> addReview({String restaurantId, Review review}) {
  // TODO: Complete the "Write data in a transaction" step.
  return Future.value();
}

Stream<QuerySnapshot> loadFilteredRestaurants(Filter filter) {
  // TODO: Complete the "Sorting and filtering data" step.
  return Stream<QuerySnapshot>.value(null);
}

void addRestaurantsBatch(List<Restaurant> restaurants) {
  restaurants.forEach((Restaurant restaurant) {
    addRestaurant(restaurant);
  });
}
