<?
require_once __DIR__ . '/../models/RecipeIngredient.php';
class Recipe
{
    private $id;
    private $name;
    private $description;
    private $duration;
    private $noServings;
    private $image;
    private $preparation;
    private $timestamp;
    private $user_id;
    private $ingredients = [];

    public function __construct($name, $description, $duration, $noServings, $image, $preparation, $timestamp = null, $user_id = null, $id = null)
    {
        $this->name = $name;
        $this->description = $description;
        $this->duration = $duration;
        $this->noServings = $noServings;
        $this->image = $image;
        $this->preparation = $preparation;
        $this->timestamp = $timestamp;
        $this->user_id = $user_id;
        $this->id = $id;
    }

    // public function getIngredient($ingredientId, $factor, $unitId)
    // {
    //     $ingredient = new RecipeIngredient($this->getId(), $ingredientId, $factor, $unitId);
    //     $this->ingredients[] = $ingredient;
    //     return $ingredient;
    // }

    public function addIngredient(RecipeIngredient $ingredient)
    {
        $this->ingredients[] = $ingredient;
    }
    
    public function getIngredients()
    {
        return $this->ingredients;
    }

    public function getId()
    {
        return $this->id;
    }

    public function setId(int $id)
    {
        $this->id = $id;
    }
    public function getName()
    {
        return $this->name;
    }
    public function getDescription()
    {
        return $this->description;
    }
    public function getDuration()
    {
        return $this->duration;
    }
    public function getNoServings()
    {
        return $this->noServings;
    }

    public function getImage()
    {
        return $this->image;
    }
    public function getPreparation()
    {
        return $this->preparation;
    }
    public function getTimestamp()
    {
        return $this->timestamp;
    }
    public function getUser_id()
    {
        return $this->user_id;
    }
}