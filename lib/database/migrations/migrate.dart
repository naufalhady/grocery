import 'dart:io';
import 'package:grocery/database/migrations/create_todos_table.dart';
import 'package:vania/vania.dart';
import 'create_customers_table.dart';
import 'create_vendors_table.dart';
import 'create_product_table.dart';
import 'create_productnotes_table.dart';
import 'create_orders_table.dart';
import 'create_orderitems_table.dart';
import 'create_personal_access_token_table.dart';
import 'create_users_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateTodosTable().up();
    await CreateUsersTable().up();
    await CreatePersonalAccessTokenTable().up();
    await CreateCustomersTable().up();
    await CreateVendorsTable().up();
    await CreateProductTable().up();
    await CreateProductNotesTable().up();
    await CreateOrdersTable().up();
    await CreateOrderitemsTable().up();
  }

  dropTables() async {
    await CreateTodosTable().down();
    await CreatePersonalAccessTokenTable().down();
    await CreateUsersTable().down();
    await CreateProductNotesTable().down();
    await CreateOrderitemsTable().down();
    await CreateProductTable().down();
    await CreateVendorsTable().down();
    await CreateOrdersTable().down();
    await CreateCustomersTable().down();
  }
}
