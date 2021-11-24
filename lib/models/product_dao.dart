class ProductDao{
  String? cveprod;
  String? descprod;
  String? imgprod;

  //Constructor
  ProductDao({this.cveprod, this.descprod, this.imgprod});
  //Convertir a mapa
  Map<String, dynamic> toMap(){
    return{
      'cveprod' : cveprod,
      'descprod': descprod,
      'imgprod' : imgprod
    };
  }


}