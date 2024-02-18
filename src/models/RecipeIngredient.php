<?php

class RecipeIngredient
{
  private $id;
  private $recipeId;
  private $ingredient;
  private $factor;
  private $unit;

  public function __construct($recipeId, $ingredient, $factor, $unit, $id = null)
  {
    $this->recipeId = $recipeId;
    $this->ingredient = $ingredient;
    $this->factor = $factor;
    $this->unit = $unit;
    $this->id = $id;
  }

  public function getId()
  {
    return $this->id;
  }
  public function getRecipeId()
  {
    return $this->recipeId;
  }
  public function getIngredient()
  {
    return $this->ingredient;
  }
  public function getFactor()
  {
    return $this->factor;
  }
  public function getUnit()
  {
    return $this->unit;
  }

}