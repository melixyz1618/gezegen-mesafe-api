import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'starfield.dart';

void main() {
  runApp(PlanetApp());
}

class PlanetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gezegen Mesafeleri',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.deepPurple,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: PlanetDistancePage(),
    );
  }
}

class PlanetDistancePage extends StatefulWidget {
  @override
  _PlanetDistancePageState createState() => _PlanetDistancePageState();
}

class _PlanetDistancePageState extends State<PlanetDistancePage> {
  List<dynamic> planetDistances = [];
  bool isLoading = false;

  Future<void> fetchPlanetDistances() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://gezegen-mesafe-api.onrender.com/mesafeler'),
    );

    if (response.statusCode == 200) {
      setState(() {
        planetDistances = json.decode(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      setState(() {
        planetDistances = [];
        isLoading = false;
      });
      throw Exception('API bağlantısı başarısız');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> ikonDosya = {
      'Güneş': 'gunes.png',
      'Ay': 'ay.png',
      'Merkür': 'merkur.png',
      'Venüs': 'venus.png',
      'Mars': 'mars.png',
      'Jüpiter': 'jupiter.png',
      'Satürn': 'saturn.png',
      'Uranüs': 'uranus.png',
      'Neptün': 'neptun.png',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dünya – Gezegen Mesafeleri'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          const Starfield(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : planetDistances.isEmpty
                      ? const Center(child: Text('Veri henüz yüklenmedi.'))
                      : ListView.builder(
                    itemCount: planetDistances.length,
                    itemBuilder: (context, index) {
                      final gezegen = planetDistances[index];
                      final String gezegenAdi = gezegen['gezegen'];
                      final String ikon = ikonDosya[gezegenAdi] ?? '';

                      return ListTile(
                        leading: ikon.isNotEmpty
                            ? Image.asset(
                          'assets/planets/$ikon',
                          width: 40,
                          height: 40,
                        )
                            : null,
                        title: Text(gezegenAdi),
                        trailing: Text(
                          '${NumberFormat.decimalPattern().format(gezegen['mesafe_km'])} km',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: fetchPlanetDistances,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Güncel Mesafeleri Getir',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
