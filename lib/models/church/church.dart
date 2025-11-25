class Church {
  final String id;
  final String name;
  final String denomination;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String website;
  final String email;
  final String pastorName;
  final List<String> serviceTypes;
  final List<ServiceTime> serviceTimes;
  final List<String> ministries;
  final String description;
  final double distance; // in miles
  final double rating;
  final int reviewCount;
  final List<String> photos;
  final bool hasChildcare;
  final bool hasYouthProgram;
  final bool isWheelchairAccessible;
  final bool hasParking;

  const Church({
    required this.id,
    required this.name,
    required this.denomination,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.website,
    required this.email,
    required this.pastorName,
    required this.serviceTypes,
    required this.serviceTimes,
    required this.ministries,
    required this.description,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.photos,
    required this.hasChildcare,
    required this.hasYouthProgram,
    required this.isWheelchairAccessible,
    required this.hasParking,
  });

  String get fullAddress => '$address, $city, $state $zipCode';
  
  String get distanceText => distance < 1 
      ? '${(distance * 5280).round()} ft away'
      : '${distance.toStringAsFixed(1)} mi away';

  String get ratingText => rating > 0 
      ? '${rating.toStringAsFixed(1)} ($reviewCount reviews)'
      : 'No reviews yet';
}

class ServiceTime {
  final String dayOfWeek;
  final String time;
  final String type; // e.g., "Sunday Service", "Bible Study", "Prayer Meeting"
  final String? description;

  const ServiceTime({
    required this.dayOfWeek,
    required this.time,
    required this.type,
    this.description,
  });

  String get displayText => '$dayOfWeek $time - $type';
}
