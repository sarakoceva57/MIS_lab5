import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/list_item.dart';

class MapScreen extends StatefulWidget {
  static const String idScreen = "mapScreen";
  final List<ListItem> _exams;
  MapScreen(this._exams);

  @override
  _MapScreenState createState() => _MapScreenState(_exams);
}

class _MapScreenState extends State<MapScreen> {
  final NotificationService service = NotificationService();
  final List<Marker> markers = <Marker>[];
  Map<PolylineId, Polyline> polylines = {};
  List<ListItem> _items;

  _MapScreenState(this._items);

  @override
  void initState() {
    super.initState();
    _setMarkers(_items);
  }

  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(42.002, 21.407),
    zoom: 15,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  void _getShortestRoute(LatLng userLocationCoordinates,
      LatLng destinationLocationCoordinates) async {
    PolylinePoints polylinePoints = PolylinePoints();
    String googleAPI = 'AIzaSyCGShAceyIm1LHL2mLja0eKCKDjoZV2RzY';

    addPolyLine(List<LatLng> polylineCoordinates) {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Color.fromARGB(255, 88, 88, 94),
        points: polylineCoordinates,
        width: 10,
      );
      polylines[id] = polyline;
      setState(() {});
    }

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPI,
      PointLatLng(
          userLocationCoordinates.latitude, userLocationCoordinates.longitude),
      PointLatLng(destinationLocationCoordinates.latitude,
          destinationLocationCoordinates.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  void _setMarkers(items) {
    for (var i = 0; i < items.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position:
              LatLng(items[i].location.latitude, items[i].location.longitude),
          infoWindow: InfoWindow(
            title: items[i].predmet,
            snippet: DateFormat("yyyy-mm-dd hh:mm:ss").format(items[i].datum),
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            getUserCurrentLocation().then((userLocation) async {
              LatLng destinationLocationCoordinates = LatLng(
                  items[i].location.latitude, items[i].location.longitude);
              LatLng userLocationCoordinates =
                  LatLng(userLocation.latitude, userLocation.longitude);
              _getShortestRoute(
                  userLocationCoordinates, destinationLocationCoordinates);
            });
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            markers: Set<Marker>.of(markers),
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: _kGoogle,
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 13,
            );
            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: Icon(
          Icons.center_focus_strong_rounded,
          color: Colors.brown,
        ),
      ),
    );
  }
}
