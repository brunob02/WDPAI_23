<?php
class Database
{
    private static $instance = null;
    private $connection;

    private $config;

    private function __construct()
    {
        $this->config = require 'config.php';
        $dsn = "pgsql:host={$this->config['host']};port={$this->config['port']};dbname={$this->config['dbname']};";
        try {
            $this->connection = new PDO($dsn, $this->config['user'], $this->config['pass'], [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
        } catch (PDOException $e) {
            error_log("Connection failed: " . $e->getMessage());
            throw $e;
        }
    }

    public static function getInstance()
    {
        if (!self::$instance) {
            self::$instance = new Database();
        }
        return self::$instance;
    }

    public function getConnection()
    {
        return $this->connection;
    }

    public function getAllTables()
    {
        $sql = "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';";
        try {
            $stmt = $this->connection->prepare($sql);
            $stmt->execute();

            return $stmt->fetchAll(PDO::FETCH_COLUMN);
        } catch (PDOException $e) {
            error_log("Query failed: " . $e->getMessage());
            return [];
        }
    }
}