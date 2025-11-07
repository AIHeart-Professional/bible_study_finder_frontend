import '../../models/church/church.dart';

class ChurchService {
  static const List<Church> _placeholderChurches = [
    Church(
      id: '1',
      name: 'Grace Community Church',
      denomination: 'Non-denominational',
      address: '123 Main Street',
      city: 'Seattle',
      state: 'WA',
      zipCode: '98101',
      latitude: 47.6062,
      longitude: -122.3321,
      phoneNumber: '(206) 555-0123',
      website: 'https://gracecommunity.org',
      email: 'info@gracecommunity.org',
      pastorName: 'Pastor John Smith',
      serviceTypes: ['Traditional', 'Contemporary', 'Youth'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '9:00 AM',
          type: 'Traditional Service',
          description: 'Classic hymns and liturgical worship',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '11:00 AM',
          type: 'Contemporary Service',
          description: 'Modern worship with contemporary music',
        ),
        ServiceTime(
          dayOfWeek: 'Wednesday',
          time: '7:00 PM',
          type: 'Bible Study',
          description: 'Midweek Bible study and prayer',
        ),
      ],
      ministries: [
        'Youth Ministry',
        'Women\'s Ministry',
        'Men\'s Ministry',
        'Children\'s Ministry',
        'Seniors Ministry'
      ],
      description:
          'A welcoming community church focused on worship, fellowship, and serving our neighborhood. We believe in the power of God\'s love to transform lives.',
      distance: 2.1,
      rating: 4.8,
      reviewCount: 127,
      photos: ['church1.jpg', 'church2.jpg'],
      hasChildcare: true,
      hasYouthProgram: true,
      isWheelchairAccessible: true,
      hasParking: true,
    ),
    Church(
      id: '2',
      name: 'First Baptist Church',
      denomination: 'Baptist',
      address: '456 Oak Avenue',
      city: 'Bellevue',
      state: 'WA',
      zipCode: '98004',
      latitude: 47.6101,
      longitude: -122.2015,
      phoneNumber: '(425) 555-0456',
      website: 'https://firstbaptistbellevue.org',
      email: 'welcome@firstbaptist.org',
      pastorName: 'Pastor David Johnson',
      serviceTypes: ['Traditional', 'Family'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '10:30 AM',
          type: 'Sunday Worship',
          description: 'Family-friendly worship service',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '6:00 PM',
          type: 'Evening Service',
          description: 'Reflective evening worship',
        ),
        ServiceTime(
          dayOfWeek: 'Thursday',
          time: '7:30 PM',
          type: 'Prayer Meeting',
          description: 'Community prayer and fellowship',
        ),
      ],
      ministries: [
        'Missions',
        'Music Ministry',
        'Food Pantry',
        'Senior Care',
        'Bible Study Groups'
      ],
      description:
          'Established in 1952, we are a Bible-believing church committed to sharing God\'s love through worship, discipleship, and community outreach.',
      distance: 5.3,
      rating: 4.6,
      reviewCount: 89,
      photos: ['baptist1.jpg', 'baptist2.jpg'],
      hasChildcare: true,
      hasYouthProgram: true,
      isWheelchairAccessible: true,
      hasParking: true,
    ),
    Church(
      id: '3',
      name: 'St. Mark\'s Lutheran Church',
      denomination: 'Lutheran (ELCA)',
      address: '789 Pine Street',
      city: 'Seattle',
      state: 'WA',
      zipCode: '98122',
      latitude: 47.6205,
      longitude: -122.3212,
      phoneNumber: '(206) 555-0789',
      website: 'https://stmarklutheran.org',
      email: 'office@stmarklutheran.org',
      pastorName: 'Pastor Sarah Williams',
      serviceTypes: ['Traditional', 'Liturgical'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '8:00 AM',
          type: 'Early Service',
          description: 'Quiet contemplative worship',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '10:30 AM',
          type: 'Main Service',
          description: 'Full liturgical service with choir',
        ),
      ],
      ministries: [
        'Social Justice',
        'Community Garden',
        'Adult Education',
        'Confirmation',
        'Choir'
      ],
      description:
          'A progressive Lutheran congregation committed to justice, inclusion, and spiritual growth. All are welcome at God\'s table.',
      distance: 1.8,
      rating: 4.7,
      reviewCount: 94,
      photos: ['lutheran1.jpg'],
      hasChildcare: true,
      hasYouthProgram: false,
      isWheelchairAccessible: true,
      hasParking: false,
    ),
    Church(
      id: '4',
      name: 'New Life Pentecostal Church',
      denomination: 'Pentecostal',
      address: '321 Second Avenue',
      city: 'Renton',
      state: 'WA',
      zipCode: '98055',
      latitude: 47.4829,
      longitude: -122.2171,
      phoneNumber: '(425) 555-0321',
      website: 'https://newlifepentecostal.org',
      email: 'info@newlifepentecostal.org',
      pastorName: 'Pastor Michael Garcia',
      serviceTypes: ['Contemporary', 'Bilingual', 'Healing'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '9:30 AM',
          type: 'English Service',
          description: 'Contemporary worship in English',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '12:00 PM',
          type: 'Spanish Service',
          description: 'Servicio en Español',
        ),
        ServiceTime(
          dayOfWeek: 'Friday',
          time: '7:00 PM',
          type: 'Prayer & Healing',
          description: 'Prayer meeting with healing ministry',
        ),
      ],
      ministries: [
        'Hispanic Ministry',
        'Healing Ministry',
        'Youth Group',
        'Women\'s Circle',
        'Men\'s Fellowship'
      ],
      description:
          'A Spirit-filled church welcoming people from all backgrounds. We believe in the power of prayer, healing, and the gifts of the Holy Spirit.',
      distance: 8.2,
      rating: 4.9,
      reviewCount: 156,
      photos: ['pentecostal1.jpg', 'pentecostal2.jpg', 'pentecostal3.jpg'],
      hasChildcare: true,
      hasYouthProgram: true,
      isWheelchairAccessible: true,
      hasParking: true,
    ),
    Church(
      id: '5',
      name: 'Unity Christian Fellowship',
      denomination: 'Non-denominational',
      address: '555 Broadway',
      city: 'Tacoma',
      state: 'WA',
      zipCode: '98402',
      latitude: 47.2529,
      longitude: -122.4443,
      phoneNumber: '(253) 555-0555',
      website: 'https://unitychristian.org',
      email: 'connect@unitychristian.org',
      pastorName: 'Pastor Jennifer Brown',
      serviceTypes: ['Contemporary', 'Family', 'Outdoor'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '10:00 AM',
          type: 'Family Worship',
          description: 'All-ages worship with interactive elements',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '6:00 PM',
          type: 'Evening Gathering',
          description: 'Informal worship and discussion',
        ),
      ],
      ministries: [
        'Community Outreach',
        'Environmental Stewardship',
        'Artistic Expression',
        'Small Groups'
      ],
      description:
          'A diverse, creative community exploring faith through worship, art, and service. We emphasize God\'s love for all creation.',
      distance: 15.7,
      rating: 4.5,
      reviewCount: 63,
      photos: ['unity1.jpg'],
      hasChildcare: true,
      hasYouthProgram: true,
      isWheelchairAccessible: true,
      hasParking: true,
    ),
  ];

  static Future<List<Church>> searchChurches(String? location,
      {String? denomination,
      double maxDistance = 25.0,
      List<String> preferredServices = const []}) async {
    await Future.delayed(const Duration(milliseconds: 50));

    List<Church> results = List.from(_placeholderChurches);

    if (denomination != null && denomination.isNotEmpty) {
      results = results
          .where((church) => church.denomination
              .toLowerCase()
              .contains(denomination.toLowerCase()))
          .toList();
    }

    results =
        results.where((church) => church.distance <= maxDistance).toList();

    results.sort((a, b) => a.distance.compareTo(b.distance));

    return results;
  }

  static List<String> getDenominationOptions() {
    return [
      'Non-denominational',
      'Baptist',
      'Methodist',
      'Presbyterian',
      'Lutheran',
      'Pentecostal',
      'Catholic',
      'Episcopal',
      'Assemblies of God',
      'Christian Reformed',
      'Evangelical',
      'Orthodox',
    ];
  }

  static List<String> getServiceTypeOptions() {
    return [
      'Traditional',
      'Contemporary',
      'Liturgical',
      'Family-friendly',
      'Youth-oriented',
      'Bilingual',
      'Outdoor',
      'Online',
    ];
  }
}

