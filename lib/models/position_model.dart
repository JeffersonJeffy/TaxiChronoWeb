

class Position {

  double? lat;
  double? long;

  Position({
    this.lat,
    this.long
  });

  Position.fromMap(Map map) : this(
      lat: map.containsKey('lat') ? map['lat'] : 0,
      long: map.containsKey('lon') ? map['lon'] : 0,
  );

  Map<String, dynamic> toMap(){
    return {
      "lat": lat,
      "lon": long,
    };
  }
}