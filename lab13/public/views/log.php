<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="X-UA-Compatible" content="ie=edge" />
  <title>Logging in</title>
  <link rel="icon" href="public/img/icon.svg">
  <link rel="stylesheet" href="public/css/style.css" />
  <script type="text/javascript" src="public/scripts/date.js"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300&display=swap" rel="stylesheet" />
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
  <aside style="height: 75vh">
    <section style="padding-top: 12vh; font-size: 0.8em">
      Web application
      <i style="color: var(--main-color-dark)">COOL COOK</i> will help you
      save your favorite recipes, as well as make shopping lists. If you want
      to use this application you are invited to register!
    </section>
  </aside>
  <main style="height: 75vh">
    <form action='log' method='POST'>
      <?php if(isset($messages)) foreach($messages as $message) { echo $message; } ?>
      <input name="email" type="email" placeholder="email@email.com" required maxlength="50" value="<?php if(isset($_COOKIE['email'])) echo $_COOKIE['email'] ?>" autofocus />
      <input name="password" type="password" placeholder="password" required maxlength="25" value="<?php if(isset($_COOKIE['password'])) echo $_COOKIE['password'] ?>" />
      <button type="submit">LOG IN</button>
    </form>
  </main>
  <aside style="height: 75vh; padding-top: 3vh" class="images">
    <section>
      <img src="public/img/cake.png" alt="cake" />
      <img src="public/img/pasta.png" alt="pasta" />
      <img src="public/img/pizza.png" alt="pizza" />
    </section>
  </aside>
  <div style="clear: both"></div>
</body>

</html>