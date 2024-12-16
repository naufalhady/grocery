import 'package:vania/vania.dart';
import 'package:grocery/app/models/vendor.dart'; // Import VendorModel

class VendorController extends Controller {
  // Method to list all vendors
  Future<Response> index() async {
    try {
      // Ambil semua data vendor
      final vendorsList = await VendorModel().query().get();
      return Response.json({
        "message": "Success",
        "code": 200,
        "data": vendorsList,
      });
    } catch (e) {
      // Jika terjadi error
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
        "error": e.toString(),
      }, 500);
    }
  }

  // Method to create a new vendor
  Future<Response> create() async {
    return Response.json({
      "message": "Create a new vendor",
    });
  }

  // Method to store a new vendor
  Future<Response> store(Request request) async {
    try {
      // Validasi input dari klien
      request.validate({
        'vend_id': 'required|string|max_length:5|unique:vendors,vend_id',
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string',
        'vend_city': 'required|string',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      });

      // Insert data vendor baru ke dalam tabel vendors
      await VendorModel().query().insert({
        'vend_id': request.body['vend_id'],
        'vend_name': request.body['vend_name'],
        'vend_address': request.body['vend_address'],
        'vend_city': request.body['vend_city'],
        'vend_state': request.body['vend_state'],
        'vend_zip': request.body['vend_zip'],
        'vend_country': request.body['vend_country'],
      });

      return Response.json({
        'message': 'Vendor created successfully',
        'code': 201,
      }, 201);
    } catch (e) {
      // Jika terjadi error
      return Response.json({
        'message': 'Internal Server Error',
        'code': 500,
        'error': e.toString(),
      }, 500);
    }
  }

  // Method to show a single vendor by ID
  Future<Response> show(int id) async {
    return Response.json({});
  }

  // Method to update an existing vendor
  Future<Response> update(Request request, String id) async {
    try {
      final vendor =
          await VendorModel().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json({
          "message": "Vendor not found",
          "code": 404,
        }, 404);
      }

      request.validate({
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string',
        'vend_city': 'required|string',
        'vend_state': 'required|string|length:5',
        'vend_zip': 'required|string|length:7',
        'vend_country': 'required|string|max_length:25',
      });

      await VendorModel().query().where('vend_id', '=', id).update({
        "vend_name": request.input('vend_name'),
        "vend_address": request.input('vend_address'),
        "vend_city": request.input('vend_city'),
        "vend_state": request.input('vend_state'),
        "vend_zip": request.input('vend_zip'),
        "vend_country": request.input('vend_country'),
      });

      return Response.json({
        "message": "Vendor updated successfully",
        "code": 200,
      });
    } catch (e) {
      print('Error: $e');
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
        "data": e.toString(),
      }, 500);
    }
  }

  // Method to prepare data for editing a vendor
  Future<Response> edit(Request request, int id) async {
    return Response.json({});
  }

  // Method to delete a vendor
  Future<Response> destroy(String id) async {
    try {
      final vendor =
          await VendorModel().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json({
          "message": "Vendor not found",
          "code": 404,
        }, 404);
      }

      await VendorModel().query().where('vend_id', '=', id).delete();

      return Response.json({
        "message": "Vendor deleted successfully",
        "code": 200,
      });
    } catch (e) {
      print('Error: $e');
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
        "data": e.toString(),
      }, 500);
    }
  }
}

final VendorController vendorController = VendorController();
