import 'package:vania/vania.dart';

class CreatePersonalAccessTokenTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('personal_access_tokens', () {
      id();
      tinyText('name');
      bigInt('tokenable_id');
      string('token');
      dateTime('last_used_at', nullable: true);
      dateTime('created_at', nullable: true);
      dateTime('deleted_at', nullable: true);

      index(ColumnIndex.unique,'token', ['token']);
    });
  }
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}