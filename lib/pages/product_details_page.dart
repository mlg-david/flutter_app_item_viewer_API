import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    late Future<ProductModel?> _productModel;

    _productModel = getSingleProduct(id);

    return Scaffold(
      body: FutureBuilder(
        future: _productModel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Text(snapshot.data!.title.toString());
            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.images?.length,
                              itemBuilder: (context, index) => Image.network(
                                '${snapshot.data!.images?[index]}',
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.grey.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back_ios_new),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${snapshot.data!.title}',
                              style: const TextStyle(
                                fontSize: 30,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Product of ${snapshot.data!.brand}',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  letterSpacing: 3),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data!.rating}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                RatingBar.builder(
                                  initialRating: snapshot.data!.rating ?? 1,
                                  minRating: 1,
                                  itemSize: 20,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Stock: ${snapshot.data!.stock}',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        letterSpacing: 3),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '\$${snapshot.data!.price}',
                                    style: const TextStyle(
                                        letterSpacing: 3, color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '${snapshot.data!.description}', // textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  letterSpacing: 3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
