<?php

$conex = new mysqli("localhost", "root", "", "turismoya");


if ($conex->connect_error) {

    die("Conexión fallida: " . $conex->connect_error);
    
}