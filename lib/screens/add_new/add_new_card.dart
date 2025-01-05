import 'package:flutter/material.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Kartu Baru'),
        backgroundColor: Colors.blue[200],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Unggah Gambar
              const Text(
                'Unggah Gambar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    // Implementasi fungsi untuk mengunggah gambar
                  },
                  child: const SizedBox(
                    height: 150,
                    child: Center(
                      child: Icon(Icons.image, size: 48),
                    ),
                  ),
                ),
              ),

              // Kata/Keterangan
              const Text(
                'Kata/Keterangan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Masukkan kata/keterangan',
                ),
              ),
              const SizedBox(height: 16.0),

              // Rekam Suara
              const Text(
                'Rekam Suara',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implementasi fungsi untuk merekam suara
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Mulai Rekam'),
              ),
              const SizedBox(height: 16.0),

              // Pilih Album
              const Text(
                'Pilih Album',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildAlbumItem('Buah-buahan'),
                  _buildAlbumItem('Buah-buahan'),
                  _buildAlbumItem('Buah-buahan'),
                  _buildAlbumItem('Buah-buahan'),
                ],
              ),
              const SizedBox(height: 32.0),

              // Tombol Batal dan Simpan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implementasi fungsi untuk tombol Batal
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implementasi fungsi untuk tombol Simpan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat item album
  Widget _buildAlbumItem(String namaAlbum) {
    return ElevatedButton(
      onPressed: () {
        // Implementasi fungsi saat item album ditekan
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Text(namaAlbum),
    );
  }
}