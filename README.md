# 🧳 Portal de Venta de Paquetes Turísticos

Este proyecto es una **aplicación web con carrito de compras** desarrollada como parte de la **Olimpíada Nacional de Programación 2025**. Está orientada a facilitar la compra de **paquetes turísticos nacionales e internacionales** a través de Internet.

## 🌐 Descripción General

El sistema permite a los **clientes** explorar productos (paquetes turísticos, pasajes, estadías, alquileres, etc.), agregarlos al carrito de compras y confirmar pedidos. A su vez, los **empleados del área de ventas** pueden gestionar productos, consultar pedidos y realizar entregas.

Es una aplicación **cliente-servidor**, donde el frontend interactúa con el backend mediante APIs y toda la información se almacena en una base de datos relacional MySQL.

---

## 🧩 Funcionalidades

### 🧍 Cliente
- Consultar la lista de productos disponibles.
- Agregar productos al carrito de compras.
- Confirmar el pedido como "pendiente de entrega".
- Consultar pedidos pendientes.
- Modificar o eliminar pedidos pendientes.

### 👨‍💼 Personal de Ventas / Jefe de Ventas
- Cargar nuevos productos (código, descripción, precio).
- Consultar lista de productos.
- Ver pedidos pendientes.
- Marcar pedidos como entregados.
- Anular pedidos.
- Consultar estado de cuenta:
  - Facturas ordenadas por fecha.
  - Facturas ordenadas por cliente.

---

## 🧠 Roles del Equipo

### 👨‍🏫 Líder de Proyecto
- Coordina el trabajo entre los distintos miembros del equipo.
- Define los plazos y divide las tareas.
- Supervisa la calidad del código y el cumplimiento de los objetivos.

### 🧾 Analista Funcional
- Define los requerimientos del sistema.
- Traduce las necesidades del cliente en especificaciones técnicas.
- Se asegura de que la solución sea adecuada para el problema planteado.

### 🎨 Diseñador Gráfico
- Diseña la interfaz de usuario (UI).
- Define estilos, paleta de colores y experiencia visual.
- Colabora para que la app sea intuitiva y atractiva.

### 👨‍💻 Programadores (2)
- Implementan el backend (Node.js/Express) y el frontend (React).
- Conectan la base de datos y manejan las operaciones de lógica de negocio.
- Desarrollan la funcionalidad del carrito de compras, gestión de usuarios, productos y pedidos.

---

## 💼 Flujo General del Sistema

1. Cliente inicia sesión o se registra.
2. Consulta productos → agrega al carrito → confirma compra.
3. El sistema crea un pedido "pendiente".
4. Personal de ventas puede:
   - Ver ese pedido.
   - Marcarlo como entregado.
   - Anularlo si es necesario.
5. Cuando se entrega, el pedido se mueve al historial.
6. Se calcula el total y se registra la venta.

---

## ✉️ Notificaciones por Correo

Cuando un pedido es confirmado:
- Se envía un email al cliente.
- Se notifica automáticamente al sector de la empresa correspondiente, utilizando los datos de la tabla `emails_empresa`.

---

## ⚙️ Tecnologías Usadas

- **Frontend**: HTML, CSS, JavaScript (React)
- **Backend**: PHP
- **Base de Datos**: MySQL
- **Autenticación**:  roles por tipo de usuario
- **Correo Electrónico**: Nodemailer

---

## 🚀 Cómo Ejecutar el Proyecto

1. Cloná el repositorio:
   ```bash
   git clone https://github.com/palateo8967/TurismoYa.git
   cd TurismoYa
