import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapType _currenttype = MapType.normal;
  GoogleMapController mycontroller;
  final Set<Marker> _marker = {};
  static final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onmapcreated(GoogleMapController controller) {
    mycontroller = controller;
  }

  Position currentPosition;
  var geoLocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latlanPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latlanPosition,zoom: 14);
    
  }

  void _currentMaptype() {
    setState(() {
      _currenttype =
          _currenttype == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  LatLng _currentMapPosition = _center;
  void _oncameramove(CameraPosition position) {
    _currentMapPosition = position.target;
  }

  void _onaddmarkerbutton() {
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId(_currentMapPosition.toString()),
          position: _currentMapPosition,
          infoWindow: InfoWindow(
            title: 'Niece Place',
            snippet: 'Welcome To Poland',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google_Map_Example'),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
              markers: _marker,
              mapType: _currenttype,
              onCameraMove: _oncameramove,
              onMapCreated: _onmapcreated,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 10.0)),
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    splashColor: Colors.redAccent,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Icon(Icons.map),
                    onPressed: () => _onaddmarkerbutton(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.satellite_outlined),
                    onPressed: () => _currentMaptype(),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
