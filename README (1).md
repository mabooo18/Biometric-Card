# BNMO BOXD

BNMO BOXD merupakan aplikasi web review film yang monolitik dan dibuat dengan menggunakan PHP untuk server-side dan vanila HTML, CSS, dan JS untuk client-side.
Aplikasi ini dibuat untuk memenuhi Tugas Besar 1 mata kuliah Pengembangan Aplikasi Berbasis Web IF3110 2023/2024.
Aplikasi ini menggunakan docker untuk memudahkan penggunaan dan environment yang sama.
Aplikasi ini menggunakan MySQL sebagai RDBMS dari database.

## Fitur

Pada aplikasi ini terdapat dua role yang terautentikasi yaitu user dan admin.
Untuk mengakses aplikasi sebagai user, pengguna biasa harus melakukan register terlebih dahulu. Jika sudah memiliki akun maka pengguna dapat langsung login ke aplikasi.
Ada tiga level yang akan digunakan untuk mengklasifikasikan hak akses dari fitur, yaitu:

1. All (Semua dapat mengakses)
2. User (Hanya User dan Admin yang dapat mengakses)
3. Admin (Hanya admin yang dapat mengkases)

Berikut adalah fitur-fitur yang ada beserta klasifikasi hak aksesnya:

All

- Menampilkan rekomendasi film
- Melihat detail film (judul, poster, deskripsi, review, genre, direktor, dan trailer)
- Mencari film berdasarkan nama/direktor
- Memfilter film berdasarkan genre/rating
- Mengurutkan film berdasarkan judul/rating/tanggal rilis
- Melakukan Register
- Melakukan Login

User

- Mengubah detail akun (profil picture, first name, last name, email, username)
- Menghapus akun
- Menambahkan review pada film
- Mengedit review pada film
- Menghapus review pada film
- Melihat daftar review yang pernah diberikan

Admin

- Menambahkan film - Admin
- Mengedit film - Admin

## Requirements

1. Docker
2. PHP 8 or later

## Cara Instalasi

