CREATE DATABASE IF NOT EXISTS turismo_portal;
USE turismo_portal;

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    rol ENUM('cliente', 'ventas', 'admin') DEFAULT 'cliente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Correos por área (para notificaciones automáticas)
CREATE TABLE IF NOT EXISTS emails_empresa (
    id_email INT AUTO_INCREMENT PRIMARY KEY,
    area VARCHAR(50),
    id_usuario INT,
    email_destino VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (email_destino) REFERENCES usuarios(email)
);

-- Tabla de productos turísticos
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    codigo_producto VARCHAR(50) UNIQUE,
    descripcion TEXT,
    tipo ENUM('estadia', 'vuelo', 'alquiler_auto', 'paquete_completo') NOT NULL,
    precio DECIMAL(10,2),
    stock INT DEFAULT 0, -- Opcional si hay cupo limitado
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    numero_pedido VARCHAR(50) UNIQUE,
    estado ENUM('pendiente', 'entregado', 'anulado') DEFAULT 'pendiente',
    total DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Detalle de cada producto dentro de un pedido
CREATE TABLE IF NOT EXISTS pedido_detalle (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Historial de pedidos entregados
CREATE TABLE IF NOT EXISTS historial_pedidos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    fecha_entrega TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- Ventas (registro de transacciones cobradas)
CREATE TABLE IF NOT EXISTS ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    monto_total DECIMAL(10,2),
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('tarjeta', 'transferencia', 'efectivo', 'otro'),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- Facturación (estado de cuenta por cliente)
CREATE TABLE IF NOT EXISTS facturas (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_venta INT,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'pagado') DEFAULT 'pendiente',
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
);