import 'package:grocery/app/models/customer.dart';
import 'package:vania/vania.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    try {
      final customersList = await CustomerModel().query().get();
      return Response.json({
        "message": "Success",
        "code": 200,
        "data": customersList,
      });
    } catch (e) {
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
        "error": e.toString(),
      }, 500);
    }
  }

  Future<Response> create() async {
    return Response.json({
      "message": "Provide data in the `store` endpoint.",
      "code": 200,
    });
  }

  Future<Response> store(Request request) async {
    try {
      // Validasi input dari klien
      request.validate({
        'cust_id': 'required|string|max_length:10|unique:customers,cust_id',
        'cust_name': 'required|string|max_length:100',
        'cust_address': 'required|string|max_length:255',
        'cust_city': 'required|string|max_length:50',
        'cust_state': 'required|string|max_length:50',
        'cust_zip': 'required|string|max_length:10',
        'cust_country': 'required|string|max_length:50',
        'cust_telp': 'required|string|max_length:15',
      });

      // Insert data ke database
      await CustomerModel().query().insert({
        'cust_id': request.body['cust_id'],
        'cust_name': request.body['cust_name'],
        'cust_address': request.body['cust_address'],
        'cust_city': request.body['cust_city'],
        'cust_state': request.body['cust_state'],
        'cust_zip': request.body['cust_zip'],
        'cust_country': request.body['cust_country'],
        'cust_telp': request.body['cust_telp']
      });

      // Berikan respons sukses
      return Response.json({'message': 'Data inserted successfully'},
          201); // HTTP Status Code 201 Created
    } catch (e) {
      // Tangani error tak terduga
      return Response.json({
        'message': 'Terjadi kesalahan saat menyimpan data',
        'error': e.toString(),
      }, 500); // HTTP Status Code 500 Internal Server Error
    }
  }

  Future<Response> show(dynamic id) async {
    try {
      final customer = await CustomerModel()
          .query()
          .where('cust_id', '=', id.toString())
          .first();

      if (customer == null) {
        return Response.json({
          "message": "Customer not found",
          "code": 404,
        }, 404);
      }

      return Response.json({
        "message": "Customer found",
        "code": 200,
        "data": customer,
      });
    } catch (e) {
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
        "error": e.toString(),
      }, 500);
    }
  }

  Future<Response> edit(dynamic id) async {
    return Response.json({
      "message": "Edit customer functionality not implemented",
      "code": 200,
    });
  }

  Future<Response> update(Request request, String id) async {
    try {
      // Cari data customer berdasarkan ID
      final customer =
          await CustomerModel().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({
          "message": "Customer dengan ID $id tidak ditemukan",
        }, 404); // HTTP Status Code 404 Not Found
      }

      // Validasi input
      request.validate({
        'cust_name': 'required|string|max_length:100',
        'cust_address': 'required|string|max_length:255',
        'cust_city': 'required|string|max_length:50',
        'cust_state': 'required|string|max_length:50',
        'cust_zip': 'required|string|max_length:10',
        'cust_country': 'required|string|max_length:50',
        'cust_telp': 'required|string|max_length:15',
      });

      // Update data customer
      await CustomerModel().query().where('cust_id', '=', id).update({
        'cust_name': request.body['cust_name'],
        'cust_address': request.body['cust_address'],
        'cust_city': request.body['cust_city'],
        'cust_state': request.body['cust_state'],
        'cust_zip': request.body['cust_zip'],
        'cust_country': request.body['cust_country'],
        'cust_telp': request.body['cust_telp'],
      });

      return Response.json({
        "message": "Customer dengan ID $id berhasil diperbarui",
      }, 200); // HTTP Status Code 200 OK
    } catch (e) {
      // Tangani error tak terduga
      return Response.json({
        "message": "Terjadi kesalahan saat memperbarui data customer",
        "error": e.toString(),
      }, 500); // HTTP Status Code 500 Internal Server Error
    }
  }

  Future<Response> destroy(String id) async {
    try {
      // Cek jika customer ada di database
      final customer =
          await CustomerModel().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({
          "message": "Customer dengan ID $id tidak ditemukan",
        }, 404); // HTTP Status Code 404 Not Found
      }

      // Hapus customer dari database
      await CustomerModel().query().where('cust_id', '=', id).delete();

      return Response.json({
        "message": "Customer dengan ID $id berhasil dihapus",
      }, 200); // HTTP Status Code 200 OK
    } catch (e) {
      // Tangani error tak terduga
      return Response.json({
        "message": "Terjadi kesalahan saat menghapus customer",
        "error": e.toString(),
      }, 500); // HTTP Status Code 500 Internal Server Error
    }
  }
}

final CustomerController customerController = CustomerController();
