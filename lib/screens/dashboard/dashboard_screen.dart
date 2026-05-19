import 'package:flutter/material.dart';

// fl_chart temporarily disabled due to SDK constraints
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: const [
                  Text('Total Pemasukan Hari Ini',
                      style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text('Rp 0',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      'Grafik akan ditampilkan di sini\n(pindah ke fl_chart setelah upgrade SDK)',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/transaction/add'),
          child: const Icon(Icons.add)),
    );
  }
}
