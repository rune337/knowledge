<?php
try {
    $pdo = new PDO("mysql:host=192.168.56.3;dbname=wiki_db;charset=utf8mb4", "wikiuser", "4869Niko!");
    echo "接続成功";
} catch (PDOException $e) {
    echo "接続失敗: " . $e->getMessage();
}

