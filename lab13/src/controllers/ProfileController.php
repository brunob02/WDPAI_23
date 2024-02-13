<?php

require_once 'AppController.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../repository/ProfileRepository.php';
class ProfileController extends AppController
{
  private $profileRepository;

  public function __construct()
  {
    parent::__construct();
    $this->profileRepository = new ProfileRepository();
  }

  public function userInfo()
  {
    if (!$this->isPost()) {
      return $this->render('user');
    }

    $level = isset($_POST['level']) ? htmlspecialchars($_POST['level'], ENT_QUOTES, 'UTF-8') : null;
    $interests = isset($_POST['interests']) ? htmlspecialchars($_POST['interests'], ENT_QUOTES, 'UTF-8') : null;

    if (isset($level)) {
      $this->profileRepository->setUserLevel($_COOKIE['id'], $level);
    }
    if (isset($interests)) {
      $this->profileRepository->setUserInterests($_COOKIE['id'], $interests);
    }

    return $this->render('user');
  }

  public function user()
  {
    $profileRepository = new ProfileRepository();
    $userInfo = $profileRepository->getUserInfo($_COOKIE['id']);


    if ($userInfo === null) {
      $this->render('user');
    }
    $messages = ['skill_level' => $userInfo['skill_level'], 'culinary_interests' => $userInfo['culinary_interests']];

    $this->render('user', ['messages' => $messages]);
  }
}