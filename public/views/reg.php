<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="X-UA-Compatible" content="ie=edge" />
  <title>Signing up</title>
  <link rel="icon" href="public/img/icon.svg" />
  <link rel="stylesheet" href="public/css/style.css" />
  <script type="text/javascript" src="public/scripts/date.js"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300&display=swap" rel="stylesheet" />
  <style>
  button {
    font-size: 0.7em;
  }

  input {
    font-size: 0.7em;
    margin: 0.3em;
  }
  </style>
  <script>
  var check = function() {
    if (
      document.getElementById('password').value ==
      document.getElementById('confirm_password').value
    ) {
      document.getElementById('message').innerHTML = ''
    } else {
      document.getElementById('message').style.color = 'red'
      document.getElementById('message').innerHTML = 'PASSWORDS MUST BE THE SAME'
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
  <aside style="height: 75vh">
    <section style="padding-top: 12vh; font-size: 0.8em">
      Web application
      <i style="color: var(--main-color-dark)">COOL COOK</i> will help you
      save your favorite recipes, as well as make shopping lists. If you want
      to use this application you are invited to register!
    </section>
  </aside>
  <main style="height: 75vh">
    <form action='reg' method='POST'>
      <?php if (isset($messages))
        foreach ($messages as $message) {
          echo $message;
        } ?>
      <input name="name" type="text" placeholder="name" required maxlength="25" autofocus />
      <input name="surname" type="text" placeholder="surname" required maxlength="25" />
      <input name="email" type="email" placeholder="email@email.com" required maxlength="50" />

      <input type="password" name="password" id="password" placeholder="password" required maxlength="255" onkeyup="check();" />

      <input type="password" name="confirm_password" id="confirm_password" placeholder="password" required maxlength="255" onkeyup="check();" />
      <span id="message" style="font-size: 0.6em;"></span>

      <button type="submit" style="width: 70%">SIGN UP</button>
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