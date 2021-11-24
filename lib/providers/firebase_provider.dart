//El modelo tomara los obj para mandarlos a firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/product_dao.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
class FirebaseProvider {

  late FirebaseFirestore _firestore;
  late CollectionReference _productsCollection;

  //-----CONSTRUCTOR-----
  FirebaseProvider(){
    _firestore = FirebaseFirestore.instance;
    _productsCollection = _firestore.collection('products');
  }

  //-----GUARDAR PRODUCTO-----
  Future<void> saveProduct(ProductDao objPDAO){
    return _productsCollection.add(objPDAO.toMap());
  }
  //-----ACTUALIZAR PRODUCTO-----
  Future<void> updateProduct(ProductDao objPDAO, String DocumentID){
    return _productsCollection.doc(DocumentID).update(objPDAO.toMap());
  }
  //-----BORRAR PRODUCTO-----
  Future<void> deleteProduct(String DocumentID){
    return _productsCollection.doc(DocumentID).delete();
  }
  //-----OBTENER TODOS LOS PRODUCTOS-----
  Stream<QuerySnapshot> getAllProducts(){
    return _productsCollection.snapshots();
  }

  //-----Metodo para cargar mi imagen-----
   UploadTask? storageImg(String dest, File img){
     final ref = FirebaseStorage.instance.ref(dest);
     return ref.putFile(img);
   }
  

}