1. Install requirements

   - Untuk windows and mac user

     - Download docker desktop [here](https://www.docker.com/products/docker-desktop/)

   - Untuk UNIX like user jalankan command di bawah

   ```sh
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
   ```

   Untuk memverifikasi apakah docker telah terinstall, maka coba jalankan `docker run hello-world`.

2. Clone repository
3. Secara default, aplikasi ini menggunakan port `8080, 8002` dan jika pada komputer anda telah menggunakan port tersebut, maka ubahlah port pada file `docker-compose.yml`.

## Cara Menjalankan Server

1. Ubah directory ke root dari repo ini (sejajar dengan file README.md)
2. Buat file `.env`
3. Isi file `.env` dengan
   ```env
   MYSQL_USER=bnmo
   MYSQL_PASSWORD=bnmo
   MYSQL_ROOT_PASSWORD=root
   MYSQL_DATABASE=bnmoboxd
   MYSQL_PORT=3306
   MYSQL_HOST=bnmoboxd-db
   REST_API_URL=http://host.docker.internal:3000
   SOAP_BASE_URL=http://host.docker.internal:9000
   REST_API_KEY=rest
   PHP_API_KEY=php
   SOAP_API_KEY=soap
   ```
4. Buka terminal lalu jalankan `docker compose up -d`
5. Buka browser dan buka `localhost:8080`

## Screenshots

### Tampilan Desktop

![image](documentations/desktop-view/image1.png)
![image](documentations/desktop-view/image2.png)
![image](documentations/desktop-view/image3.png)
![image](documentations/desktop-view/image4.png)
![image](documentations/desktop-view/image5.png)
![image](documentations/desktop-view/image6.png)
![image](documentations/desktop-view/image7.png)
![image](documentations/desktop-view/image8.png)
![image](documentations/desktop-view/image9.png)
![image](documentations/desktop-view/image10.png)

### Tampilan Mobile

![image](documentations/mobile-view/image1.png)
![image](documentations/mobile-view/image2.png)
![image](documentations/mobile-view/image3.png)
![image](documentations/mobile-view/image4.png)
![image](documentations/mobile-view/image5.png)
![image](documentations/mobile-view/image6.png)
![image](documentations/mobile-view/image7.png)
![image](documentations/mobile-view/image8.png)
![image](documentations/mobile-view/image9.png)
![image](documentations/mobile-view/image10.png)

### Google Lighthouse

![image](documentations/lighthouse/image1.png)
![image](documentations/lighthouse/image2.png)
![image](documentations/lighthouse/image3.png)
![image](documentations/lighthouse/image4.png)
![image](documentations/lighthouse/image5.png)
![image](documentations/lighthouse/image6.png)
![image](documentations/lighthouse/image7.png)
![image](documentations/lighthouse/image8.png)
![image](documentations/lighthouse/image9.png)
![image](documentations/lighthouse/image10.png)

## Pembagian Tugas

### Server Side

| 13521044                                 | 13521047    | 13521107                |
| ---------------------------------------- | ----------- | ----------------------- |
| Set Up Architecture                      | Review CRUD | Film CRUD               |
| Set Up Database                          | DB Seeding  | DB Seeding              |
| Set Up Repository Base Functions         |             | Video Upload            |
| Middlewares                              |             | Debugging auth services |
| Exceptions and Exception Handling        |             | Debugging film services |
| Search Films (Filter & Pagination)       |             |                         |
| Auth Services (Login, logout & Register) |             |                         |
| Form Validation                          |             |                         |
| Profile CRUD                             |             |                         |
| Review CRUD                              |             |                         |
| Migrations                               |             |                         |
| Utilities                                |             |                         |

### Client Side

| 13521044                                  | 13521047                    | 13521107                  |
| ----------------------------------------- | --------------------------- | ------------------------- |
| Home Page                                 | Reviews Page                | Film Details Page         |
| Navbar                                    | Edit Reviews Page           | Edit Film Page            |
| Base Layout                               | Delete Review Functionality | Add Film Page             |
| Films Page (including filter, pagination) | Google Lighthouse           | Delete Film Functionality |
| Edit Profile Page                         |                             |                           |
| Login Page                                |                             |                           |
| Register Page                             |                             |                           |
| Show Trailer Modal                        |                             |                           |
| Modal Functionalities                     |                             |                           |
| Form Submitter                            |                             |                           |
| Exception Page                            |                             |                           |

## Bonus

1. All Responsive Page
2. Google Lighthouse
3. Docker

## Authors

|            Nama            |   NIM    |
| :------------------------: | :------: |
| Rachel Gabriela Chen       | 13521044 |
| Muhammad Equilibrie Fajria | 13521047 |
| Jericho Russel Sebastian   | 13521107 |


# What's New?

## Fitur

User

- Melihat daftar curator
- Mengirim permintaan subscribe curator
- Melihat review curator yang telah disubcribe

## Screenshots

### Tampilan Desktop

![image](documentations/desktop-view/image11.png)
![image](documentations/desktop-view/image12.png)
![image](documentations/desktop-view/image13.png)
![image](documentations/desktop-view/image14.png)
![image](documentations/desktop-view/image15.png)

### Tampilan Mobile

![image](documentations/mobile-view/image11.png)
![image](documentations/mobile-view/image12.png)
![image](documentations/mobile-view/image13.png)
![image](documentations/mobile-view/image14.png)
![image](documentations/mobile-view/image15.png)

## Pembagian Tugas

### Server Side

| 13521044                                  | 13521047          | 13521107 |
| ----------------------------------------- | ----------------- | -------- |
| Integrated Subscription with REST         | Subscription CRUD |          |
| Integrated Subscription with SOAP         |                   |          |

### Client Side

| 13521044                          | 13521047                   | 13521107 |
| --------------------------------- | -------------------------- | -------- |
| Curators Page integration         | Curators Page              |          |
| Curators Page pagination          | View Curator's Review Page |          |
| Curator's Detail integration      | Subscribe Functionality    |          |
| Responsive curators page          |                            |          |

## OWASP
This application is safe from:
**1. SQL Injection**
SQL Injection occurs when _attacker_ injects mallicious code into input forms that can execute unwanted SQL commands. This attack usually occurs when the appplication fails to sanitize the input and doesn't prepare the statements before exxecuting SQL query.
Example of a vulnerable code:
```
<?php
// Vulnerable code
$user_input = $_GET['username'];
$sql_query = "SELECT * FROM users WHERE username = '" . $user_input . "'";
$result = mysqli_query($conn, $sql_query);
?>
```
The problem with the code above is that, it straight up takes the 'username' from the query params without sanitizing it or preparing it as params. This will cause the input to be intepreted as SQL query. Attackers can exploit this by inputting params like:
`admin' or 1=1 --`

The `1=1` makes the statement true regardless or the other conditions and the `--` comments out the rest of the query.

This attack is prevented in our app by using:
1. Input Sanitazion
![image](documentations/owasp/input-sanitazion.png)
2. Input Validation
3. Parameterized Statements
![image](documentations/owasp/parameterized.png)
![image](documentations/owasp/sqli.png)

**2. File Upload Vulnerability**
File upload vulnerability refers to a security issue in web applications that allows an attacker to upload and execute malicious files. This type of vulnerability is particularly dangerous because it can lead to a range of attacks, including remote code execution, unauthorized access, and various forms of malware injection. Here are the key aspects of file upload vulnerabilities. 

PHP is often vulnerable to this attack due to improper use of file_get_contents()

This attack is prevented in our app by using:
1. No usage of file_get_contents() to load files, instead we use html's `src`
2. Filetype checking
![image](documentations/owasp/filetype-checking.png)
