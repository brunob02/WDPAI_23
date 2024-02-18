<?php

require_once 'Repository.php';
require_once __DIR__ . '/../models/User.php';

class UserRepository extends Repository
{

    public function getUser(string $email): ?User
    {
        $stmt = $this->database->getConnection()->prepare('
            SELECT * FROM "users" WHERE email = :email;');
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->execute();

        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user == false) {
            return null;
        }

        return new User(
            $user['email'],
            $user['name'],
            $user['surname'],
            $user['password'],
        );
    }

    public function getUserId(string $email): ?int
    {
        $stmt = $this->database->getConnection()->prepare('
        SELECT id FROM users WHERE email = :email;
    ');

        $stmt->execute([':email' => $email]);

        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result === false) {
            return null;
        }

        return (int) $result['id'];
    }

    public function addUser(User $user)
    {
        $stmt = $this->database->getConnection()->prepare('
            INSERT INTO "users" (email, name, surname, password)
            VALUES (?, ?, ?, ?);
        ');

        $stmt->execute([
            $user->getEmail(),
            $user->getName(),
            $user->getSurname(),
            $user->getPassword()
        ]);

        $id = $this->getUserId($user->getEmail());

        if ($id !== null) {
            $stmt = $this->database->getConnection()->prepare('
                INSERT INTO "profiles" (id, skill_level)
                VALUES (:id, \'beginner\');
            ');

            $stmt->bindParam(':id', $id, PDO::PARAM_INT);

            $stmt->execute();
        }

    }
}