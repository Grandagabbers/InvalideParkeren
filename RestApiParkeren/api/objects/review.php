<?php
class Review{

     // db connection and table name
     private $conn;
     private $table_name = "Review";

     // object properties
    public $ID_Review;
    public $Name;
    public $Comment;
    public $Rating;
    public $Parkingspot;
    public $Places;
    public $Average_Rating;
    
    //concstructor with $db as db connection
    public function __construct($db){
        $this->conn= $db;
    }

    //Read parkingplaces
    function Read(){
        //the query
        $sql =
        "SELECT Name,Comment,Rating,Parkingspot FROM Review";

        //prepare query statement
        $stmt = $this->conn->prepare($sql);

        //execute query
        $stmt->execute();

        return $stmt;
    }
    //Read nearby reviews with the given parkingspots
    function ReadNearby(){

        //check for charchacters and get rid of html and php tags
        $this->Places=htmlspecialchars(strip_tags($this->Places));
        
        //get the places from parameter
        $myPlaces = $this->Places;

        //convert string to array
        $placesArr = explode(',',$myPlaces);

        //instatiate prepmarkString
        $prepMarks = "";
        $prepMarksCount = count($placesArr);

        //prepare the amount of parameters
        for($i = 0; $i < $prepMarksCount; $i++){
            $prepMarks = $prepMarks . ":Place". $i;
            if ($i != $prepMarksCount - 1) {
                $prepMarks = $prepMarks . ",";
            }
        }
        //query
        $sql = "SELECT Name,Comment,Rating,Parkingspot FROM Review WHERE Parkingspot IN ($prepMarks)";

        //prepare query
        $stmt = $this->conn->prepare($sql);
        
        
        
        //bind values
        for($i = 0; $i < $prepMarksCount; $i++){  

            $stmt->bindParam("Place".$i,$placesArr[$i]);
            
        }

        //execute query
        $stmt->execute();

        return $stmt;

    }
    function ReadAverageRating(){
        //check for charchacters and get rid of html and php tags
        $this->Places=htmlspecialchars(strip_tags($this->Places));
        
        //get the places from parameter
        $myPlaces = $this->Places;

        //convert string to array
        $placesArr = explode(',',$myPlaces);

        //instatiate prepmarkString
        $prepMarks = "";
        $prepMarksCount = count($placesArr);

        //prepare the amount of parameters
        for($i = 0; $i < $prepMarksCount; $i++){
            $prepMarks = $prepMarks . ":Place". $i;
            if ($i != $prepMarksCount - 1) {
                $prepMarks = $prepMarks . ",";
            }
        }

        $sql = "SELECT Parkingspot , ROUND(AVG(Rating)) as Average_Rating
        from Review
        where Parkingspot in ($prepMarks)
        group by Parkingspot";

        //prepare query
        $stmt = $this->conn->prepare($sql);
        
        //bind values
        for($i = 0; $i < $prepMarksCount; $i++){  

            $stmt->bindParam("Place".$i,$placesArr[$i]);
            
        }

        //execute query
        $stmt->execute();

        return $stmt;
    }
    //create review
    function Create(){

        //query to insert review
        $sql = "INSERT INTO ".$this->table_name."(Rating,Comment,Name,Parkingspot) VALUES(:Rating,:Comment,:Name,:Parkingspot);";

        //prepare query
        $stmt = $this->conn->prepare($sql);

        //check for charchacters abd get rid of html and php tags
        $this->Name=htmlspecialchars(strip_tags($this->Name));
        $this->Rating=htmlspecialchars(strip_tags($this->Rating));
        $this->Comment=htmlspecialchars(strip_tags($this->Comment));
        $this->Parkingspot=htmlspecialchars(strip_tags($this->Parkingspot));
        
        //bind values
        $stmt->bindParam("Name",$this->Name);
        $stmt->bindParam("Rating",$this->Rating);
        $stmt->bindParam("Comment",$this->Comment);
        $stmt->bindParam("Parkingspot",$this->Parkingspot);

        //execute query
        if($stmt->execute()){
            return true;
        }
        return false;
    }
}
?>