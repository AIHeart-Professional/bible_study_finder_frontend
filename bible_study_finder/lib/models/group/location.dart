class Location {
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipcode;
  final double? latitude;
  final double? longitude;
  final String? virtualMeetingLink;

  const Location({
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.latitude,
    this.longitude,
    this.virtualMeetingLink,
  });

  factory Location.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Location();
    }
    return Location(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zipcode: json['zipcode'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      virtualMeetingLink: json['virtualMeetingLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zipcode': zipcode,
      'latitude': latitude,
      'longitude': longitude,
      'virtualMeetingLink': virtualMeetingLink,
    };
  }

  String getDisplayString() {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (zipcode != null && zipcode!.isNotEmpty) parts.add(zipcode!);
    if (parts.isEmpty && virtualMeetingLink != null) {
      return 'Online: $virtualMeetingLink';
    }
    return parts.isEmpty ? 'Location not specified' : parts.join(', ');
  }
}

