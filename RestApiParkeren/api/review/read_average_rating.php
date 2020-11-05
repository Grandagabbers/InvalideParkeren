<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: true");
header('Content-Type: application/json');

// include database and object files
include_once '../config/database.php';
include_once '../objects/review.php';

// get database connection
$database = new Database();
$db = $database->getConnection();

// prepare review object
$review = new Review($db);

$review ->Places = isset($_GET["Places"]) ? $_GET["Places"] : die();

$stmt = $review->ReadAverageRating();
$num = $stmt->rowCount();

if($num>0){
    //review array
    $reviewArr=array();

    //get table contents
    //fetch() is quicker than fetchAll()
    // http://stackoverflow.com/questions/2770630/pdofetchall-vs-pdofetch-in-a-loop
    while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        //extract row
        //this will make $row['name'] to just $name only
        extract($row);

        $reviewItem=array(
            "Parkingspot" => $Parkingspot,
            "AverageRating" => $Average_Rating
        );
        array_push($reviewArr,$reviewItem);
    }
    //set response code to 200 OK
    http_response_code(200);

    //show parking places data in json format
    echo json_encode($reviewArr);
}else{
    //set repsonse code to 404 NOT FOUND
    http_response_code(404);

    //tell user no parking places found
    echo json_encode(array("message"=>"No reviews found"));
}
?>