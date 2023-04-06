import 'dart:math';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:item_viewer_app/widgets/product_widget.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int skip = 0;
  final int limit = 10;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;
  bool isLoadMoreRunning = false;
  late Future<List<ProductModel>> products;
  List<ProductModel> prevProducts = [];

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
    });
    products = getProductsWithLimit(limit, skip);
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false) {
      setState(() {
        isLoadMoreRunning = true;
        skip += 9;
      });

      // Future<List<ProductModel>> temp =
      //     appendElements(getProductsWithLimit(limit, skip), prevProducts);
      // products = temp;

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  Future<List<ProductModel>> appendElements(
      Future<List<ProductModel>> listFuture,
      List<ProductModel> elementsToAdd) async {
    print('PREV LENGHT ${elementsToAdd.length}');

    final list = await listFuture;
    list.addAll(elementsToAdd);
    setState(() {
      prevProducts.clear();
      print('LIST LENGHT ${prevProducts.length}');
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    _firstLoad();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      //AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ),
        ],
      ),
      //BottomNavBar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
        ],
      ),
      //Body
      body: SingleChildScrollView(
        // controller: _controller,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Find the best product for you',
                style: GoogleFonts.bebasNeue(
                  fontSize: 56,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search what you want',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600)),
                ),
              ),
            ),
            const SizedBox(height: 25),
            //All items Text

            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Container(
                height: 40,
                child: const Text(
                  'All items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),

            FutureBuilder<List<ProductModel>?>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (150 / 195),
                    ),
                    itemBuilder: (context, index) {
                      print(snapshot.data![index].title);
                      // prevProducts.add(snapshot.data![index]);
                      return ProductWidget(product: snapshot.data![index]);
                    },
                  );
                } else if (snapshot.hasError) {
                  print(snapshot);
                  return const Text("Error");
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),

            IconButton(
              onPressed: loadMore,
              icon: Icon(Icons.add),
            ),

            isLoadMoreRunning
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox(height: 0)
          ],
        ),
      ),
    );
  }
}
