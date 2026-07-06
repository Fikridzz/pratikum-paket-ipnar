import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_provider.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController ctrName = TextEditingController();
  final ApiService api = ApiService();
  final StorageService storage = StorageService();

  String dataTersimpan = "Belum ada data";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Praktikum Flutter")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            //  HTTP
            FutureBuilder(
              future: api.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text("Name: ${data['name']}"),
                          Text("Email: ${data['email']}"),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error");
                }
                return CircularProgressIndicator();
              },
            ),
            SizedBox(height: 32),
            Consumer<CounterProvider>(
              builder: (context, provider, child) =>
                  Text("Count: ${provider.count}"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<CounterProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: () {
                        provider.increment();
                      },
                      child: Text("Tambah"),
                    );
                  },
                ),
                Consumer<CounterProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: () {
                        provider.decrement();
                      },
                      child: Text("Kurang"),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            // SHARED PREFERENCES
            Text("Data: $dataTersimpan"),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: ctrName,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: 'Nama',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  hintStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (ctrName.text.isNotEmpty) {
                  await storage.saveData(ctrName.text);

                  setState(() {
                    dataTersimpan = "Data berhasil disimpan";
                  });
                }
              },
              child: Text("Simpan Data"),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                String? data = await storage.loadData();
                setState(() {
                  dataTersimpan = data ?? "Tidak ada data";
                });
              },
              child: Text("Ambil Data"),
            ),
          ],
        ),
      ),
    );
  }
}
