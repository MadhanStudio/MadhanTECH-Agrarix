import 'package:cloud_firestore/cloud_firestore.dart';

class QuestModel {
  final String id;
  final String akun;
  final String lokasi;
  final String kontak;
  final int harga;
  final int jumlah;
  final String status;
  final String ownerId;
  final DateTime timestamp;
  final String barang; // <-- Tambahan field baru

  QuestModel({
    required this.id,
    required this.akun,
    required this.lokasi,
    required this.kontak,
    required this.harga,
    required this.jumlah,
    required this.status,
    required this.ownerId,
    required this.timestamp,
    required this.barang, // <-- Tambahkan juga di constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'akun': akun,
      'lokasi': lokasi,
      'kontak': kontak,
      'harga': harga,
      'jumlah': jumlah,
      'status': status,
      'ownerId': ownerId,
      'timestamp': timestamp,
      'barang': barang, // <-- Simpan ke Firestore
    };
  }

  factory QuestModel.fromMap(String id, Map<String, dynamic> map) {
    return QuestModel(
      id: id,
      akun: map['akun'],
      lokasi: map['lokasi'],
      kontak: map['kontak'],
      harga: map['harga'],
      jumlah: map['jumlah'],
      status: map['status'],
      ownerId: map['ownerId'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      barang: map['barang'], // <-- Ambil dari Firestore
    );
  }
}
