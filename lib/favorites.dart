import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'details.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    var box = await Hive.openBox('favorites');
    setState(() {
      favorites = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color((0xFFF5F5DC)),
      appBar: AppBar(title: Text("Favorites", style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF001F3F),),
      body: favorites.isEmpty
          ? Center(child: Text("Belum ada favorit"))
          : ListView.builder(

              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final restaurant = favorites[index];
                return ListTile(
                  leading: Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/${restaurant["pictureId"]}',
                    width: 50,
                  ),
                  title: Text(restaurant['name']),
                  subtitle: Text(restaurant['city']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(id: restaurant['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
