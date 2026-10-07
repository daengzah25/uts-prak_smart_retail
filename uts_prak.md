Studi Kasus: Sistem Penjualan dan Pemesanan Ritel (SmartRetail POS App)
Sebuah perusahaan ritel perlengkapan kantor dan elektronik membutuhkan aplikasi kasir serta pemesanan
barang berbasis mobile. Aplikasi ini digunakan oleh kasir/staf toko untuk mengelola katalog produk,
memproses transaksi pemesanan dengan kustomisasi pengiriman, serta memantau rekapitulasi data
penjualan.

1. Halaman Autentikasi Pengguna (LoginScreen)
• Sediakan form login yang terdiri dari input Username dan Password menggunakan widget TextField.
• Kustomisasi kolom input dengan InputDecoration berupa ikon pendukung, petunjuk pengisian
(hintText), serta garis tepi melengkung saat aktif (focusedBorder).
• Kolom password wajib disamarkan menggunakan atribut obscureText: true.
• Terapkan validasi data statis (dummy check): jika username dan password benar (misal: admin dan
1234), arahkan ke layar utama; jika salah, tampilkan pesan peringatan menggunakan AlertDialog atau
SnackBar.

2. Halaman Utama & Dasbor Kasir (MainNavigationScreen)
• Gunakan navigasi bawah BottomNavigationBar dengan tiga menu utama: Katalog, Riwayat, dan
Informasi Toko.
• Sediakan menu samping Drawer yang menampilkan identitas kasir pada DrawerHeader serta navigasi
cepat menggunakan ListTile.
• Pada menu Katalog, gunakan navigasi tab atas (DefaultTabController, TabBar, dan TabBarView) yang
terbagi menjadi:
• Tab Produk: Menampilkan daftar katalog barang menggunakan ListView.builder dan ListTile. Setiap
item menampilkan gambar produk yang ditumpuk dengan lencana diskon/stok menggunakan
kombinasi Stack dan Positioned.
• Tab Ketentuan Promo: Menampilkan daftar syarat dan ketentuan voucher diskon yang dapat diperluas
atau diciutkan menggunakan ExpansionPanelList.
• Pada menu Riwayat: Tampilkan data transaksi kasir dalam format tabel matriks baris dan kolom
menggunakan DataTable (DataColumn dan DataRow).
• Pada menu Informasi Toko: Tampilkan profil toko dan kode lisensi resmi menggunakan SelectableText
agar teks dapat disalin oleh pengguna.

3. Halaman Formulir Pemesanan (OrderFormScreen)
• Layar ini terbuka saat tombol "Pesan" pada item katalog ditekan sambil membawa data produk yang
dipilih (passing data).
• Metode Pengiriman: Menggunakan RadioButtonGroup untuk memilih satu jenis kurir (Reguler, Kargo,
atau Instan).
• Layanan Ekstra: Menggunakan CheckboxGroup untuk opsi proteksi (Asuransi Pengiriman, Bubble
Wrap Ekstra, Packing Kayu).
• Jadwal Pengambilan: Sediakan pemilih tanggal penjemputan barang menggunakan showDatePicker
dan jam pengambilan menggunakan showTimePicker.
• Penyesuaian Tambahan:
• Penentuan persentase diskon member menggunakan Slider dengan batas minimum dan maksimum
yang jelas.
• Pengaktifan opsi dropship atau bungkus kado khusus menggunakan kontrol tombol Switch.

4. Alur Konfirmasi & Respon Balikan Transaksi
• Saat tombol "Proses Transaksi" ditekan, rincian biaya muncul dari bawah layar menggunakan
showModalBottomSheet.
• Di dalam lembar bawah (bottom sheet), sediakan tombol konfirmasi akhir yang memicu AlertDialog
persetujuan transaksi kasir.
• Saat dialog disetujui, tutup form dan kirim data status transaksi sukses (returning data) ke layar utama
menggunakan Navigator.pop.
• Layar utama menerima respon balikan tersebut dan menampilkan notifikasi pop-up bawah
menggunakan SnackBar.