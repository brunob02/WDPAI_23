<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="X-UA-Compatible" content="ie=edge" />
  <title>Your recipes</title>
  <link rel="icon" href="public/img/icon.svg">
  <link rel="stylesheet" href="public/css/style.css" />
  <link rel="stylesheet" href="public/css/recipe.css" />
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300&display=swap" rel="stylesheet" />
  <style>
    form {
      all: revert;
    }
  </style>
  <script>
    function toggleForm() {
      var form = document.querySelector('.recipe-form-class');
      var button = document.querySelector('.toggle-form-button');
      if (form.style.display === "none") {
        form.style.display = "block";
        button.textContent = "HIDE RECIPE";
      } else {
        form.style.display = "none";
        button.textContent = "ADD RECIPE";
      }
    }
  </script>

</head>

<body onload="updateDateTime();">
  <header id="container">
    <div class="top-bar">
      <img src="public/img/fork.png" alt="fork" />
      <img src="public/img/chef.png" alt="chef" />
      <img src="public/img/knife.png" alt="knife" />
    </div>
    <div class="top-bar">
      <img src="public/img/logo.svg" alt="logo" style="width: 100%; height: 100%; display: block" />
    </div>
    <div class="top-bar" style="align-self: center" id="dateTimeContainer"></div>
  </header>
  <aside class="left" style="padding: 0;">
    <section style="justify-content: center;">
      <a href="search">
        <div>
          <img src="public/img/search.png" alt="search" />
        </div>
      </a>
      <a href="star">
        <div class="selected">
          <img src="public/img/star.png" alt="star" />
        </div>
      </a>
      <a href="history">
        <div>
          <img src="public/img/history.png" alt="history" />
        </div>
      </a>
      <a href="user">
        <div>
          <img src="public/img/user.png" alt="user" />
        </div>
      </a>
    </section>
  </aside>
  <main style="overflow-y:scroll;">
    <?php if (isset($messages))
      foreach ($messages as $message) {
        echo $message;
      } ?>
    <button class="toggle-form-button" onclick="toggleForm()"> ADD RECIPE
    </button>
    <form action="addRecipe" method="POST" enctype="multipart/form-data" class="recipe-form-class" style="display: none;">
      <div id="recipe-form">
        <div class="recipe-field">
          <div class="recipe-form-label field" style="padding-top: 0.5em;">
            <label for="name">NAME*</label>
          </div>
          <input type="text" name="name" id="name" maxlength="50" required />
        </div>

        <div class="recipe-field">
          <div class="recipe-form-label field">
            <label for="description"> DESCRIPTION
            </label>
          </div>
          <textarea class="field" style="resize: vertical;" name="description" maxlength="200" id="description"></textarea>
        </div>

        <div class="recipe-field" id="ingredients-list">
          <div class="recipe-form-label field" style="padding-bottom: 0.5em;">
            <label for="ingredient_name"> INGREDIENTS* </label>
            <img src="public/img/more.png" style="width:7%; margin-top: 0em; vertical-align:middle;" id="plus">
          </div>
          <div class="ingredients field" id="ingredients-list1">
            <input style="width:19%;" type="number" name="factor1" id="factor1" step="0.01" placeholder="factor" min="0.01" required /><input style="width:19%;" type="text" name="unit1" id="unit1" placeholder="unit" required /><input style="width:40%;" type="text" name="ingredient_name1" id="ingredient_name1" maxlength="50" placeholder="name" required /><img src="public/img/minus.png"
                 style="width:7%; margin-top: 0.2em; vertical-align:middle;" class="minus-btn" data-list-id="ingredients-list1">
          </div>
        </div>
        <div class="recipe-field">
          <div class="recipe-form-label field">
            <label for="preparation"> PREPARATION </label>
          </div>
          <textarea class="field" style="resize: vertical;" name="preparation" id="preparation"></textarea>
        </div>

        <div style="display:block; box-sizing: border-box; margin-left: 10%;">
          <div class="recipe-field" style="width:30%; float: left;">
            <div class="recipe-form-label field">
              <label for="duration"> DURATION* </label>
            </div>
            <input style="text-align:center; " type="number" min="1" name="duration" id="duration" required />
          </div>
          <div class="recipe-field" style="width:30%; float: left;">
            <div class="recipe-form-label field">
              <label for="no_servings"> SERVINGS* </label>
            </div>
            <input style="text-align:center; " type="number" min="1" name="no_servings" id="no_servings" required />
          </div>
          <div class="recipe-field" style="width:30%; float: left;">
            <div class="recipe-form-label">
              <label for="file"> IMAGE* </label>
            </div>
            <input type="file" name="file" id="file" style="text-align:center;" required />
          </div>
        </div>
        <div style="clear: both;"></div>
        <span id="message" style="font-size: 0.5em;"></span>
        <button type="submit"> SUBMIT </button>
      </div>
    </form>

    <?php foreach ($recipes as $recipe): ?>
      <div class="form" style="padding:0.5em; margin:0.5em; height: auto; overflow:visible;">
        <span class="big-text">
          <?= $recipe->getName(); ?>
        </span> <br>
        <img src="public/uploads/<?= $recipe->getImage(); ?>" alt="img_<?= $recipe->getName(); ?>" style="width: 50%;" /> <br>
        <span class="mid-text">
          <?= $recipe->getDescription(); ?>
        </span> <br>
        <div style="text-align: left; width: 90%;">
          <span class="mid-text">INGREDIENTS</span> <br>
          <?php foreach ($recipe->getIngredients() as $ingredient): ?>
            <span class="smaller-text">
              <?= $ingredient->getFactor() . ' ' . $ingredient->getUnit() . ' ' . $ingredient->getIngredient(); ?> <br>
            </span>
          <?php endforeach; ?>
          <br>
          <span class="mid-text">DURATION:</span>
          <span class="mid-text">
            <?= $recipe->getDuration(); ?>
          </span> <br>
          <span class="mid-text">SERVINGS:</span>
          <span class="mid-text">
            <?= $recipe->getNoServings(); ?>
          </span> <br>
          <span class="mid-text">
            <?= $recipe->getUser_id(); ?>
          </span><br>
          <span class="mid-text">
          </span>
          <?= $recipe->getTimestamp(); ?><br><br>
          <div style="align-items: center; text-align:center;">
            <img width="10%" src="public/img/star.png" <?= ($recipe->getUser_id() == $_COOKIE['id']) ? 'style="background-color: yellow;"' : '' ?> alt="star" />
          </div>
        </div>
      </div>
    <?php endforeach; ?>
  </main>
  <aside style="padding-top: 3vh" class="images">
    <section>
      <img src="public/img/cake.png" alt="cake" />
      <img src="public/img/pasta.png" alt="pasta" />
      <img src="public/img/pizza.png" alt="pizza" />
    </section>
  </aside>
  <div style="clear: both"></div>


  <script type="text/javascript" src="public/scripts/date.js"></script>
  <script type="text/javascript" src="public/scripts/recipe.js"></script>
</body>

</html>