<?php

require_once 'Repository.php';
require_once __DIR__ . '/../models/User.php';

class ProfileRepository extends Repository
{

  public function getUserInfo(int $id): ?array
  {
    $stmt = $this->database->getConnection()->prepare('
            SELECT "culinary_interests", "skill_level" FROM "profiles" WHERE id = :id;');
    $stmt->bindParam(':id', $id, PDO::PARAM_INT);
    $stmt->execute();

    $info = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($info == false) {
      return null;
    }
    
    return $info;
  }

  public function setUserInterests(int $id, string $interests): void
  {

    $stmt = $this->database->getConnection()->prepare('
        UPDATE "profiles" SET "culinary_interests" = :interests WHERE id = :id;
    ');

    $stmt->bindParam(':interests', $interests, PDO::PARAM_STR);
    $stmt->bindParam(':id', $id, PDO::PARAM_INT);

    $stmt->execute();
  }

  public function setUserLevel(int $id, string $level): void
  {

    $stmt = $this->database->getConnection()->prepare('
      UPDATE "profiles" SET "skill_level" = :level WHERE id = :id;
      ');

    $stmt->bindParam(':level', $level, PDO::PARAM_STR);
    $stmt->bindParam(':id', $id, PDO::PARAM_INT);

    $stmt->execute();
  }
}