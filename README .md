# Biometric-Card

Kegiatan proyek ini bertujuan untuk merancang dan mengembangkan chip berbasis FPGA yang diintegrasikan ke dalam sebuah perangkat berbentuk kartu. Kartu tersebut berfungsi sebagai chip biometrik yang menyimpan data biometric pribadi individu seperti foto yang dapat digunakan untuk verifikasi identitas pada paspor di bandara.

## Fitur

Pada aplikasi **Biometric-Card** ini terdapat dua peran utama yang memiliki akses autentikasi, yaitu **Read Card** dan **Write Card**. Masing-masing peran memiliki hak akses berbeda untuk mengoptimalkan keamanan dan efisiensi dalam pengelolaan data biometrik. Berikut adalah tiga level akses yang digunakan untuk mengklasifikasikan hak akses setiap fitur:

1. **All** (Dapat diakses oleh semua fungsi)
2. **Read Card** (Hanya Read Card dan Write Card yang dapat mengakses)
3. **Write Card** (Hanya Write Card yang dapat mengakses)

Berikut adalah daftar fitur dalam Biometric-Card beserta klasifikasi hak aksesnya:

### All

- Menampilkan informasi umum terkait Biometric-Card
- Menampilkan syarat dan ketentuan penggunaan
- Mencari informasi terkait proses verifikasi biometrik
- Melakukan **Register** untuk akses fitur lanjutan
- Melakukan **Login**

### Read Card

- **Melihat data biometrik** yang tersimpan, seperti foto dan sidik jari
- **Memverifikasi identitas** berdasarkan data biometrik yang ada
- Melihat riwayat verifikasi yang pernah dilakukan pada kartu
- **Mencari data biometrik** berdasarkan ID pengguna yang terkait

### Write Card

- **Menambah data biometrik** pengguna baru pada kartu
- **Mengedit data biometrik** pengguna yang telah terdaftar jika ada pembaruan atau perubahan identitas
- **Menghapus data biometrik** pengguna jika diperlukan atau jika kartu sudah tidak aktif
- **Mengelola log aktivitas** verifikasi dan perubahan data untuk pemantauan keamanan

## Requirements

### Requirements Biometric-Card

Untuk memastikan pengembangan dan implementasi **Biometric-Card** berjalan optimal, beberapa kebutuhan utama baik dari sisi perangkat keras maupun perangkat lunak diperlukan. Berikut adalah daftar requirements untuk proyek ini:

#### 1. **Perangkat Keras (Hardware)**

- **FPGA Chip**: Digunakan untuk memproses dan menyimpan data biometrik secara efisien, dengan dukungan reconfigurable hardware untuk fleksibilitas fitur.
- **Biometric Sensor**: Sensor seperti kamera mini atau pemindai sidik jari untuk menangkap data biometrik pengguna yang akan disimpan dan diverifikasi.
- **Secure Memory**: Memori penyimpanan data biometrik dengan enkripsi tingkat tinggi untuk memastikan keamanan data.
- **Card Reader Compatibility**: Kompatibel dengan perangkat pembaca kartu standar di bandara atau tempat verifikasi lainnya.
- **Power Supply**: Daya yang cukup untuk menjalankan chip dan sensor, dapat berupa baterai internal atau melalui card reader.

#### 2. **Perangkat Lunak (Software)**

- **Operating System (OS)**: Digunakan sebagai platform utama pada perangkat berbasis FPGA untuk memudahkan integrasi perangkat lunak dan data yang dibutuhkan. 


- **Encryption and Security Protocols**: Digunakan untuk enkripsi data biometrik yang tersimpan pada kartu, menjaga keamanan dan mencegah akses tidak sah.

- **Database**: Penyimpanan berbasis hashing untuk kata sandi, enkripsi data dalam penyimpanan (data-at-rest encryption), serta autentikasi multi-faktor untuk akses admin.

## Cara Kerja:
Biometric-Card terdiri dari tiga komponen utama yang bekerja sama untuk membaca, memproses, dan menyimpan data biometrik. 

1. **Operating System (OS)**: OS berfungsi sebagai platform yang mengelola dan memproses data biometrik. Dalam konteks pembuatan Biometric-Card, OS bertanggung jawab untuk berinteraksi dengan perangkat keras seperti sensor biometrik dan chip. OS akan menerima data yang dihasilkan oleh sensor, melakukan pemrosesan untuk mengenali dan mengidentifikasi data biometrik tersebut, serta menerapkan algoritma enkripsi untuk melindungi informasi sebelum disimpan atau dikirim.

2. **RTL (Register Transfer Level)**: RTL merupakan tahap di mana desain logika digital untuk chip biometrik didefinisikan. Pada tahap ini, berbagai fungsi logika yang diperlukan untuk pengolahan data biometrik diatur, termasuk pengumpulan dan pemrosesan data. RTL memastikan bahwa data biometrik dapat diolah secara efisien dan akurat sebelum dikirim ke board untuk penyimpanan atau transmisi.

3. **Board & RF (Radio Frequency)**: Komponen board dan RF berfungsi untuk menghubungkan semua elemen perangkat keras. Board ini berisi chip yang terintegrasi dengan komponen lain, termasuk modul RF untuk komunikasi nirkabel. Modul RF memungkinkan Biometric-Card untuk berkomunikasi dengan sistem eksternal, seperti sistem verifikasi, sehingga data biometrik dapat dengan cepat diakses dan diverifikasi saat diperlukan.

## OS:

## RTL:

## Board & RF:

