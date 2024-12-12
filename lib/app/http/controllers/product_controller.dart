import 'package:vania/vania.dart';
import 'package:grocery/app/models/product.dart';
// import 'package:grocery/app/models/vendor.dart';
// import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
  // Method untuk mendapatkan semua produk
  Future<Response> index() async {
    try {
      final products = await ProductModel().query().select(
          ['prod_id', 'vend_id', 'prod_name', 'prod_price', 'prod_desc']).get();

      return Response.json({
        "message": "Daftar produk berhasil diambil",
        "data": products,
      }, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil produk",
        "error": e.toString(),
      }, 500);
    }
  }

  // Method untuk membuat produk (menampilkan form)
  Future<Response> create() async {
    return Response.json({
      "message": "Form untuk menambahkan produk",
    });
  }

  // Method untuk menambahkan produk baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'prod_id': 'required|string|max_length:10|unique:products,prod_id',
        'vend_id': 'required|string|max_length:5|exists:vendors,vend_id',
        'prod_name': 'required|string|max_length:25',
        'prod_price': 'required|integer|min:0',
        'prod_desc': 'string',
      });

      final productData = request.input();

      // Simpan produk ke database
      await ProductModel().query().insert(productData);

      return Response.json({
        "message": "Produk berhasil ditambahkan",
        "data": productData,
      }, 201);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat menambahkan produk",
        "error": e.toString(),
      }, 500);
    }
  }

  // Method untuk menampilkan detail satu produk
  Future<Response> show(int id) async {
    try {
      final product = await ProductModel()
          .query()
          .where('prod_id', '=', id.toString())
          .first();

      if (product == null) {
        return Response.json({
          "message": "Produk dengan ID $id tidak ditemukan",
        }, 404);
      }

      return Response.json({
        "message": "Detail produk berhasil diambil",
        "data": product,
      }, 200);
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil detail produk",
        "error": e.toString(),
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  // Method untuk menampilkan form edit produk
  Future<Response> update(Request request, String id) async {
    final product =
        await ProductModel().query().where('prod_id', '=', id).first();

    if (product == null) {
      return Response.json({'message': 'Data not found'});
    }

    await ProductModel().query().where('prod_id', '=', id).update({
      'vend_id': request.body['vend_id'],
      'prod_name': request.body['prod_name'],
      'prod_price': request.body['prod_price'],
      'prod_desc': request.body['prod_desc'],
    });

    return Response.json({'message': 'Data updated'});
  }

  // Method untuk menghapus produk
  Future<Response> destroy(String id) async {
    try {
      // Cek jika produk ada di database
      final product =
          await ProductModel().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          "message": "Produk dengan ID $id tidak ditemukan",
        }, 404); // HTTP Status Code 404 Not Found
      }

      // Hapus produk
      await ProductModel().query().where('prod_id', '=', id).delete();

      return Response.json({
        "message": "Produk dengan ID $id berhasil dihapus",
      }, 200); // HTTP Status Code 200 OK
    } catch (e) {
      // Tangani error tak terduga
      return Response.json({
        "message": "Terjadi kesalahan saat menghapus produk",
        "error": e.toString(),
      }, 500); // HTTP Status Code 500 Internal Server Error
    }
  }
}

final ProductController productController = ProductController();
