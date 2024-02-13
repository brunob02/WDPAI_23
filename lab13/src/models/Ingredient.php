<?php

class Ingredient
{
  private $id;
  private $name;

  public function __construct()
  {
  }

  public static function createFromDatabase($id, $name)
  {
    $ingredient = new self();
    $ingredient->id = $id;
    $ingredient->name = $name;
    return $ingredient;
  }

  public function getId()
  {
    return $this->id;
  }
  public function getName()
  {
    return $this->name;
  }

}