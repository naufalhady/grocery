# Grocery Management System

Grocery Management System adalah aplikasi manajemen toko kelontong yang dibangun menggunakan Dart dan framework Vania.

Untuk dokumentasi postman bisa dilihat di link berikut: https://s.id/Testing-Vania-API

## Fitur

- Manajemen Produk
- Manajemen Pelanggan
- Manajemen Pesanan
- Manajemen Item Pesanan
- Manajemen Catatan Produk
- Manajemen Vendor

## Struktur Proyek
.dart_tool/ .vscode/ bin/ lib/ app/ http/ controllers/ models/ providers/ config/ database/ migrations/ lang/ en/ route/ public/ storage/ logs/


## Instalasi

1. Clone repositori ini:

    ```sh
    git clone https://github.com/username/grocery-management-system.git
    cd grocery-management-system
    ```

2. Install dependencies:

    ```sh
    dart pub get
    ```

3. Konfigurasi database di `lib/config/database.dart`.

4. Jalankan migrasi database:

    ```sh
    dart lib/database/migrations/migrate.dart
    ```

## Menjalankan Aplikasi

1. Jalankan server:

    ```sh
    dart bin/server.dart
    ```

2. Akses API di `http://localhost:8080/api`.

## API Endpoints

- **Products**
  - `GET /api/products`
  - `POST /api/products`
  - `PUT /api/products/{id}`
  - `DELETE /api/products/{id}`

- **Customers**
  - `GET /api/customers`
  - `POST /api/customers`
  - `PUT /api/customers/{id}`
  - `DELETE /api/customers/{id}`

- **Orders**
  - `GET /api/orders`
  - `POST /api/orders`
  - `PUT /api/orders/{id}`
  - `DELETE /api/orders/{id}`

- **Order Items**
  - `GET /api/orderitems`
  - `POST /api/orderitems`
  - `PUT /api/orderitems/{id}`
  - `DELETE /api/orderitems/{id}`

- **Product Notes**
  - `GET /api/productnotes`
  - `POST /api/productnotes`
  - `PUT /api/productnotes/{id}`
  - `DELETE /api/productnotes/{id}`

- **Vendors**
  - `GET /api/vendors`
  - `POST /api/vendors`
  - `PUT /api/vendors/{id}`
  - `DELETE /api/vendors/{id}`

## Kontribusi

1. Fork repositori ini.
2. Buat branch fitur baru (`git checkout -b fitur-baru`).
3. Commit perubahan Anda (`git commit -am 'Tambah fitur baru'`).
4. Push ke branch (`git push origin fitur-baru`).
5. Buat Pull Request.

## Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE).
