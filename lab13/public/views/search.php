<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="X-UA-Compatible" content="ie=edge" />
  <title>Search</title>
  <link rel="icon" href="public/img/icon.svg">
  <link rel="stylesheet" href="public/css/style.css" />
  <link rel="stylesheet" href="public/css/recipe.css" />
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300&display=swap" rel="stylesheet" />

  <style>
  form {
    all: revert;
  }

  .search-container form input {
    background-color: var(--main-color-light);
    box-shadow: 0px 1px 1px 1px #00000050;
    border-radius: 10px;
    color: black;
    margin: 1em;
    line-height: 2em;
    border: 1px solid black;
    width: 70%;
    font-size: 1em;
  }

  .search-container form input:hover {
    background-color: #eaeaea;
  }
  </style>
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
  <aside class="left" style="height: 75vh; padding: 0">
    <section>
      <a href="search">
        <div class="selected" style="justify-content: center">
          <img src="public/img/search.png" alt="search" />
        </div>
      </a>
      <a href="star">
        <div style="justify-content: center">
          <img src="public/img/star.png" alt="star" />
        </div>
      </a>
      <a href="history">
        <div style="justify-content: center">
          <img src="public/img/history.png" alt="history" />
        </div>
      </a>
      <a href="user">
        <div style="justify-content: center">
          <img src="public/img/user.png" alt="user" />
        </div>
      </a>
    </section>
  </aside>
  <main style="overflow-y:scroll;">


    <section class="recipes">

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

    </section>
  </main>
  <aside style="height: 75vh; padding-top: 3vh" class="images">
    <section>
      <img src="public/img/cake.png" alt="cake" />
      <img src="public/img/pasta.png" alt="pasta" />
      <img src="public/img/pizza.png" alt="pizza" />
    </section>
  </aside>
  <div style="clear: both"></div>
  <script defer src="public/scripts/date.js"></script>
</body>

</html>