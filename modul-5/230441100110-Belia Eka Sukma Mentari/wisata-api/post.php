<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");


header("Content-Type: application/json");
include "koneksi.php";

// Ambil input dari body JSON
$data = json_decode(file_get_contents("php://input"), true);

// Pastikan semua data yang dibutuhkan ada, termasuk id
if (
    isset($data['id']) &&
    isset($data['nama']) &&
    isset($data['deskripsi']) &&
    isset($data['harga_tiket']) &&
    isset($data['jenis']) &&
    isset($data['lokasi'])
) {
    $id         = $data['id'];
    $nama       = $data['nama'];
    $deskripsi  = $data['deskripsi'];
    $harga      = $data['harga_tiket'];
    $jenis      = $data['jenis'];
    $lokasi     = $data['lokasi'];

    // Cek apakah id sudah ada
    $cek = $conn->prepare("SELECT id FROM wisata WHERE id = ?");
    $cek->bind_param("i", $id);
    $cek->execute();
    $cek->store_result();

    if ($cek->num_rows > 0) {
        echo json_encode(["error" => true, "message" => "ID sudah digunakan."]);
    } else {
        $stmt = $conn->prepare("INSERT INTO wisata (id, nama, deskripsi, harga_tiket, jenis, lokasi) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ississ", $id, $nama, $deskripsi, $harga, $jenis, $lokasi);

        if ($stmt->execute()) {
            echo json_encode([
                "message" => "Data berhasil ditambahkan secara manual dengan ID",
                "data" => [
                    "id" => $id,
                    "nama" => $nama,
                    "deskripsi" => $deskripsi,
                    "harga_tiket" => $harga,
                    "jenis" => $jenis,
                    "lokasi" => $lokasi
                ]
            ]);
        } else {
            echo json_encode(["error" => true, "message" => "Gagal: " . $stmt->error]);
        }
        $stmt->close();
    }

    $cek->close();
} else {
    echo json_encode(["error" => true, "message" => "Data JSON tidak lengkap."]);
}

$conn->close();
