<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

//get db connection
include_once '../config/database.php';

//instantiate the review object
include_once '../objects/review.php';

$database = new Database();
$db = $database->GetConnection();

$review = new Review($db);

//get posted data
$data = json_decode(file_get_contents("php://input"));

//makse sure the data is not empty
if(
    !empty($data->Name)&&
    !empty($data->Comment)&&
    !empty($data->Rating)&&
    !empty($data->Parkingspot)
){
    $review->Name = $data->Name;
    $review->Comment = $data->Comment;
    $review->Rating = $data->Rating;
    $review->Parkingspot = $data->Parkingspot;

    if($review->create()){

        //set response code -201 created
        http_response_code(201);

        //tell the user 
        echo json_encode(array("message"=>"Review is posted"));
    }
    //if unable to post review, tell the user
    else{
        //set respone code - 503 service unavailible
        http_response_code(503);

        //tell the user
        echo json_encode(array("Message"=>"Unable to post review"));
    }
}
//tell the user not all data is given
else{
    //set respone code - 400 bad request
    http_response_code(400);

    //tell the user
    echo json_encode(array("Message"=>"Unable to create review. Not all data is given."));
}
?>