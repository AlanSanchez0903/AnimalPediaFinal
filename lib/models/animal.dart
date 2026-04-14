class AnimalModel {
  const AnimalModel({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.descripcion,
    required this.habitat,
    required this.dieta,
    required this.latitud,
    required this.longitud,
    required this.imagenUrl,
    required this.descubierto,
    required this.bioma,
    required this.pais,
  });

  final String id;
  final String nombre;
  final String nombreCientifico;
  final String descripcion;
  final String habitat;
  final String dieta;
  final double latitud;
  final double longitud;
  final String imagenUrl;
  final bool descubierto;
  final String bioma;
  final String pais;

  // Alias para mantener compatibilidad con pantallas existentes.
  String get name => nombre;
  String get scientificName => nombreCientifico;
  String get description => descripcion;
  String get imagePath => imagenUrl;

  AnimalModel copyWith({
    String? id,
    String? nombre,
    String? nombreCientifico,
    String? descripcion,
    String? habitat,
    String? dieta,
    double? latitud,
    double? longitud,
    String? imagenUrl,
    bool? descubierto,
    String? bioma,
    String? pais,
  }) {
    return AnimalModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      nombreCientifico: nombreCientifico ?? this.nombreCientifico,
      descripcion: descripcion ?? this.descripcion,
      habitat: habitat ?? this.habitat,
      dieta: dieta ?? this.dieta,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      descubierto: descubierto ?? this.descubierto,
      bioma: bioma ?? this.bioma,
      pais: pais ?? this.pais,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'nombreCientifico': nombreCientifico,
      'descripcion': descripcion,
      'habitat': habitat,
      'dieta': dieta,
      'latitud': latitud,
      'longitud': longitud,
      'imagenUrl': imagenUrl,
      'descubierto': descubierto,
      'bioma': bioma,
      'pais': pais,
    };
  }

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      nombreCientifico: json['nombreCientifico']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      habitat: json['habitat']?.toString() ?? '',
      dieta: json['dieta']?.toString() ?? '',
      latitud: (json['latitud'] as num?)?.toDouble() ?? 0,
      longitud: (json['longitud'] as num?)?.toDouble() ?? 0,
      imagenUrl: json['imagenUrl']?.toString() ?? '',
      descubierto: json['descubierto'] as bool? ?? false,
      bioma: json['bioma']?.toString() ?? '',
      pais: json['pais']?.toString() ?? '',
    );
  }

}

typedef Animal = AnimalModel;
