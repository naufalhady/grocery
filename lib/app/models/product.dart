import 'package:vania/vania.dart';

class ProductModel extends Model {
  ProductModel() {
    super.table('products'); // Tetapkan nama tabel
  }

  // Deklarasi kolom (tanpa anotasi)
  String? prodId;
  String? vendId;
  String? prodName;
  int? prodPrice;
  String? prodDesc;
  DateTime? updatedAt;
  DateTime? createdAt;
}
  