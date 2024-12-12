import 'package:vania/vania.dart';
import 'package:grocery/app/http/controllers/product_controller.dart';
import 'package:grocery/app/http/controllers/customer_controller.dart';
import 'package:grocery/app/http/controllers/order_controller.dart';
import 'package:grocery/app/http/controllers/orderitem_controller.dart';
import 'package:grocery/app/http/controllers/productnote_controller.dart';
import 'package:grocery/app/http/controllers/vendor_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix('api');

    Router.resource("/products", productController);
    Router.put("/products/{id}", productController.update);
    Router.delete("/products/{id}", productController.destroy);

    Router.resource("/customers", customerController);
    Router.put("/customers/{id}", customerController.update);
    Router.delete("/customers/{id}", customerController.destroy);

    Router.resource("/orders", orderController);
    Router.put("/orders/{id}", orderController.update);
    Router.delete("/orders/{id}", orderController.destroy);


    Router.resource("/orderitems", orderItemController);
    Router.put("/orderitems/{id}", orderItemController.update);
    Router.delete("/orderitems/{id}", orderItemController.destroy);

    Router.resource("/productnotes", productNotesController);
    Router.put("/productnotes/{id}", productNotesController.update);
    Router.delete("/productnotes/{id}", productNotesController.destroy);

    Router.resource("/vendors", vendorController);
    Router.put("/vendors/{id}", vendorController.update);
    Router.delete("/vendors/{id}", vendorController.destroy);
  }
}
