<?php

require_once 'src/controllers/DefaultController.php';
require_once 'src/controllers/SecurityController.php';
require_once 'src/controllers/RecipeController.php';
require_once 'src/controllers/ProfileController.php';

class Routing
{
  public static $routes;

  public static function get($url, $view)
  {
    self::$routes[$url] = $view;
  }

  public static function post($url, $view)
  {
    self::$routes[$url] = $view;
  }

  public static function run($url)
  {
    $action = explode("/", $url)[0];

    if (!array_key_exists($action, self::$routes)) {
      throw new InvalidArgumentException("Invalid URL. Please try again.");
    }

    $controller = self::$routes[$action];

    $allowedWithoutCookie = ['log', 'reg', 'index'];

    if (!isset($_COOKIE['id']) && !in_array($action, $allowedWithoutCookie)) {
      header("Location: /log");
      exit();
    }

    $object = new $controller;
    $action = $action ?: 'index';
    $object->$action();
  }
}