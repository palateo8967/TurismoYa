CREATE DATABASE IF NOT EXISTS turismoya CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE turismoya;

-- Tabla de usuarios
CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol ENUM('cliente', 'vendedor', 'jefe') NOT NULL DEFAULT 'cliente',
    telefono VARCHAR(20),
    direccion TEXT
);

-- Tabla principal de paquetes (productos)
CREATE TABLE paquete_basico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_base_pp DECIMAL(10,2) NOT NULL,
    personas_min INT DEFAULT 1,
    personas_max INT DEFAULT 10,
    rating DECIMAL(2,1) DEFAULT 4.5,
    ciudad VARCHAR(100),
    pais VARCHAR(100)
);

-- Tabla de carritos
CREATE TABLE carrito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('activo', 'comprado') DEFAULT 'activo',
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE
);

-- Detalles del carrito (para paquetes)
CREATE TABLE carrito_detalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    carrito_id INT NOT NULL,
    paquete_id INT NOT NULL,
    cantidad INT DEFAULT 1,
    fecha_seleccion DATE,
    FOREIGN KEY (carrito_id) REFERENCES carrito(id) ON DELETE CASCADE,
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id)
);

-- Pedidos
CREATE TABLE pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    carrito_id INT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'aceptado', 'rechazado', 'cancelado', 'entregado') DEFAULT 'pendiente',
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (carrito_id) REFERENCES carrito(id)
);

-- Detalle del pedido (para paquetes)
CREATE TABLE pedido_detalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    paquete_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE,
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id)
);

-- Facturas
CREATE TABLE factura (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    pedido_id INT NOT NULL,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento DATE,
    total DECIMAL(10,2) NOT NULL,
    estado_pago ENUM('pendiente', 'pagado', 'vencido') DEFAULT 'pendiente',
    numero_factura VARCHAR(50) UNIQUE,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_id) REFERENCES pedido(id)
);

-- Correos de sectores de empresa
CREATE TABLE sector_mail (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sector VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- Tabla de ventas
CREATE TABLE venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factura_id INT NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    transaccion_id VARCHAR(100),
    FOREIGN KEY (factura_id) REFERENCES factura(id)
);

-- Tabla de auditoría para pedidos
CREATE TABLE auditoria_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    usuario_id INT NOT NULL,
    accion ENUM('creacion', 'modificacion', 'cancelacion', 'aceptacion', 'rechazo') NOT NULL,
    fecha_accion DATETIME DEFAULT CURRENT_TIMESTAMP,
    detalles TEXT,
    FOREIGN KEY (pedido_id) REFERENCES pedido(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- Tablas relacionadas con paquetes (sin cambios)
CREATE TABLE paquete_imagenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paquete_id INT NOT NULL,
    url_imagen TEXT NOT NULL,
    es_principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id) ON DELETE CASCADE
);

CREATE TABLE paquete_schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paquete_id INT NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    dias INT,
    noches INT,
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id) ON DELETE CASCADE
);

CREATE TABLE airline (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE destination (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE paquete_flight (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paquete_id INT NOT NULL,
    airline_id INT,
    origin_id INT,
    destination_id INT,
    flight_number VARCHAR(20),  
    stops INT,
    luggage_included BOOLEAN,
    travel_class ENUM('economy', 'business', 'first'),
    price_extra_pp DECIMAL(10,2),
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id) ON DELETE CASCADE,
    FOREIGN KEY (airline_id) REFERENCES airline(id),
    FOREIGN KEY (origin_id) REFERENCES destination(id),
    FOREIGN KEY (destination_id) REFERENCES destination(id)
);

CREATE TABLE hotel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    stars INT
);

CREATE TABLE paquete_hotel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paquete_id INT NOT NULL,
    hotel_id INT NOT NULL,
    habitaciones INT,
    ocupacion_max INT,
    desayuno_incluido BOOLEAN,
    tipo_habitacion VARCHAR(50),
    price_extra_pp DECIMAL(10,2),
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotel(id)
);

CREATE TABLE transfer_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20),
    description VARCHAR(100)
);

CREATE TABLE paquete_transfer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paquete_id INT NOT NULL,
    transfer_type_id INT NOT NULL,
    quantity INT,
    price_extra_pp DECIMAL(10,2),
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id) ON DELETE CASCADE,
    FOREIGN KEY (transfer_type_id) REFERENCES transfer_type(id)
);

CREATE TABLE car_company (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE paquete_car_rental (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paquete_id INT NOT NULL,
    company_id INT NOT NULL,
    car_model VARCHAR(100),
    days_included INT,
    price_per_day_pp DECIMAL(10,2),
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES car_company(id)
);

CREATE TABLE excursion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    duration_hours INT
);

CREATE TABLE paquete_excursion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paquete_id INT NOT NULL,
    excursion_id INT NOT NULL,
    quantity INT,
    price_extra_pp DECIMAL(10,2),
    FOREIGN KEY (paquete_id) REFERENCES paquete_basico(id) ON DELETE CASCADE,
    FOREIGN KEY (excursion_id) REFERENCES excursion(id)
);

-- Insertar sectores para notificaciones
INSERT INTO sector_mail (sector, email) VALUES
('ventas', 'ventas@empresa.com'),
('soporte', 'soporte@empresa.com'),
('administracion', 'admin@empresa.com');