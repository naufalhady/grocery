import 'package:vania/vania.dart';
import 'package:grocery/app/models/productnote.dart'; // Import ProductNoteModel
import 'package:grocery/app/models/product.dart'; // Import ProductModel jika diperlukan

class ProductNotesController extends Controller {
  // Fetch all product notes
  Future<Response> index() async {
    final notes = await ProductNote().query().get();
    return Response.json({'message': 'Data found', 'data': notes});
  }

  // Store a new product note
  Future<Response> store(Request request) async {
    try {
      // Validasi input dari klien
      request.validate({
        'note_id': 'required|string|max_length:5|unique:product_notes,note_id',
        'prod_id': 'required|string|max_length:10|exists:products,prod_id',
        'note_date': 'required|date',
        'note': 'required|string|max_length:500',
      });

      // Cari produk berdasarkan prod_id yang diberikan
      final product = await ProductModel()
          .query()
          .where('prod_id', '=', request.body['prod_id'])
          .first();

      if (product == null) {
        return Response.json(
            {'message': 'Product not found', 'code': 404}, 404);
      }

      // Insert data ke tabel product_notes
      await ProductNote().query().insert({
        'note_id': request.body['note_id'],
        'prod_id': request.body['prod_id'],
        'note_date': request.body['note_date'],
        'note': request.body['note'],
      });

      return Response.json({
        'message': 'Data inserted successfully',
        'code': 201,
      }, 201);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'code': 500,
        'error': e.toString(),
      }, 500);
    }
  }

  // Create a new product note (you can expand this if necessary)
  Future<Response> create() async {
    return Response.json({});
  }

  // Show a specific product note by ID
  Future<Response> show(String id) async {
    try {
      // Cari catatan berdasarkan note_id
      final note =
          await ProductNote().query().where('note_id', '=', id).first();

      if (note == null) {
        return Response.json({
          'message': 'Data not found',
          'code': 404,
        }, 404);
      }

      return Response.json({
        'message': 'Data found',
        'code': 200,
        'data': note,
      });
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'code': 500,
        'error': e.toString(),
      }, 500);
    }
  }

  // Update an existing product note
  Future<Response> update(Request request, String id) async {
    try {
      // Cari catatan berdasarkan note_id
      final note =
          await ProductNote().query().where('note_id', '=', id).first();

      if (note == null) {
        return Response.json({
          'message': 'Data not found',
          'code': 404,
        }, 404);
      }

      // Validasi input dari klien (opsional jika perlu)
      request.validate({
        'prod_id': 'string|max_length:10|exists:products,prod_id',
        'note_date': 'date',
        'note': 'string|max_length:500',
      });

      // Update data
      await ProductNote().query().where('note_id', '=', id).update({
        'prod_id':
            request.body['prod_id'] ?? note['prod_id'], // Mengakses dari Map
        'note_date': request.body['note_date'] ??
            note['note_date'], // Mengakses dari Map
        'note': request.body['note'] ?? note['note'], // Mengakses dari Map
      });

      return Response.json({
        'message': 'Data updated successfully',
        'code': 200,
      });
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'code': 500,
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  // Delete an existing product note
  Future<Response> destroy(String id) async {
  try {
    // Cari catatan berdasarkan note_id
    final note = await ProductNote().query().where('note_id', '=', id).first();

    if (note == null) {
      return Response.json({
        'message': 'Data not found',
        'code': 404,
      }, 404);
    }

    // Hapus data berdasarkan note_id
    await ProductNote().query().where('note_id', '=', id).delete();

    return Response.json({
      'message': 'Data deleted successfully',
      'code': 200,
    });
  } catch (e) {
    return Response.json({
      'message': 'Internal Server Error',
      'code': 500,
      'error': e.toString(),
    }, 500);
  }
}

}

final ProductNotesController productNotesController = ProductNotesController();
