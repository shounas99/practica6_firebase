import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase/views/card_product.dart';
import 'package:flutter/material.dart';

class ListProducts extends StatefulWidget {
  ListProducts({Key? key}) : super(key: key);

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {

  late FirebaseProvider _firebaseProvider;

  //Defino el firebaseProvider
  @override
  void initState() {
    super.initState();
    _firebaseProvider = FirebaseProvider();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/addProduct'),
            icon: const Icon(Icons.add)
          )
        ],
      ),

      body: StreamBuilder(
        stream: _firebaseProvider.getAllProducts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document){
              return CardProduct(productDocument: document);
            }).toList(),
          );
        }
      ),
    );
  }
}