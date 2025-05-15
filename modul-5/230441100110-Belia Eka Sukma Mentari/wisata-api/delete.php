<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: DELETE, OPTIONS");
header("Content-Type: application/json");

include "koneksi.php";

// Tangkap input JSON
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['id'])) {
    $id = $data['id'];

    $sql = "DELETE FROM wisata WHERE id=$id";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Data berhasil dihapus"]);
    } else {
        echo json_encode(["error" => "Gagal menghapus: " . $conn->error]);
    }
} else {
    echo json_encode(["error" => "ID tidak ditemukan dalam input"]);
}

$conn->close();
?>
