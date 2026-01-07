class AdminRoom {
  final String id;
  final String name;
  final String type;      // Amphithéâtre, TD, Laboratoire, Bureau, Salle de réunion
  final int capacity;
  final String status;    // available, occupied, maintenance, reserved
  final bool hasProjector;
  final bool hasComputers;
  final bool hasAirConditioning;
  final int floor;
  final String building;
  final List<Equipment> equipment;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminRoom({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.status,
    required this.hasProjector,
    required this.hasComputers,
    required this.hasAirConditioning,
    required this.floor,
    required this.building,
    required this.equipment,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminRoom.fromJson(Map<String, dynamic> json) {
    return AdminRoom(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'TD',
      capacity: json['capacity'] is int ? json['capacity'] : int.tryParse(json['capacity']?.toString() ?? '30') ?? 30,
      status: json['status'] ?? 'available',
      hasProjector: json['hasProjector'] ?? false,
      hasComputers: json['hasComputers'] ?? false,
      hasAirConditioning: json['hasAirConditioning'] ?? false,
      floor: json['floor'] is int ? json['floor'] : int.tryParse(json['floor']?.toString() ?? '1') ?? 1,
      building: json['building'] ?? '',
      equipment: (json['equipment'] as List? ?? [])
          .map((e) => Equipment.fromJson(e))
          .toList(),
      description: json['description'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'capacity': capacity,
      'status': status,
      'hasProjector': hasProjector,
      'hasComputers': hasComputers,
      'hasAirConditioning': hasAirConditioning,
      'floor': floor,
      'building': building,
      'equipment': equipment.map((e) => e.toJson()).toList(),
      'description': description,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  String get displayStatus {
    switch (status) {
      case 'available':
        return 'Libre';
      case 'occupied':
        return 'Occupée';
      case 'maintenance':
        return 'Maintenance';
      case 'reserved':
        return 'Réservée';
      default:
        return status;
    }
  }
}

class Equipment {
  final String name;
  final int quantity;
  final String status; // working, broken, maintenance

  Equipment({
    required this.name,
    required this.quantity,
    required this.status,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      status: json['status'] ?? 'working',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'status': status,
    };
  }

  String get displayStatus {
    switch (status) {
      case 'working':
        return 'Fonctionnel';
      case 'broken':
        return 'En panne';
      case 'maintenance':
        return 'En maintenance';
      default:
        return status;
    }
  }
}
