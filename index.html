<?php
// cards.php
// Muestra tarjetas de paquetes (similar a Despegar) con datos básicos

// Configuración de la base de datos
$host = 'localhost';
$db   = 'turismoya';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    echo "Error de conexión: " . $e->getMessage();
    exit;
}

// Consulta los paquetes con su primera fecha disponible
$sql = "
SELECT
    p.id,
    p.nombre,
    p.descripcion,
    p.precio_base_pp,
    s.fecha_inicio,
    s.fecha_fin
FROM paquete p
JOIN paquete_schedule s ON p.id = s.paquete_id
WHERE s.id = (
    SELECT MIN(id) FROM paquete_schedule WHERE paquete_id = p.id
)
ORDER BY s.fecha_inicio ASC;
";
$stmt = $pdo->query($sql);
$paquetes = $stmt->fetchAll();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paquetes Turísticos</title>
    <link rel="stylesheet" href="style/main.css">
</head>
<body>
    <div class="cards-container">
        <?php foreach ($paquetes as $pkg): ?>
            <div class="card">
                <!-- Imagen placeholder; reemplazar con campo real si existe -->
                <div class="card-image">
                    <img src="images/paquete_<?php echo $pkg['id']; ?>.jpg" alt="<?php echo htmlspecialchars($pkg['nombre']); ?>">
                </div>
                <div class="card-content">
                    <h3 class="card-title"><?php echo htmlspecialchars($pkg['nombre']); ?></h3>
                    <p class="card-description"><?php echo nl2br(htmlspecialchars(substr($pkg['descripcion'], 0, 100))) . '...'; ?></p>
                    <p class="card-dates">Del <?php echo date('d/m/Y', strtotime($pkg['fecha_inicio'])); ?> al <?php echo date('d/m/Y', strtotime($pkg['fecha_fin'])); ?></p>
                    <p class="card-price">Desde $<?php echo number_format($pkg['precio_base_pp'], 2, ',', '.'); ?> por persona</p>
                    <a href="detalle_paquete.php?id=<?php echo $pkg['id']; ?>" class="card-link">Ver detalles</a>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
</body>
</html>
