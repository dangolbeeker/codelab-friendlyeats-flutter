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

//query that retrieves up to 50 restaurants from the top-level collection named restaurants, ordered by their average rating (currently all zero).
Stream<QuerySnapshot> loadAllRestaurants() {
  return FirebaseFirestore.instance
      .collection('restaurants')
      .orderBy('avgRating', descending: true)
      .limit(50)
      .snapshots();
}

/*converts all the documents contained in the snapshot into Restaurant objects 
that can be used elsewhere in your Flutter app.*/
List<Restaurant> getRestaurantsFromQuery(QuerySnapshot snapshot) {
  return snapshot.docs.map((DocumentSnapshot doc) {
    return Restaurant.fromSnapshot(doc);
  }).toList();
}

Future<Restaurant> getRestaurant(String restaurantId) {
  return FirebaseFirestore.instance
      .collection('restaurants')
      .doc(restaurantId)
      .get()
      .then((DocumentSnapshot doc) => Restaurant.fromSnapshot(doc));
}

//function triggers a transaction that starts by fetching
//a fresh version of the Restaurant represented by restaurantId.
Future<void> addReview({String restaurantId, Review review}) {
  final restaurant =
      FirebaseFirestore.instance.collection('restaurants').doc(restaurantId);
  final newReview = restaurant.collection('ratings').doc();
  //pdate the numeric values of avgRating and numRatings in the restaurant document reference.

  return FirebaseFirestore.instance.runTransaction((Transaction transaction) {
    return transaction
        //add the new review through the newReview document reference into the ratings subcollection of the restaurant.
        .get(restaurant)
        .then((DocumentSnapshot doc) => Restaurant.fromSnapshot(doc))
        .then((Restaurant fresh) {
      final newRatings = fresh.numRatings + 1;
      final newAverage =
          ((fresh.numRatings * fresh.avgRating) + review.rating) / newRatings;

      transaction.update(restaurant, {
        'numRatings': newRatings,
        'avgRating': newAverage,
      });

      transaction.set(newReview, {
        'rating': review.rating,
        'text': review.text,
        'userName': review.userName,
        'timestamp': review.timestamp ?? FieldValue.serverTimestamp(),
        'userId': review.userId,
      });
    });
  });
}

Stream<QuerySnapshot> loadFilteredRestaurants(Filter filter) {
  Query collection = FirebaseFirestore.instance.collection('restaurants');
  if (filter.category != null) {
    collection = collection.where('category', isEqualTo: filter.category);
  }
  if (filter.city != null) {
    collection = collection.where('city', isEqualTo: filter.city);
  }
  if (filter.price != null) {
    collection = collection.where('price', isEqualTo: filter.price);
  }
  return collection
      // build a compound query based on user input
      //only returns restaurants that match the user's requirements.
      .orderBy(filter.sort ?? 'avgRating', descending: true)
      .limit(50)
      .snapshots();
}

void addRestaurantsBatch(List<Restaurant> restaurants) {
  restaurants.forEach((Restaurant restaurant) {
    addRestaurant(restaurant);
  });
}
