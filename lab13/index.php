<?php

require 'Routing.php';

$path = trim($_SERVER['REQUEST_URI'], '/');
$path = parse_url($path, PHP_URL_PATH);

// Routing::get('', 'DefaultController');
Routing::get('index', 'DefaultController');
Routing::get('search', 'RecipeController');
Routing::get('star', 'RecipeController');
Routing::get('history', 'DefaultController');
Routing::post('addRecipe', 'RecipeController');

Routing::post('log', 'SecurityController');
Routing::post('reg', 'SecurityController');


Routing::get('user', 'ProfileController');
Routing::post('userInfo', 'ProfileController');

try {
  Routing::run($path);
} catch (InvalidArgumentException $e) {
  echo 'Error: ' . $e->getMessage();
} catch (Exception $e) {
  echo 'Unexpected error: ' . $e->getMessage();
}