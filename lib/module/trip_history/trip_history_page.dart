import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedometer/api/endpoint/trip_data.dart';

class TripHistoryPage extends StatefulWidget {
  @override
  State<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  List<String> _tripHistory = [];

  @override
  void initState() {
    super.initState();
    _loadTripHistory();
  }

  Future<void> _loadTripHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tripHistory = prefs.getStringList('trips') ?? [];
    });
  }

  Future<void> _deleteTrip(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tripHistory.removeAt(index);
      prefs.setStringList('trips', _tripHistory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Perjalanan'),
      ),
      body: _tripHistory.isEmpty
          ? const Center(child: Text('Tidak ada riwayat perjalanan.'))
          : ListView.builder(
              itemCount: _tripHistory.length,
              itemBuilder: (context, index) {
                TripData tripData = TripData.fromJson(_tripHistory[index]);
                return Dismissible(
                  key: Key(_tripHistory[index]),
                  direction: DismissDirection.endToStart, // Geser ke kanan untuk hapus
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteTrip(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Perjalanan ${index + 1} dihapus')),
                    );
                  },
                  child: ListTile(
                    title: Text('Perjalanan ${index + 1}'),
                    subtitle: Text(
                      'Jarak: ${tripData.distance} km, Kecepatan Maksimal: ${tripData.maxSpeed} km/jam',
                    ),
                    onTap: () {
                      // Tambahkan navigasi ke halaman detail perjalanan jika diperlukan
                    },
                  ),
                );
              },
            ),
    );
  }
}
