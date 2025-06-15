<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>

    <link rel="stylesheet" href="../style/css/styleNav.css">
    <link rel="stylesheet" href="../style/css/styleInicio.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

</head>

<body>

    <nav>

        <div class="nav_left">

            <img src="../style/img/logo.png" alt="TurismoYa Logo">

            <div class="nav_links">

                <a href="index.htl" class="prin">Inicio</a>
                <a href="paquetes.html">Paquetes</a>
                <a href="mis_paquetes.html">Mis Paquetes</a>
                <a href="contacto.html">Contacto</a>

            </div>

        </div>

        <div class="nav_right">

            <a href="carrito.html" class="cart">🛒</a>
            <a href="login.html" class="secondaryButton">Iniciar Sesión</a>
            <a href="registro.html" class="button">Registrarse</a>

        </div>

    </nav>

    <section class="presentacion">

        <div class="presentacion_content">

            <h1>Descubre el mundo con TurismoYa</h1>
            <p>Encuentra los mejores paquetes turísticos para tus próximas vacaciones</p>

        </div>

    </section>

    <section class="featuresSection">

        <div class="featuresContent">

            <div class="textContent">

                <h2>Vive experiencias únicas alrededor del mundo</h2>
                <p>En TurismoYa creamos paquetes turísticos completos para que solo te preocupes por disfrutar. Desde
                    vuelos y hoteles hasta excursiones y transfers, nos encargamos de cada detalle de tu viaje.</p>

                <div class="featuresGrid">

                    <div class="featureCard">

                        <i class="fa fa-plane"></i>
                        <p>Vuelos incluidos</p>

                    </div>

                    <div class="featureCard">

                        <i class="fa fa-hotel"></i>
                        <p>Hoteles seleccionados</p>

                    </div>

                    <div class="featureCard">

                        <i class="fa fa-shield-alt"></i>
                        <p>Transfers seguros</p>

                    </div>

                    <div class="featureCard">

                        <i class="fa fa-map-marker-alt"></i>
                        <p>Excursiones únicas</p>

                    </div>

                    <div class="featureCard">

                        <i class="fa fa-user"></i>
                        <p>Asesoría personalizada</p>

                    </div>

                    <div class="featureCard">

                        <i class="fa fa-exchange-alt"></i>
                        <p>Flexibilidad total</p>

                    </div>

                </div>

                <div class="buttons">

                    <button class="primaryBtn">Explorar paquetes</button>
                    <button class="secondaryBtn">Contactar asesor</button>

                </div>

            </div>

            <div class="imageGrid">

                <div class="column column1">

                    <div class="imageContainer small">

                        <img src="../style/img/inicio/imagen1.png" alt="Destino 1" />

                    </div>

                    <div class="imageContainer large">

                        <img src="../style/img/inicio/imagen2.png" alt="Destino 2" />

                    </div>

                </div>

                <div class="column column2">

                    <div class="imageContainer large">

                        <img src="../style/img/inicio/imagen3.png" alt="Destino 3" />

                    </div>

                    <div class="imageContainer small">

                        <img src="../style/img/inicio/imagen4.png" alt="Destino 4" />

                    </div>

                </div>

            </div>

    </section>

    <section class="destacadosSection">

        <div class="destacadosContent">

            <h2 class="sectionTitle">Paquetes destacados</h2>

            <div class="swiper destacadosSwiper">


                <div class="swiper-wrapper">

                    <?php

                include_once '../controller/conex.php';

                $sql = "SELECT 
                     p.nombre, p.descripcion, p.precio_base_pp,
                    p.ciudad, p.pais, p.rating,
                    i.url_imagen AS imagenUrl
                    FROM paquete_basico p
                    JOIN paquete_imagenes i 
                    ON p.id = i.paquete_id 
                    AND i.es_principal = TRUE
                    WHERE p.destacado = TRUE";

                    $result = $conex->query($sql);

                    if ($result && $result->num_rows) {

                        while ($row = $result->fetch_assoc()) {
                            
                        ?>

                    <div class="swiper-slide">

                        <div class="card">

                            <span class="badge">Destacado</span>

                            <div class="cardImgWrapper">

                                <img src="<?= htmlspecialchars($row['imagenUrl']) ?>"
                                    alt="<?= htmlspecialchars($row['nombre']) ?>" />

                            </div>

                            <div class="cardBody">

                                <div class="cardMeta">

                                    <span class="location">
                                        <?= htmlspecialchars($row['pais']) ?> – <?= htmlspecialchars($row['ciudad']) ?>
                                    </span>

                                    <span class="rating">★ <?= htmlspecialchars($row['rating']) ?></span>

                                </div>

                                <h3 class="cardTitle"><?= htmlspecialchars($row['nombre']) ?></h3>
                                <p class="cardDesc"><?= htmlspecialchars($row['descripcion']) ?></p>

                                <div class="cardFooter">

                                    <span class="price">
                                        $<?= htmlspecialchars($row['precio_base_pp']) ?> por persona
                                    </span>
                                    <button class="btnDetail">Ver detalle</button>

                                </div>

                            </div>

                        </div>

                    </div>

                    <?php
          }

        } else {

          echo '<p class="noResults">No hay paquetes destacados disponibles.</p>';

        }

        $conex->close();

      ?>
                </div>


                <div class="swiper-button-prev"></div>
                <div class="swiper-button-next"></div>

            </div>
        </div>
    </section>

    <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    <script src="../js/swiperInit.js"></script>


</body>

</html>