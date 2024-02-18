<?php
class User
{
    private $email;
    private $name;
    private $surname;
    private $password;
    private $id;
    public function getEmail()
    {
        return $this->email;
    }
    public function getName()
    {
        return $this->name;
    }
    public function getSurname()
    {
        return $this->surname;
    }
    public function getPassword()
    {
        return $this->password;
    }
    public function getId()
{
    return $this->id;
}

    public function setId($id)
    {
        $this->id = $id;
    }

    public function __construct($email, $name, $surname, $password)
    {
        $this->email = $email;
        $this->name = $name;
        $this->surname = $surname;
        $this->password = $password;
    }

    public function userExists($email, $database)
    {
        $stmt = $database->prepare("SELECT * FROM 'users' WHERE email = ?;");
        $stmt->bindValue(1, $email);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return count($result) > 0;
    }

    public function createUser($email, $name, $surname, $password, $database)
    {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $database->prepare("INSERT INTO 'users' (email, name, surname, password) VALUES (?, ?, ?, ?);");
        $stmt->bind_param("ssss", $email, $name, $surname, $hashedPassword);
        $stmt->execute();
        return $stmt->insert_id;
    }
}