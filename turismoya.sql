-- ------------------------------------------------
-- 0) BASE DE DATOS
-- ------------------------------------------------
CREATE DATABASE IF NOT EXISTS turismoya;
USE turismoya;

-- ------------------------------------------------
-- 1) TABLAS DE USUARIOS, CORREOS Y PEDIDOS (existentes)
-- ------------------------------------------------
-- Usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario    INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(50),
    apellido      VARCHAR(50),
    email         VARCHAR(100) UNIQUE,
    password      VARCHAR(255),
    rol           ENUM('cliente','ventas','admin') DEFAULT 'cliente',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Correos por área (notificaciones)
CREATE TABLE IF NOT EXISTS emails_empresa (
    id_email       INT AUTO_INCREMENT PRIMARY KEY,
    area           VARCHAR(50),
    id_usuario     INT,
    email_destino  VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    -- si querés notificar sólo a usuarios que ya existen,
    -- podés omitir esta FK; la pongo para ilustrar
    FOREIGN KEY (email_destino) REFERENCES usuarios(email)
);

-- Productos genéricos (vuelo, hotel, auto, paquete_completo…)
CREATE TABLE IF NOT EXISTS productos (
    id_producto     INT AUTO_INCREMENT PRIMARY KEY,
    codigo_producto VARCHAR(50) UNIQUE,
    descripcion     TEXT,
    tipo            ENUM('estadia','vuelo','alquiler_auto','paquete_completo') NOT NULL,
    precio          DECIMAL(10,2),
    stock           INT DEFAULT 0,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Pedidos y detalle
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido       INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario      INT,
    numero_pedido   VARCHAR(50) UNIQUE,
    estado          ENUM('pendiente','entregado','anulado') DEFAULT 'pendiente',
    total           DECIMAL(10,2),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE IF NOT EXISTS pedido_detalle (
    id_detalle      INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido       INT,
    id_producto     INT,
    cantidad        INT,
    precio_unitario DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Historial, ventas y facturas
CREATE TABLE IF NOT EXISTS historial_pedidos (
    id_historial    INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido       INT,
    fecha_entrega   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

CREATE TABLE IF NOT EXISTS ventas (
    id_venta        INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido       INT,
    monto_total     DECIMAL(10,2),
    fecha_venta     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metodo_pago     ENUM('tarjeta','transferencia','efectivo','otro'),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

CREATE TABLE IF NOT EXISTS facturas (
    id_factura      INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario      INT,
    id_venta        INT,
    fecha_emision   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado          ENUM('pendiente','pagado') DEFAULT 'pendiente',
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
);

-- ------------------------------------------------
-- 2) CATÁLOGOS MAESTROS PARA PAQUETES
-- ------------------------------------------------
CREATE TABLE IF NOT EXISTS destination (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  city           VARCHAR(100) NOT NULL,
  country        VARCHAR(100) NOT NULL,
  airport_code   CHAR(3)       NULL,
  UNIQUE(city, country)
);

CREATE TABLE IF NOT EXISTS airline (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS hotel (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(255) NOT NULL,
  stars          TINYINT        NOT NULL,
  address        VARCHAR(255)   NULL,
  city           VARCHAR(100)   NOT NULL,
  country        VARCHAR(100)   NOT NULL
);

CREATE TABLE IF NOT EXISTS transfer_type (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  code           VARCHAR(50)    NOT NULL,  
  description    VARCHAR(255)   NULL
);

CREATE TABLE IF NOT EXISTS car_company (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(255)   NOT NULL
);

CREATE TABLE IF NOT EXISTS excursion (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  name             VARCHAR(255)   NOT NULL,
  description      TEXT           NULL,
  duration_hours   DECIMAL(4,2)   NOT NULL
);

-- ------------------------------------------------
-- 3) PAQUETES Y SUS COMPONENTES
-- ------------------------------------------------
-- Tabla central de paquetes
CREATE TABLE IF NOT EXISTS paquete (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  nombre             VARCHAR(255)   NOT NULL,
  descripcion        TEXT           NULL,
  precio_base_pp     DECIMAL(10,2)  NOT NULL,
  personas_min       SMALLINT       NOT NULL,
  personas_max       SMALLINT       NOT NULL,
  creado_en          TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- Fechas y duraciones disponibles
CREATE TABLE IF NOT EXISTS paquete_schedule (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  paquete_id         INT             NOT NULL,
  fecha_inicio       DATE            NOT NULL,
  fecha_fin          DATE            NOT NULL,
  dias               SMALLINT        NOT NULL,
  noches             SMALLINT        NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquete(id) ON DELETE CASCADE
);

-- Vuelos asociados al paquete
CREATE TABLE IF NOT EXISTS paquete_flight (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  paquete_id         INT             NOT NULL,
  airline_id         INT             NOT NULL,
  flight_number      VARCHAR(20)     NULL,
  origin_id          INT             NOT NULL,
  destination_id     INT             NOT NULL,
  stops              TINYINT         DEFAULT 0,
  luggage_included   BOOLEAN         DEFAULT TRUE,
  travel_class       ENUM('economy','premium','business','first') NOT NULL,
  price_extra_pp     DECIMAL(10,2)   NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquete(id)       ON DELETE CASCADE,
  FOREIGN KEY (airline_id) REFERENCES airline(id),
  FOREIGN KEY (origin_id) REFERENCES destination(id),
  FOREIGN KEY (destination_id) REFERENCES destination(id)
);

-- Hotel
CREATE TABLE IF NOT EXISTS paquete_hotel (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  paquete_id         INT             NOT NULL,
  hotel_id           INT             NOT NULL,
  habitaciones       SMALLINT        NOT NULL,
  ocupacion_max      SMALLINT        NOT NULL,
  desayuno_incluido  BOOLEAN         DEFAULT TRUE,
  tipo_habitacion    VARCHAR(100)    NOT NULL,
  price_extra_pp     DECIMAL(10,2)   NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquete(id)       ON DELETE CASCADE,
  FOREIGN KEY (hotel_id) REFERENCES hotel(id)
);

-- Traslados
CREATE TABLE IF NOT EXISTS paquete_transfer (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  paquete_id         INT             NOT NULL,
  transfer_type_id   INT             NOT NULL,
  quantity           SMALLINT        NOT NULL DEFAULT 1,
  price_extra_pp     DECIMAL(10,2)   NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquete(id)     ON DELETE CASCADE,
  FOREIGN KEY (transfer_type_id) REFERENCES transfer_type(id)
);

-- Alquiler de autos
CREATE TABLE IF NOT EXISTS paquete_car_rental (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  paquete_id         INT             NOT NULL,
  company_id         INT             NOT NULL,
  car_model          VARCHAR(255)    NOT NULL,
  days_included      SMALLINT        NOT NULL,
  price_per_day_pp   DECIMAL(10,2)   NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquete(id)     ON DELETE CASCADE,
  FOREIGN KEY (company_id) REFERENCES car_company(id)
);

-- Excursiones
CREATE TABLE IF NOT EXISTS paquete_excursion (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  paquete_id         INT             NOT NULL,
  excursion_id       INT             NOT NULL,
  quantity           SMALLINT        NOT NULL DEFAULT 1,
  price_extra_pp     DECIMAL(10,2)   NOT NULL,
  FOREIGN KEY (paquete_id) REFERENCES paquete(id)     ON DELETE CASCADE,
  FOREIGN KEY (excursion_id) REFERENCES excursion(id)
);

-- ------------------------------------------------
-- 4) ÍNDICES RECOMENDADOS
-- ------------------------------------------------
CREATE INDEX idx_schedule_paquete ON paquete_schedule(paquete_id);
CREATE INDEX idx_flight_paquete  ON paquete_flight(paquete_id);
CREATE INDEX idx_hotel_paquete   ON paquete_hotel(paquete_id);
CREATE INDEX idx_transfer_paquete ON paquete_transfer(paquete_id);
CREATE INDEX idx_car_paquete     ON paquete_car_rental(paquete_id);
CREATE INDEX idx_excursion_paquete ON paquete_excursion(paquete_id);
