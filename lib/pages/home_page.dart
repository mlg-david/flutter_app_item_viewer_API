import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:item_viewer_app/widgets/product_widget.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int limit = 10;
  int skip = 0;
  bool _isFirstLoadRunning = false;
  bool hasNextPage = true;
  bool _isLoadMoreRunning = false;

  List post = [];

//Run on the first load to get products
  void firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    var jsonData = await getProductsWithLimit(limit, skip);

    if (jsonData.isNotEmpty) {
      setState(() {
        post = jsonData['products'] as List;
      });
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

//Function to get more products and append on the previously fetched ones
  void loadMore() async {
    if (hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      skip += 9;

      var jsonData = await getProductsWithLimit(limit, skip);
      final List fetchedPost = jsonData['products'] as List;

      if (fetchedPost.isNotEmpty) {
        setState(() {
          post.addAll(fetchedPost);
        });
      } else {
        setState(() {
          hasNextPage = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    firstLoad();
    _controller = ScrollController()..addListener(loadMore);
  }

  @override
  Widget build(BuildContext context) {
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
        controller: _controller,
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
            _isFirstLoadRunning
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: post.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (150 / 195),
                    ),
                    itemBuilder: (context, index) {
                      return ProductWidget(product: post[index]);
                    },
                  ),

            //Show Loading when fetching new Products
            if (_isLoadMoreRunning)
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            //Display a message when all products has been fetched
            if (!hasNextPage)
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                color: Colors.orange,
                child: const Center(
                  child: Text('No more products to show'),
                ),
              )
          ],
        ),
      ),
    );
  }
}
