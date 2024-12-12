import 'package:vania/vania.dart';
import 'package:grocery/app/models/order.dart'; // Import OrderModel
import 'package:grocery/app/models/customer.dart'; // Import CustomerModel jika diperlukan
import 'package:vania/src/exception/validation_exception.dart';

class OrderController extends Controller {
  // Method to list all orders
  Future<Response> index() async {
    try {
      final orders = await OrderModel()
          .query()
          .join('customers', 'customers.cust_id', '=', 'orders.cust_id')
          .select([
        'customers.cust_name',
        'customers.cust_id',
        'orders.order_num',
        'orders.order_date'
      ]).get();

      if (orders.isEmpty) {
        return Response.json({
          "message": "No orders found",
          "code": 404,
        }, 404);
      }

      final responseData = orders.map((order) {
        return {
          "customer_name": order["cust_name"] ?? "N/A",
          "customer_id": order["cust_id"] ?? "N/A",
          "order_num": order["order_num"] ?? "N/A",
          "order_date": order["order_date"] ?? "N/A"
        };
      }).toList();

      return Response.json({
        "message": "Orders fetched successfully",
        "code": 200,
        "data": responseData,
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

  // Method to create a new order (only displays template response)
  Future<Response> create() async {
    return Response.json({
      "message": "Create a new order",
    });
  }

  // Method to store a new order
  Future<Response> store(Request request) async {
    try {
      // Validate input
      request.validate({
        'order_num': 'required|integer|unique:orders,order_num',
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
      });

      final orderNum = request.input('order_num');
      final orderDate = request.input('order_date');
      final custId = request.input('cust_id');

      // Check if the customer exists
      final customer =
          await CustomerModel().query().where('cust_id', '=', custId).first();

      if (customer == null) {
        return Response.json({
          'success': false,
          'message': 'Customer not found',
        }, 404);
      }

      // Insert new order
      await OrderModel().query().insert({
        "order_num": orderNum,
        "order_date": orderDate,
        "cust_id": custId,
      });

      return Response.json({
        "message": "Order created successfully",
        "code": 201,
      }, 201);
    } catch (e) {
      print('Error: $e');
      if (e is ValidationException) {
        return Response.json({
          "message": e.message, // Pesan dari ValidationException
          "code": 400, // Bad Request
        }, 400);
      } else {
        return Response.json({
          "message": "Internal server error",
          "code": 500,
          "data": e.toString(),
        }, 500);
      }
    }
  }

  // Method to show a single order by ID
  Future<Response> show(int id) async {
    try {
      final order = await OrderModel()
          .query()
          .join('customers', 'customers.cust_id', '=', 'orders.cust_id')
          .where('order_num', '=', id.toString())
          .first();

      if (order == null) {
        return Response.json({
          "message": "Order not found",
          "code": 404,
        }, 404);
      }

      return Response.json({
        "message": "Order found",
        "code": 200,
        "data": order,
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

  // Method to update an existing order
  Future<Response> update(Request request, int id) async {
  try {
    // Validasi input
    request.validate({
      'cust_id': 'required|string|max_length:5',
      'order_date': 'required|date',
    });

    // Pastikan order dengan `order_num` ada di database
    final existingOrder = await OrderModel()
        .query()
        .where('order_num', '=', id)
        .first();

    if (existingOrder == null) {
      return Response.json({
        'message': 'Order dengan nomor $id tidak ditemukan',
      }, 404); // HTTP Status Code 404 Not Found
    }

    // Cek jika customer dengan `cust_id` ada
    final customer = await CustomerModel()
        .query()
        .where('cust_id', '=', request.body['cust_id'])
        .first();

    if (customer == null) {
      return Response.json({
        'message': 'Customer dengan ID ${request.body['cust_id']} tidak ditemukan',
      }, 404); // HTTP Status Code 404 Not Found
    }

    // Update data order
    final updated = await OrderModel()
        .query()
        .where('order_num', '=', id)
        .update({
          'cust_id': request.body['cust_id'],
          'order_date': request.body['order_date'],
        });

    if (updated == 0) {
      return Response.json({
        'message': 'Gagal memperbarui data',
      }, 400); // HTTP Status Code 400 Bad Request
    }

    return Response.json({
      'message': 'Order dengan nomor $id berhasil diperbarui',
    }, 200); // HTTP Status Code 200 OK
  } catch (e) {
    // Tangani error tak terduga
    return Response.json({
      'message': 'Terjadi kesalahan saat memperbarui order',
      'error': e.toString(),
    }, 500); // HTTP Status Code 500 Internal Server Error
  }
}


  Future<Response> edit(int id) async {
    return Response.json({});
  }

  // Method to delete an order
  Future<Response> destroy(int id) async {
    try {
      final order = await OrderModel()
          .query()
          .where('order_num', '=', id.toString())
          .first();

      if (order == null) {
        return Response.json({
          "message": "Order not found",
          "code": 404,
        }, 404);
      }

      await OrderModel()
          .query()
          .where('order_num', '=', id.toString())
          .delete();

      return Response.json({
        'message': 'Order deleted successfully',
        'code': 200,
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

final OrderController orderController = OrderController();
