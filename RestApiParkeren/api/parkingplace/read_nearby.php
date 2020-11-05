<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: true");
header('Content-Type: application/json');

// include database and object files
include_once '../config/database.php';
include_once '../objects/parkingplace.php';

// get database connection
$database = new Database();
$db = $database->getConnection();

// prepare parking object
$parkingplace = new Parkingplace($db);

$parkingplace ->Lat = isset($_GET["Lat"]) ? $_GET["Lat"] : die();
$parkingplace ->Lon = isset($_GET["Lon"]) ? $_GET["Lon"] : die();
$parkingplace ->Rad = isset($_GET["Rad"]) ? $_GET["Rad"] : die();

$stmt = $parkingplace->ReadNearby();
$num = $stmt->rowCount();

if($num>0){
    //parkingplace array
    $parkingArr=array();
    $randomTweeStringForPipeline = 'randomAangepast';

    //get table contents
    //fetch() is quicker than fetchAll()
    // http://stackoverflow.com/questions/2770630/pdofetchall-vs-pdofetch-in-a-loop
    while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        //extract row
        //this will make $row['name'] to just $name only
        extract($row);

        $parkingItem=array(
            "ID_Parkingspot" => $ID_Parkingspot,
            "Lat" => $Lat,
            "Lon" => $Lon
        );
        array_push($parkingArr,$parkingItem);
    }

    //set response code to 200 OK
    http_response_code(200);

    //show parking places data in json format
    echo json_encode($parkingArr);
}else{
    //set repsonse code to 404 NOT FOUND
    http_response_code(404);

    //tell user no parking places found
    echo json_encode(array("message"=>"No products found"));
}


