<?php
//required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

//include db and object files
include_once '../config/database.php';
include_once '../objects/parkingplace.php';

//make instance of db and parkingplace object
$database = new Database();
$db = $database->GetConnection();
$string = 'random string';
//make instance of object
$parkingplace = new Parkingplace($db);

//query parkingplace
$stmt = $parkingplace->Read();
$num = $stmt->rowCount();

//check if there is more then 0 record
if($num>0){
    //parkingplace array
    $parkingArr=array();

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