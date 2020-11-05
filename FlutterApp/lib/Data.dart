import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Post {
  dynamic data;
  Post.fromJson(this.data);
}

//Gets the data from the api
Future<Post> fetchData(http.Client client) async {
  final response =
      await client.get('http://develop-api-invalideparkeren.nl/api/parkingplace/read.php');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<Post> fetchSpecificData(http.Client client) async {
  String lat = "52.071510";
  String lon = "2.495053";
  String rad = "0.5";

  final response =
      await client.get('http://develop-api-invalideparkeren.nl/api/parkingplace/read_nearby.php?' + "Lat=" + lat + "&Lon=" + lon + "&Rad=" + rad);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load specific data');
  }
}

Future<Post> fetchReviews(http.Client client) async{
  final response = 
      await client.get("http://develop-api-invalideparkeren.nl/api/review/read.php");
    
    if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load reviews');
  }
}

Future<Post> fetchSpecificReview(http.Client client) async{
  final response = 
      await client.get("http://develop-api-invalideparkeren.nl/api/review/read.php?places=5");
    
    if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load reviews');
  }
}

Future<Post> postReview(http.Client client) async{
  Map<String,String> message = 
  {
      "Name":"Unit",
      "Comment":"Test",
      "Rating":"5",
      "Parkingspot":"52",
  };

  String body = jsonEncode(message);

  final response = 
      await client.post("http://develop-api-invalideparkeren.nl/api/review/create.php", body: body, headers: {
    "Accept": "application/json",
});
    
    if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load reviews');
  }
}

Future<Post> fetchAverageRating(http.Client client) async{
    final response = 
      await client.get("http://develop-api-invalideparkeren.nl/api/review/read_average_rating.php");

    
    if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load reviews');
  }
}

Future<Post> fetchSpecificAverageRating(http.Client client) async{
    final response = 
      await client.get("http://develop-api-invalideparkeren.nl/api/review/read_average_rating.php?Places=5");

    
    if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load reviews');
  }
}