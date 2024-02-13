<?php

require_once 'Repository.php';
require_once __DIR__ . '/../models/Recipe.php';
require_once __DIR__ . '/../models/RecipeIngredient.php';

class RecipeRepository extends Repository
{

  public function getRecipe(string $id): ?Recipe
  {
    $stmt = $this->database->getConnection()->prepare('
            SELECT * FROM "users" WHERE id = :id;');
    $stmt->bindParam(':id', $id, PDO::PARAM_INT);
    $stmt->execute();

    $recipe = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($recipe == false) {
      return null;
    }

    return new Recipe(
      $recipe['name'],
      $recipe['description'],
      $recipe['duration'],
      $recipe['noServings'],
      $recipe['image'],
      $recipe['preparation'],
      $recipe['timestamp'],
      $this->setUserName($recipe['user_id']),
      $recipe['id']
    );
  }

  public function getRecipes(): array
  {
    $result = [];

    $stmt = $this->database->getConnection()->prepare('
            SELECT * FROM "recipes";');
    $stmt->execute();

    $recipes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($recipes as $recipe) {
      $result[] = new Recipe(
        $recipe['name'],
        $recipe['description'],
        $recipe['duration'],
        $recipe['no_servings'],
        $recipe['image'],
        $recipe['preparation'],
        $recipe['timestamp'],
        $this->setUserName($recipe['user_id']),
        $recipe['id']
      );
    }

    return $result;
  }


  public function getRecipesWithIngredients(): array
  {
    $result = [];

    $stmt = $this->database->getConnection()->prepare('
          SELECT * FROM "recipe_details";
      ');

    $stmt->execute();
    $recipesData = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($recipesData as $recipeData) {
      $recipeId = $recipeData['id'];
      if (!isset($result[$recipeId])) {
        $result[$recipeId] = new Recipe(
          $recipeData['name'],
          $recipeData['description'],
          $recipeData['duration'],
          $recipeData['no_servings'],
          $recipeData['image'],
          $recipeData['preparation'],
          $recipeData['timestamp'],
          $recipeData['user_email'],
          $recipeId
        );
      }

      if (!empty($recipeData['ingredient_name'])) {
        $ingredient = new RecipeIngredient(
          $recipeData['id'],
          $recipeData['ingredient_name'],
          $recipeData['factor'],
          $recipeData['unit_abbreviation']
        );
        $result[$recipeId]->addIngredient($ingredient);
        // $result[$recipeId]->addIngredientNames($recipeData['ingredient_name']);
      }
    }

    return array_values($result);
  }


  public function addRecipe(Recipe $recipe): void
  {
    echo 'E_';
    $date = new DateTime();

    $stmt = $this->database->getConnection()->prepare("
    INSERT INTO \"recipes\" (user_id, name, description, duration, no_servings, timestamp, preparation, image)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING id;
");

    // $user_id = 1;
    $user_id = $_COOKIE['id'];


    $stmt->execute([
      $user_id,
      $recipe->getName(),
      $recipe->getDescription(),
      $recipe->getDuration(),
      $recipe->getNoServings(),
      $date->format('Y-m-d H:i'),
      $recipe->getPreparation(),
      $recipe->getImage()
    ]);

    $recipe->setId($stmt->fetchColumn());

  }

  public function addIngredient(RecipeIngredient $ingredient): bool
  {

    $stmtIngredient = $this->database->getConnection()->prepare('
        SELECT id FROM "ingredients" WHERE name = ?;
    ');

    $stmtIngredient->execute([$ingredient->getIngredient()]);

    $idIngredient = $stmtIngredient->fetchColumn();

    if ($idIngredient === false) {
      return false;
    }

    $stmtUnit = $this->database->getConnection()->prepare('
        SELECT id FROM "units" WHERE unit = ? OR abbreviation = ?;
    ');

    $stmtUnit->execute([$ingredient->getUnit(), $ingredient->getUnit()]);

    $unitId = $stmtUnit->fetchColumn();

    if ($unitId === false) {
      return false;
    }

    $stmt = $this->database->getConnection()->prepare('
        INSERT INTO "recipes_ingredients" (id_recipe, id_ingredient, factor, unit_id)
        VALUES (?, ?, ?, ?);
    ');

    $stmt->execute([
      $ingredient->getRecipeId(),
      $idIngredient,
      $ingredient->getFactor(),
      $unitId,
    ]);

    return true;
  }

  public function setUserName(int $id): string
  {
    $stmt = $this->database->getConnection()->prepare('
            SELECT u.email as user_email
            FROM recipes r
            JOIN users u ON r.user_id = u.id
            WHERE r.id = :id;
        ');

    $stmt->bindParam(':id', $id, PDO::PARAM_INT);
    $stmt->execute();

    $userData = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($userData === false) {
      return null;
    }

    return $userData['user_email'];

  }

  public function getRecipeByName(string $searchingString)
  {
    $searchingString = '%' . strtolower($searchingString) . '%';
    $stmt = $this->database->getConnection()->prepare('
            SELECT * FROM "recipe_details" WHERE LOWER(name) LIKE :searching
        ');

    $stmt->bindParam(':searching', $searchingString, PDO::PARAM_STR);
    $stmt->execute();

    return $stmt->fetchAll(PDO::FETCH_ASSOC);

  }

  public function deleteRecipe(string $id): void
  {
    $deleteStmt = $this->database->getConnection()->prepare("
    DELETE FROM \"recipes\" WHERE id = ?;
");
    $deleteStmt->execute([$id]);

    $deleteStmt = $this->database->getConnection()->prepare("
    DELETE FROM \"recipes_ingredients\" WHERE id_recipe = ?;
");
    $deleteStmt->execute([$id]);
  }

  public function getRecipesWithIngredientsById($id): array
  {
    $result = [];

    $stmt = $this->database->getConnection()->prepare('
          SELECT * FROM "recipe_details" where user_id = :userId;
      ');

    $stmt->bindParam(':userId', $id, PDO::PARAM_INT);
    $stmt->execute();
    $recipesData = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($recipesData as $recipeData) {
      $recipeId = $recipeData['id'];
      if (!isset($result[$recipeId])) {
        $result[$recipeId] = new Recipe(
          $recipeData['name'],
          $recipeData['description'],
          $recipeData['duration'],
          $recipeData['no_servings'],
          $recipeData['image'],
          $recipeData['preparation'],
          $recipeData['timestamp'],
          $recipeData['user_email'],
          $recipeId
        );
      }
      if (!empty($recipeData['ingredient_name'])) {
        $ingredient = new RecipeIngredient(
          $recipeData['id'],
          $recipeData['ingredient_name'],
          $recipeData['factor'],
          $recipeData['unit_abbreviation']
        );
        $result[$recipeId]->addIngredient($ingredient);
        // $result[$recipeId]->addIngredientNames($recipeData['ingredient_name']);
      }
    }

    return array_values($result);
  }

}