import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map? restaurant;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetail();
    checkFavorite();
  }

  Future<void> fetchRestaurantDetail() async {
    final response = await http.get(Uri.parse('https://restaurant-api.dicoding.dev/detail/${widget.id}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        restaurant = data['restaurant'];
      });
    }
  }

  void checkFavorite() async {
    var box = await Hive.openBox('favorites');
    setState(() {
      isFavorite = box.containsKey(widget.id);
    });
  }

  void toggleFavorite() async {
    var box = await Hive.openBox('favorites');
    String message;

    if (isFavorite) {
      box.delete(widget.id);
      message = 'Berhasil dihapus dari favorit';
    } else {
      box.put(widget.id, restaurant);
      message = 'Berhasil ditambahkan ke favorit';
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    // Tampilkan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color((0xFFF5F5DC)),
      appBar: AppBar(
        title: Text("Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF001F3F),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
          )
        ],
      ),
      body: restaurant == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://restaurant-api.dicoding.dev/images/small/${restaurant!["pictureId"]}',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    restaurant!['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Kota: ${restaurant!['city']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Alamat: ${restaurant!['address']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Rating: ${restaurant!['rating']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    restaurant!['description'],
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
    );
  }
}
