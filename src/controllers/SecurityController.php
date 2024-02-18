<?php

require_once 'AppController.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../repository/UserRepository.php';
class SecurityController extends AppController
{
  private $userRepository;
  public function __construct()
  {
    parent::__construct();
    $this->userRepository = new UserRepository();
  }
  public function log()
  {
    $userRepository = new UserRepository();

    if (!$this->isPost()) {
      return $this->render('log');
    }

    $email = isset($_POST['email']) ? htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8') : null;
    $password = isset($_POST['password']) ? $_POST['password'] : null;

    $user = $userRepository->getUser($email);

    if (!$user) {
      return $this->render('log', ['messages' => ['User not found!']]);
    }
    if ($user->getEmail() !== $email) {
      return $this->render('log', ['messages' => ['Wrong email.']]);
    }
    if (!password_verify($password, $user->getPassword())) {
      return $this->render('log', ['messages' => ['Wrong password.']]);
    }

    $database = new UserRepository();
    setcookie("email", $email, time() + 60 * 60 * 24 * 7);
    setcookie("id", $database->getUserId($email), time() + 60 * 60 * 24 * 7);
    setcookie("password", $password, time() + 60 * 60 * 24 * 7);

    return $this->render('user');
  }

  public function reg()
  {
    if (!$this->isPost()) {
      return $this->render('reg');
    }

    $email = isset($_POST['email']) ? htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8') : null;
    $name = isset($_POST['name']) ? htmlspecialchars($_POST['name'], ENT_QUOTES, 'UTF-8') : null;
    $surname = isset($_POST['surname']) ? htmlspecialchars($_POST['surname'], ENT_QUOTES, 'UTF-8') : null;
    $password = isset($_POST['password']) ? $_POST['password'] : null;
    $confirm_password = isset($_POST['confirm_password']) ? $_POST['confirm_password'] : null;

    if ($password !== $confirm_password) {
      return $this->render('reg', ['messages' => ['Passwords do not match.']]);
    }

    $password_hashed = password_hash($password, PASSWORD_DEFAULT);
    $user = new User($email, $name, $surname, $password_hashed);
    $database = new UserRepository();

    if ($database->getUser($email)) {
      return $this->render('reg', ['messages' => ['User with this email exist.']]);
    }

    $this->userRepository->addUser($user);

    return $this->render('log', ['messages' => ['Registration successful. Please log in']]);
  }

  public function logout()
  {
    if (!$this->isPost()) {
      return $this->render('user');
    }
  }
}