<?php
class Database{

    //database credentials
    /*private $host = "localhost";
    private $dbName = "dbparking";
    private $username = "root";
    private $password = "";*/

    private $host = "rdbms.strato.de";
    private $dbName = "DB4091698";
    private $username = "U4091698";
    private $password = "aC00cNFSFuS2";
    public $conn;

    //get the db connection
    public function GetConnection(){

        $this->conn = null;

        try{
            $this->conn = new PDO("mysql:host=". $this->host.";dbname=".$this->dbName,$this->username,$this->password);
            $this->conn->exec("set names utf8");
        }catch(PDOException $exception){
            echo "Connection error: " . $exception->getMessage();
        }
        return $this->conn;
    }
}
?>