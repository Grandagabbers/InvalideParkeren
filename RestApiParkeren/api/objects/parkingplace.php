<?php
class Parkingplace{
    
     // db connection and table name
     private $conn;
     private $table_name = "parkingplace";

     // object properties
    public $ID_Parkingspot;
    public $Lat;
    public $Lon;
    public $Rad;
    
    //concstructor with $db as db connection
    public function __construct($db){
        $this->conn= $db;
    }

    //Read parkingplaces
    function Read(){
        //the query
        $sql =
        "SELECT ID_Parkingspot,Lat,Lon FROM ParkingPlace";

        //prepare query statement
        $stmt = $this->conn->prepare($sql);

        //execute query
        $stmt->execute();

        return $stmt;
    }
    //Read nearby parkingplaces within Radius(Rad)
    function ReadNearby(){
        //query
        $sql =
        "SELECT ID_Parkingspot,Lat,Lon FROM ParkingPlace a
        WHERE (
            acos(sin(a.Lat * 0.0175) * sin(:Lat * 0.0175)
                    + cos(a.Lat * 0.0175) * cos(:Lat * 0.0175) *
                    cos((:Lon * 0.0175) - (a.Lon * 0.0175))
                ) *  6371 <= :Rad)";
        //prepare query
        $stmt = $this->conn->prepare($sql);
        
        //check for charchacters abd get rid of html and php tags
        $this->Lat=htmlspecialchars(strip_tags($this->Lat));
        $this->Lon=htmlspecialchars(strip_tags($this->Lon));
        $this->Rad=htmlspecialchars(strip_tags($this->Rad));

        //bind values
        $stmt->bindParam("Lat",$this->Lat);
        $stmt->bindParam("Lon",$this->Lon);
        $stmt->bindParam("Rad",$this->Rad);     
        //execute query
        $stmt->execute();

        return $stmt;
    }
}
?>