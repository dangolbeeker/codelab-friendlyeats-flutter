import 'package:flutter/material.dart';

import './model/restaurant.dart';
import './restaurant_star_rating.dart';

const double _kAppBarHeight = 140;

class RestaurantAppBar extends StatelessWidget {
  RestaurantAppBar({
    this.restaurant,
    Function onClosePressed,
  }) : _onPressed = onClosePressed;

  final Restaurant restaurant;

  final Function _onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: _onPressed,
        icon: Icon(Icons.close),
        iconSize: 32,
      ),
      expandedHeight: _kAppBarHeight,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              restaurant.name,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  padding: EdgeInsets.only(bottom: 2),
                  alignment: Alignment.bottomLeft,
                  child: StarRating(
                    rating: restaurant.rating,
                    small: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    List.filled(restaurant.price, "\$").join(),
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.caption.fontSize),
                  ),
                ),
              ],
            ),
            Text(
              '${restaurant.cuisine} ● ${restaurant.location}',
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.caption.fontSize),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              restaurant.imageUrl,
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/shadow.png',
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}