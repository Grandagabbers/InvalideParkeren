import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import './ReviewPopup.dart';
import 'dart:math';
import 'ReviewPopup.dart';



class VindLocatie extends StatefulWidget {
  @override
  _VindLocatieState createState() => _VindLocatieState();
}

class _VindLocatieState extends State<VindLocatie> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Location location = Location();

  List data;
  List reviews;
  Map<String, String> specificParkingSpotRating = <String, String>{};
  List avgRating;
  String link = "https://projectse7.azurewebsites.net?";
  String url = "http://invalideparkeren.nl/api/";

  int pressedMarkerID;
  String rating;
  String userLat;
  String userLon;
  String rad = "0.5";
  String place = "";
  String message = "De radius is: 0.5";

  double radius = 0.5;
  bool hasData = false;
  @override
  void initState() {
    super.initState();
    ///Updates the "userLat" and "userLon" variables with the
    ///user's location information that is being tracked.
    location.onLocationChanged().listen((userLocationData) {
      setState(() {
        userLat = userLocationData.latitude.toString();
        userLon = userLocationData.longitude.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: new Text("P-App"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            ///Container occupies half of the screen
            ///based on the user's phone height.
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _zoet,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: Set<Marker>.of(markers.values),
            ),
          ),
          new Expanded(
              child: new ListView(
            children: <Widget>[
              new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 14,
                child: Center(
                    child: new Text(
                  message + " KM hemelsbreed.",
                  style: new TextStyle(color: Colors.blue, fontSize: 20),
                )),
              ),
              new Slider(
                value: radius,
                onChanged: (double e) => changed(e),
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                divisions: 200,
                max: 10,
                min: 0,
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 9,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1.5),
                  child: RaisedButton(
                    onPressed: () {
                      _removeMarkers();
                      _onLoading();
                      //Old code because of slow api's and performance
                      /*
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 6), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              title: Text('Zoeken naar parkeerplaatsen...'),
                            );
                          });
                          */
                    },
                    elevation: 5.0,
                    textColor: Colors.blue,
                    color: Colors.white,
                    child: Text("ZOEK PARKEERPLAATSEN"),
                  ),
                ),
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: RaisedButton(
                    onPressed: () {
                      _reviewCheck();
                    },
                    elevation: 5.0,
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("PLAATS EEN REVIEW"),
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

void _onLoading() {
  if(userLat == null || userLon == null)
  {
    location.getLocation().then((userLocationData){
      setState(() {
          userLat = userLocationData.latitude.toString();
          userLon = userLocationData.longitude.toString();
        });
     });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(margin: new EdgeInsets.only(left:10, right:10, top:5, bottom: 5) ,width: 30 ,height: 30 ,child: new CircularProgressIndicator()),
              new Text("Uw locatie wordt gezocht..."),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 2), () {
    Navigator.pop(context); //pop dialog
    });
  }
  else{
    getData();
  }
}


  ///When called, use the user's latitude, longitude and a set radius
  ///to pull all required data of parkingspots in that specific area.
  ///Data is received in a .json file which gets decoded and stored in
  ///the list "data".
  //Get specific data based on the radius and lat/lon of the user
  Future<List> getData() async{
    try{
      http.Response response = await http.get(
        Uri.encodeFull(url + "parkingplace/read_nearby.php?" +  "Lat=" + userLat + "&Lon=" + userLon + "&Rad=" + rad),
        headers: {
          "Accept": "application/json",
        }
      );
      if(response.statusCode == 200){
        setState(() {
        data = json.decode(response.body);
        });
        getReviews();
        return data;
      }
      else{
        alert(context, "Geen parkeerplekken gevonden!", "Maak uw radius groter.");
        return null;
      }

    }
    catch(Exception)
    {
      alert(context, "Er is iets mis gegaan!", "Probeer het opnieuw.");
      return null;
    }
  }

  //Gets all data from the database
  Future<List> getAllData() async{
    http.Response response = await http.get(
      Uri.encodeFull(link + "parkingplace/read.php"),
      headers: {
        "Accept": "application/json",
      }
    );
    setState(() {
     data = json.decode(response.body);
    });
    return data;
  }

  //Gets
  Future<List> getReviews() async{
    try{
      place = "";
      for (int i = 0; i < data.length; i++) {
          place = place + data[i]['ID_Parkingspot'].toString() + ",";
      }
      http.Response response = await http.get(
        Uri.encodeFull("http://invalideparkeren.nl/api/review/read_nearby.php?Places=" + place),
        headers: {
          "Accept": "application/json",
        }
      );
      if(response.statusCode == 200)
      {     
        setState(() {
        reviews = json.decode(response.body);
        });
        getAverageRating();
        return reviews;
      }
      else{
        _generateMarkerList();
        return null;
      }

    }
    catch(Exception){
      alert(context, "Er is iets mis gegaan!", "Probeer het opnieuw.");
      return null;
    }

  }

  //Gets the average rating of the parkingspaces
  Future<List> getAverageRating() async{
    try{
      http.Response response = await http.get(
        Uri.encodeFull(url + "review/read_average_rating.php?Places=" + place),
        headers: {
        "Accept": "application/json",
        }
      );
      if(response.statusCode == 200)
      {
        setState(() {
          avgRating = json.decode(response.body);
        });
        _generateMarkerList();
        return avgRating;
      }
      else{
        _generateMarkerList();
        return null;
      }
    }
    catch(Exception){
      alert(context, "Er is iets mis gegaan!", "Probeer het opnieuw.");
      return null;
    }
  }

  /*
  Future<int> getData() async {
    await http
        .post(link + "lat=" + userLat + "&lon=" + userLon + "&rad=" + rad);
    var response =
        await http.get("https://projectse7.azurewebsites.net/data.json");
    if (response.body != "") {
      this.setState(() {
        data = json.decode(response.body);
      });

      for (int i = 0; i < data.length; i++) {
        place = place + data[i]['ID_ParkingSpot'].toString() + ",";
      }
      await http.post(link + "places=" + place);
      var response2 =
          await http.get("https://projectse7.azurewebsites.net/reviews.json");

      this.setState(() {
        reviews = json.decode(response2.body);
      });

      var response3 =
          await http.get("https://projectse7.azurewebsites.net/AVGrating.json");

      this.setState(() {
        avgRating = json.decode(response3.body);
      });

      _generateMarkerList();
      return 1;
    } else {
      alert(context, "Geen parkeerplaatsen gevonden", "Probeer opnieuw");
      return 0;
    }
    //debugging
    //print("${data[0]["lat"]} and ${data[0]["lon"]} and ${data[0]["ID_ParkingSpot"]}");
  }
  */

  ///When called, clears the Map "markers" to avoid the usage of outdated/duplicated
  ///data and overflows. Then goes into a For loop to make markers with the
  ///corresponding ID of every parkingspot in the "Data" and lasty adds them
  ///to the "markers" Map<> to display on the GoogleMap.
  void _generateMarkerList() {
    try{
      markers.clear();

      for (int i = 0; i < data.length; i++) {
        final MarkerId parkingspotId =
            MarkerId(data[i]["ID_Parkingspot"].toString());
        String id = data[i]["ID_Parkingspot"];

        if(avgRating != null)
        {
          for (int x = 0; x < avgRating.length; x++) {
            if (avgRating[x]["Parkingspot"] == id) {
              rating = avgRating[x]["AverageRating"].toString();
              //Stops the for loop for when average rating has been found for that marker
              break;
            } else {
              rating = "Onbekend";
            }
          }
        }
        else{
          rating = "Onbekend";
        }

        final Marker marker = Marker(
            markerId: parkingspotId,
            position: LatLng(
            double.parse(data[i]["Lat"]),
              double.parse(data[i]["Lon"]),
            ),
            infoWindow: InfoWindow(
              title: "Klik voor de reviews. Average Rating = " + rating,
              onTap: (){
                if(reviews.isNotEmpty){
                  for (var j = 0; j < reviews.length; j++){
                    if(data[i]["ID_Parkingspot"] == reviews[j]["Parkingspot"]){
                      Scrollbar(
                        child: ListView.builder(
                          itemCount: j,
                          itemBuilder: (context, index) => ListTile(title: Text("test"),),
                        ),
                      );
                    }
                  }
                }
              },
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            onTap: () {
              pressedMarkerID = int.parse(parkingspotId.value);
            });
        setState(() {
          markers[parkingspotId] = marker;
        });
      }
    }
    catch(Exception){
      alert(context, "Er is iets mis gegaan!", "Probeer het opnieuw.");
      return null;
    }
  }

  ///When called, you'll be able to leave a review in a new
  ///review window that pops up. If you have not selected a
  ///marker yet, you'll be prompted with an alert asking you
  ///to select a marker.
  void _reviewCheck() {
    if (pressedMarkerID != null && pressedMarkerID >= 0) {
      showModalBottomSheet(
        context: context,
        builder: (context) => ReviewPopup(id: pressedMarkerID),
      );
    } else {
      _alert(context, "Geen marker", "Klik op een marker");
    }
  }

  ///When called, the marker(s) which are present on the map
  ///will be removed by finding matching parking spot IDs in
  ///the markers dictionary and data array.
  void _removeMarkers() {
    setState(() {
      if (data != null) {
        for (var x = 0; x < data.length; x++) {
          String stringMarkerId = data[x]["ID_Parkingspot"].toString();
          final MarkerId markerId = MarkerId(stringMarkerId);

          if (markers.containsKey(markerId)) {
            markers.remove(markerId);
            print("marker removed with ID: " + markerId.toString()); //debugging
          } else {
            print("markers array is empty"); //debugging
          }
        }
        data.clear();
      }

      ///The markers are gone so pressedMarkerID does not
      ///have a value asssociated with it.
      pressedMarkerID = null;
    });
  }

  void changed(double e) {
    setState(() {
      int decimals = 1;
      int fac = pow(10, decimals);
      radius = e;
      rad = ((e * fac).round() / fac).toString();
      message = "De radius is: " + rad;
      print(message);
    });
  }

  ///Builds and displays an alert box with the giving parameter values.
  void _alert(BuildContext context, String title, String comment) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(comment),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///When called, centers the screen on the latitude and
  ///longitude values of the users last known position.
  Future _animateToUser() async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: new LatLng(double.parse(userLat), double.parse(userLon)),
          zoom: 15.0,
        ),
      ),
    );
  }

  ///This is the standard location you'll be presented with
  ///when reaching the Google Maps page. For now it is set
  ///to the latitude and Longitude of Zoetermeer.
  final CameraPosition _zoet = CameraPosition(
    target: LatLng(52.0575, 4.49306),
    zoom: 12.0,
  );
}
