import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistory extends StatefulWidget {
  OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final CollectionReference orderHistory =
      FirebaseFirestore.instance.collection('order');

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference packet =
      FirebaseFirestore.instance.collection('paket_makeup');

  Future<Map<String, dynamic>> getDataUser(String userId) async {
    final snapshot = await users.doc(userId).get();
    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    }
    return {};
  }

  Future<Map<String, dynamic>> getPacketMakeup(String packetId) async {
    final snapshot = await packet.doc(packetId).get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    }
    return {};
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Pemesanan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderHistory.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          String defaultImage =
              "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg?w=1060";

          final pemesanan = snapshot.data!.docs;
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: pemesanan.length,
                itemBuilder: (context, index) {
                  final data = pemesanan[index].data() as Map<String, dynamic>;
                  final idPemesanan = pemesanan[index].id;
                  final userId = data['UserUid'];
                  final packetId = data['PacketId'];

                  return FutureBuilder<Map<String, dynamic>>(
                    future: getDataUser(userId),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasData) {
                        final dataUser = userSnapshot.data!;
                        return FutureBuilder<Map<String, dynamic>>(
                          future: getPacketMakeup(packetId),
                          builder: (context, packetSnapshot) {
                            if (packetSnapshot.hasData) {
                              final dataPacket = packetSnapshot.data!;
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('ID Pemesanan : $idPemesanan'),
                                      const SizedBox(height: 8.0),
                                      Text(
                                          'Status : ${data['PaymentStatus'] ?? ''}'),
                                      const SizedBox(height: 8.0),
                                      // Tambahkan informasi status pembayaran
                                      Text(
                                          'Status Pembayaran : ${data['Status'] ?? 'PENDING'}'),
                                      const SizedBox(height: 8.0),
                                      // Tambahkan informasi harga yang dibayarkan
                                      Text(
                                          'Jumlah Dibayar : Rp ${(data['PaidAmount'] ?? 0).toString()}'),
                                      const SizedBox(height: 8.0),
                                      // Tambahkan informasi total harga
                                      Text(
                                          'Total Harga : Rp ${(data['TotalPrice'] ?? 0).toString()}'),
                                      const SizedBox(height: 8.0),
                                      // Tambahkan informasi status lunas
                                      Text(
                                          'Status Lunas : ${data['PaidOff'] == true ? 'Lunas' : 'Belum Lunas'}'),
                                      const SizedBox(height: 8.0),
                                      Text(
                                          'Nama Lengkap Pemesan : ${dataUser['fullname'] ?? ''}'),
                                      const SizedBox(height: 8.0),
                                      Text(
                                          'Email : ${dataUser['email'] ?? ''}'),
                                      const SizedBox(height: 8.0),
                                      Text(
                                          'Nomor Telepon : ${dataUser['phone'] ?? ''}'),
                                      const SizedBox(height: 8.0),
                                      Text('Alamat : ${data['Address']}'),
                                      const SizedBox(height: 8.0),
                                      Text(
                                          'Nama Paket : ${dataPacket['Name'] ?? ''}'),
                                      const SizedBox(height: 8.0),
                                      Text(
                                          'Deskripsi : ${dataPacket['Description'] ?? ''}'),
                                      const SizedBox(height: 8.0),
                                      Image.network(
                                        dataPacket['Image'] ?? defaultImage,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
