import 'package:vania/vania.dart';
import 'package:grocery/app/models/orderitem.dart'; // Import OrderItemModel
import 'package:grocery/app/models/order.dart'; // Import OrderModel jika diperlukan
import 'package:grocery/app/models/product.dart'; // Import ProductModel jika diperlukan
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemController extends Controller {
  // Method to list all order items
  Future<Response> index() async {
    try {
      final orderItems = await OrderItemModel()
          .query()
          .join('orders', 'orders.order_num', '=', 'orderitems.order_num')
          .join('products', 'products.prod_id', '=', 'orderitems.prod_id')
          .select([
        'orderitems.order_item',
        'orderitems.order_num',
        'orderitems.prod_id',
        'orderitems.quantity',
        'orderitems.size',
        'orders.order_date as order_date',
        'products.prod_name as product_name',
        'products.prod_price as product_price',
      ]).get();

      if (orderItems.isEmpty) {
        return Response.json({
          "message": "No order items found",
          "code": 404,
        }, 404);
      }

      final responseData = orderItems.map((item) {
        return {
          "order_item": item["order_item"],
          "order_num": item["order_num"],
          "prod_id": item["prod_id"],
          "quantity": item["quantity"],
          "size": item["size"],
          "order_date": item["order_date"],
          "product_name": item["product_name"],
          "product_price": item["product_price"],
        };
      }).toList();

      return Response.json({
        "message": "Order items fetched successfully",
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

  // Method to create a new order item
  Future<Response> create() async {
    return Response.json({
      "message": "Create a new order item",
    });
  }

  // Method to store a new order item
  Future<Response> store(Request request) async {
    try {
      // Validate input
      request.validate({
        'order_item': 'required|integer|unique:orderitems,order_item',
        'order_num': 'required|integer',
        'prod_id': 'required|string|max_length:5',
        'quantity': 'required|integer',
        'size': 'required|integer',
      });

      final orderItem = request.input('order_item');
      final orderNum = request.input('order_num');
      final prodId = request.input('prod_id');
      final quantity = request.input('quantity');
      final size = request.input('size');

      print('Order Num: $orderNum');

      // Check if the order exists
      final order =
          await OrderModel().query().where('order_num', '=', orderNum).first();
      print('Order Found: $order');

      if (order == null) {
        return Response.json({
          "message": "Order not found",
          "code": 404,
        }, 404);
      }

      // Check if the product exists
      final product =
          await ProductModel().query().where('prod_id', '=', prodId).first();
      print('Product Found: $product');

      if (product == null) {
        return Response.json({
          "message": "Product not found",
          "code": 404,
        }, 404);
      }

      // Insert new order item
      await OrderItemModel().query().insert({
        "order_item": orderItem,
        "order_num": orderNum,
        "prod_id": prodId,
        "quantity": quantity,
        "size": size,
      });

      return Response.json({
        "message": "Order item created successfully",
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

  // Method to show a single order item by ID
  Future<Response> show(int id) async {
    try {
      final orderItem = await OrderItemModel()
          .query()
          .join('orders', 'orders.order_num', '=', 'orderitems.order_num')
          .join('products', 'products.prod_id', '=', 'orderitems.prod_id')
          .where('order_item', '=', id.toString())
          .first();

      if (orderItem == null) {
        return Response.json({
          "message": "Order item not found",
          "code": 404,
        }, 404);
      }

      return Response.json({
        "message": "Order item found",
        "code": 200,
        "data": orderItem,
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

  // Method to update an existing order item
  Future<Response> update(Request request, int id) async {
    try {
      final orderItem = await OrderItemModel()
          .query()
          .where('order_item', '=', id.toString())
          .first();

      if (orderItem == null) {
        return Response.json({
          "message": "Order item not found",
          "code": 404,
        }, 404);
      }

      request.validate({
        'order_num': 'required|integer',
        'prod_id': 'required|string|max_length:5',
        'quantity': 'required|integer',
        'size': 'required|integer',
      });

      final orderNum = request.input('order_num');
      final prodId = request.input('prod_id');
      final quantity = request.input('quantity');
      final size = request.input('size');

      // Update order item
      await OrderItemModel()
          .query()
          .where('order_item', '=', id.toString())
          .update({
        "order_num": orderNum,
        "prod_id": prodId,
        "quantity": quantity,
        "size": size,
      });

      return Response.json({
        "message": "Order item updated successfully",
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

  // Method to edit an order item (retrieve data for editing)
  Future<Response> edit(int id) async {
    try {
      // Retrieve the order item by its ID
      final orderItem = await OrderItemModel()
          .query()
          .join('orders', 'orders.order_num', '=', 'orderitems.order_num')
          .join('products', 'products.prod_id', '=', 'orderitems.prod_id')
          .where('order_item', '=', id.toString())
          .first();

      if (orderItem == null) {
        return Response.json({
          "message": "Order item not found",
          "code": 404,
        }, 404);
      }

      // Return the order item details for editing
      return Response.json({
        "message": "Order item data fetched successfully",
        "code": 200,
        "data": {
          "order_item": orderItem["order_item"],
          "order_num": orderItem["order_num"],
          "prod_id": orderItem["prod_id"],
          "quantity": orderItem["quantity"],
          "size": orderItem["size"],
          "order_date": orderItem["order_date"],
          "product_name": orderItem["product_name"],
          "product_price": orderItem["product_price"],
        },
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

  // Method to delete an existing order item// Method to delete an order item
  Future<Response> destroy(int id) async {
    try {
      final orderItem = await OrderItemModel()
          .query()
          .where('order_item', '=', id.toString())
          .first();

      if (orderItem == null) {
        return Response.json({
          "message": "Order item not found",
          "code": 404,
        }, 404);
      }

      await OrderItemModel()
          .query()
          .where('order_item', '=', id.toString())
          .delete();

      return Response.json({
        'message': 'Order item deleted successfully',
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

final OrderItemController orderItemController = OrderItemController();
