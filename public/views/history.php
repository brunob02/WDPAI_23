<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="X-UA-Compatible" content="ie=edge" />
  <title>Your lists</title>
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
  <aside class="left" style="height: 75vh; padding: 0">
    <section>
      <a href="search">
        <div style="justify-content: center">
          <img src="public/img/search.png" alt="search" />
        </div>
      </a>
      <a href="star">
        <div style="justify-content: center">
          <img src="public/img/star.png" alt="star" />
        </div>
      </a>
      <a href="history">
        <div class="selected" style="justify-content: center">
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
    <button class="toggle-form-button" onclick="toggleForm()"> ADD LIST
    </button>
    <form action="addList" method="POST" class="recipe-form-class" style="display: none;">
      <?php if (isset($messages))
        foreach ($messages as $message) {
          echo $message;
        } ?>
      <div id="recipe-form">
        <div class="recipe-field">
          <div class="recipe-form-label field" style="padding-top: 0.5em;">
            <label for="name">NAME</label>
          </div>
          <input type="text" name="name" id="name" maxlength="50" required />
        </div>

        <div class="recipe-field" id="ingredients-list">
          <div class="recipe-form-label field" style="padding-bottom: 0.5em;">
            <label for="ingredient_name"> INGREDIENTS* </label> <img src="public/img/more.png" style=" width:7%; margin-top: 0em; vertical-align:middle;" id="plus">
          </div>
          <div class="ingredients field" id="ingredients-list1">
            <input style="width:19%;" type="number" name="factor" id="factor1" step="0.01" placeholder="factor" min="0.01" required /><input style="width:19%;" type="text" name="unit" id="unit1" placeholder="unit" required /><input style="width:40%;" type="text" name="ingredient_name" id="ingredient_name1" maxlength="50" placeholder="name" required /><img src="public/img/minus.png"
                 style=" width:7%; margin-top: 0.2em; vertical-align:middle;" class="minus-btn" data-list-id="ingredients-list1">
          </div>
        </div>

        <div style="clear: both;"></div>
        <span id="message" style="font-size: 0.5em;"></span>
        <button type="submit"> SUBMIT </button>
      </div>
    </form>

    <div class="form" style="padding:0.5em; margin:0.5em; height: auto; overflow:visible;">
      <span class="big-text">FIRST LIST</span> <br>
      <span class="mid-text">01.02.2024 10:00</span> <br>
      <div style="text-align: left; width: 90%;">
        <span class="smaller-text">2 cups Flour</span> <br>
        <span class="smaller-text">1 1/2 cup Icing sugar</span><br>
        <span class="smaller-text">1/2 cup Butter milk</span><br>
        <span class="smaller-text">1/3 Cocoa powder</span><br>
        <span class="smaller-text">3 Eggs</span><br>
        <span class="smaller-text">1/2 cup Oil</span><br>
        <span class="smaller-text">Butter 80g</span><br>
        <span class="smaller-text">1 tbsp Chocolate brown</span><br>
        <span class="smaller-text">1/2 tbsp Vanilla flavour</span><br>
        <span class="smaller-text">1 cup Hot water</span>
        <br> <br>
        <div style="align-items: center; text-align:center;" class="bin">
          <img width="10%" src="public/img/bin.png" alt="star" />
        </div>
      </div>

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