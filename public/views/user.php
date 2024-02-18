<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="X-UA-Compatible" content="ie=edge" />
  <title>Your account</title>
  <link rel="icon" href="public/img/icon.svg">
  <link rel="stylesheet" href="public/css/style.css" />
  <link rel="stylesheet" href="public/css/recipe.css" />
  <script type="text/javascript" src="public/scripts/date.js"></script>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300&display=swap" rel="stylesheet" />
  <style>
    form {
      all: revert;
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
  <aside class="left" style="padding: 0;">
    <section style="justify-content: center;">
      <a href="search">
        <div>
          <img src="public/img/search.png" alt="search" />
        </div>
      </a>
      <a href="star">
        <div>
          <img src="public/img/star.png" alt="star" />
        </div>
      </a>
      <a href="history">
        <div>
          <img src="public/img/history.png" alt="history" />
        </div>
      </a>
      <a href="user">
        <div class="selected">
          <img src="public/img/user.png" alt="user" />
        </div>
      </a>
    </section>
  </aside>
  <main style="overflow-y:scroll;">
    <form action="userInfo" method="POST" style="width: 90%;">
      <div id="recipe-form">
        <div class="recipe-field">
          <div class="recipe-form-label field" style="padding-top: 0.4em;">
            <label for="level">LEVEL</label>
          </div>
          
          <select name="level" id="level">

            <option value="beginner" <?php if (isset($messages) && $messages['skill_level'] === 'beginner')
              echo 'selected'; ?>>beginner</option>
            <option value="intermediate" <?php if (isset($messages) && $messages['skill_level'] === 'intermediate')
              echo 'selected'; ?>>intermediate</option>
            <option value="advanced" <?php if (isset($messages) && $messages['skill_level'] === 'advanced')
              echo 'selected'; ?>>advanced</option>
          </select>
        </div>
        <div class="recipe-field">
          <div class="recipe-form-label field" style="padding-bottom: 0.4em;">
            <label for="interests"> INTERESTS </label>
          </div>
          <textarea class="field" style="resize: vertical;" name="interests" maxlength="200" id="interests"><?php
          if (isset($messages['culinary_interests'])) {
            echo htmlspecialchars($messages['culinary_interests'], ENT_QUOTES, 'UTF-8');
          }
          ?></textarea>
        </div>
        <div style="clear: both;"></div>
        <span id="message" style="font-size: 0.5em;"></span>
        <button type="submit"> SUBMIT </button>
      </div>
    </form>
    <br>

    <form style="width: 90%;" action="index" method="post">
      <button type="submit" name="index">LOG OUT</button>
    </form>

  </main>
  <aside style="padding-top: 3vh" class="images">
    <section>
      <img src="public/img/cake.png" alt="cake" />
      <img src="public/img/pasta.png" alt="pasta" />
      <img src="public/img/pizza.png" alt="pizza" />
    </section>
  </aside>
  <div style="clear: both"></div>
</body>

</html>