import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class RecommendationsPage extends StatefulWidget {
  final String? firstName;

  const RecommendationsPage({super.key, this.firstName});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  String _userName = 'User';
  List<String> _businessNames = [];

  @override
  void initState() {
    super.initState();
    _loadBusinessNames();
  }

  Future<void> _loadBusinessNames() async {
    final String fileContent = await rootBundle.loadString('assets/data/business_names.txt');
    setState(() {
      _businessNames = fileContent.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    });
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.firstName != null && widget.firstName!.isNotEmpty) {
      _userName = widget.firstName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar
          Container(
            padding: const EdgeInsets.only(
              top: kToolbarHeight,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            color: const Color(0xFF4285F4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamed(context, '/profile');
                    if (result is Map && result.containsKey('firstName')) {
                      setState(() {
                        _userName = result['firstName'].toString().isNotEmpty ? result['firstName'] : 'User';
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Welcome, $_userName!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: _confirmLogout,
                ),
              ],
            ),
          ),

          // Category Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CategoryButton(label: "Food"),
                CategoryButton(label: "Places"),
                CategoryButton(label: "Activities"),
                CategoryButton(label: "Shopping"),
              ],
            ),
          ),

          // Product list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => ProductCard(
                businessNames: _businessNames,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  const CategoryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final List<String> businessNames;
  ProductCard({super.key, required this.businessNames});

  final List<String> _localImages = [
    'assets/images/reco1.jpg',
    'assets/images/reco2.jpg',
    'assets/images/reco3.jpg',
    'assets/images/reco5.jpg',
    'assets/images/reco6.jpg',
    'assets/images/reco7.jpg',
    'assets/images/reco8.jpg',
    'assets/images/reco9.jpg',
    'assets/images/reco10.jpg',
  ];

  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    final String selectedImage = _localImages[_random.nextInt(_localImages.length)];
    final String randomBusiness = businessNames.isNotEmpty
        ? businessNames[_random.nextInt(businessNames.length)]
        : "Product Name";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  selectedImage,
                  height: 121,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "BRAND/CATEGORY",
            style: TextStyle(
              color: Color(0xFF979797),
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            randomBusiness,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star, size: 16, color: Colors.amber),
              Icon(Icons.star_border, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                "32",
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "\$1199",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/recommendations');
            break;
          case 1:
            Navigator.pushNamed(context, '/calendar');
            break;
          case 2:
            Navigator.pushNamed(context, '/chatbot');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile');
            break;
          case 4:
            Navigator.pushNamed(context, '/premium');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chatbot"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: "Premium Version"),
      ],
    );
  }
}
