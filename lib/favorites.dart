import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadFavorites(); // refresh data setiap kali halaman muncul
  }

  void loadFavorites() async {
    // Ambil username dari SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    // Buka Hive box untuk favorites
    var box = await Hive.openBox('favorites');

    // Ambil data favorit sesuai username
    Map userFavorites = box.get(username, defaultValue: {}) as Map;

    setState(() {
      favorites = userFavorites.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text("Favorites", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body:
          favorites.isEmpty
              ? const Center(child: Text("Belum ada favorit"))
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
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailPage(id: restaurant['id']),
                        ),
                      );
                      // Cek jika dari DetailPage ada perubahan data
                      if (result == true) {
                        loadFavorites(); // Fungsi untuk ambil ulang data dari Hive
                      }
                    },
                  );
                },
              ),
    );
  }
}
