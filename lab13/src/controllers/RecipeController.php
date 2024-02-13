<?php

require_once 'AppController.php';
require_once __DIR__ . '/../models/Recipe.php';
require_once __DIR__ . '/../repository/RecipeRepository.php';

class RecipeController extends AppController
{
  private $messages = [];
  const MAX_FILE_SIZE = 1024 * 1024;
  const SUPPORTED_TYPES = ['image/png', 'image/jpg'];
  const UPLOAD_DIRECTORY = '/../public/uploads/';

  private $recipeRepository;

  public function __construct()
  {
    parent::__construct();
    $this->recipeRepository = new RecipeRepository();
  }


  public function search()
  {
    // $recipes = $this->recipeRepository->getRecipes();
    $recipes = $this->recipeRepository->getRecipesWithIngredients();
    $this->render('search', ['recipes' => $recipes]);
  }

  public function star()
  {
    // $recipes = $this->recipeRepository->getRecipes();
    $recipes = $this->recipeRepository->getRecipesWithIngredientsById(1);
    $this->render('star', ['recipes' => $recipes]);
  }


  public function addRecipe()
  {

    if ($this->isPost() && is_uploaded_file($_FILES['file']['tmp_name']) && $this->validate($_FILES['file'])) {
      move_uploaded_file($_FILES['file']['tmp_name'], dirname(__DIR__) . self::UPLOAD_DIRECTORY . $_FILES['file']['name']);


      $recipe = new Recipe($_POST['name'], $_POST['description'], $_POST['duration'], $_POST['no_servings'], $_FILES['file']['name'], $_POST['preparation']);


      $this->recipeRepository->addRecipe($recipe);

      $this->addIngredientsToRecipe($recipe);

    }

    return $this->render('star', ['messages' => $this->messages]);
  }


  private function validate(array $file): bool
  {
    if ($file['size'] > self::MAX_FILE_SIZE) {
      $this->messages[] = 'File too large.';
      return false;
    }

    if (!isset($file['type']) && !in_array(($file['type']), self::SUPPORTED_TYPES)) {
      $this->messages[] = 'File type wrong.';
      return false;
    }

    return true;
  }

  private function addIngredientsToRecipe(Recipe $recipe)
  {
    for ($i = 1; $i <= 7; $i++) {
      $factor = 'factor' . $i;
      $unit = 'unit' . $i;
      $ingredient_name = 'ingredient_name' . $i;

      if (isset($_POST[$factor]) && isset($_POST[$unit]) && isset($_POST[$ingredient_name])) {

        $factor = $_POST[$factor];
        $unit = $_POST[$unit];
        $ingredient_name = $_POST[$ingredient_name];

        $recipeIngredient = new RecipeIngredient(
          $recipe->getId(),
          $ingredient_name,
          $factor,
          $unit
        );

        if (!$this->recipeRepository->addIngredient($recipeIngredient)) {
          $this->recipeRepository->deleteRecipe($recipe->getId());

          return $this->render('star', ['messages' => ['Wrong name of an unit or an ingredient.']]);
        }
      }

    }
    return $this->render('star', ['messages' => ['Successfully added recipe.']]);
  }
}