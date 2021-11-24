import 'dart:io';


import 'package:firebase/models/product_dao.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _img;
  String? _pathImage;
  UploadTask? storage;
  late FirebaseProvider _firestoreProvider;

  //Controllers
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();

  //inicializo
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestoreProvider = FirebaseProvider();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar productos'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: [
          _imgProduct(),
          const Divider(),
          _showImage(),
          const Divider(),
          _cveProduct(),
          const Divider(),
          _descriptionProduct(),
          const Divider(),
          _btnSave()
        ],
      ),
    );
  }

  //Mostrar imagen
  Widget _showImage(){
    return Center(
      child: _img != null
        ? Image.file(
          _img!,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        )
        : const Text('No hay imagen')
    );
  }

  //Elegir imagen
  Widget _imgProduct(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(onPressed: (){
          _capImg(ImageSource.gallery);
        }, child: const Icon(Icons.image))
      ],
    );
  }

  //Metodo seleccionar imagen
  _capImg(ImageSource source)async{
    final picker = new ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if(pickedFile == null){
      return;
    } else {
      final imagePath = File(pickedFile.path);
      final nameImage = path.basename(pickedFile.path);
      setState(() {
        _img = imagePath;
        _pathImage = nameImage;
      });
    }
  }

  Widget _cveProduct(){
    return TextField(
      controller: _name,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: 'Clave producto',
        labelText: 'Clave producto',
        icon: const Icon(Icons.add_business_sharp)
      ),
      onChanged: (value){},
    );
  }

  Widget _descriptionProduct(){
    return TextField(
      controller: _description,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Descripción producto',
        labelText: 'Descripción producto',
        icon: const Icon(Icons.description_outlined)
      ),
      onChanged: (value){},
    );
  }

//Boton 
  Widget _btnSave(){
    return ElevatedButton(
      onPressed: () => _addImage(),
      child: const Text('Guardar'),
    );
  }

  //Metodo para subir imagen
  Future _storageImage() async{
    if(_img == null){
      return;
    } else {
      final dest = 'images/${_pathImage}';
      storage = _firestoreProvider.storageImg(dest, _img!);
      setState(() { });
       if(storage == null){
          return;
        } else {
          final snapshot  = await storage!.whenComplete(() {});
          final url = await snapshot.ref.getDownloadURL();
          return url;
        }
    }
  }

  //Insertar mi producto
  _addImage() async{
    if(_name.text != "" && _description.text != "" && _pathImage != null ){
      final _pathImage = await _storageImage();
      ProductDao objProduct = ProductDao(
        cveprod: _name.text,
        descprod: _description.text,
        imgprod: _pathImage,
      );
      await _firestoreProvider.saveProduct(objProduct);
      await Future.delayed(const Duration(milliseconds: 200));
      Navigator.pop(context);
    } else{
      return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
           title: Text('Error', style: TextStyle(color: Colors.red),),
            content: Text('Debe llenar todos los campos'),
          );
        }
      );
    }

  }


}