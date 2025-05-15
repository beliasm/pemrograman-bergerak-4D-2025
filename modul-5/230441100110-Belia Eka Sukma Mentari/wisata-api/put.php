<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: PUT, OPTIONS");

header("Content-Type: application/json");

include 'koneksi.php';

$data = json_decode(file_get_contents("php://input"), true);

if (
    isset($data['id']) &&
    isset($data['nama']) &&
    isset($data['deskripsi']) &&
    isset($data['harga_tiket']) &&
    isset($data['jenis']) &&
    isset($data['lokasi'])
) {
    $id = $data['id'];
    $nama = $data['nama'];
    $deskripsi = $data['deskripsi'];
    $harga_tiket = $data['harga_tiket'];
    $jenis = $data['jenis'];
    $lokasi = $data['lokasi'];

    $sql = "UPDATE wisata SET 
        nama='$nama',
        deskripsi='$deskripsi',
        harga_tiket='$harga_tiket',
        jenis='$jenis',
        lokasi='$lokasi'
        WHERE id=$id";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Data berhasil diupdate"]);
    } else {
        echo json_encode(["error" => "Gagal update: " . $conn->error]);
    }
} else {
    echo json_encode(["error" => "Data tidak lengkap"]);
}
?>
