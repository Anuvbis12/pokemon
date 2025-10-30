class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String url;
  List<String>? types;
  List<Map<String, dynamic>>? stats;
  List<String>? abilities;
  int? height;
  int? weight;
  List<Map<String, dynamic>>? evolutions;
  String? evolutionChainUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.url,
    this.types,
    this.stats,
    this.abilities,
    this.height,
    this.weight,
    this.evolutions,
    this.evolutionChainUrl,
  }) : imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final urlParts = json['url'].split('/');
    final id = int.parse(urlParts[urlParts.length - 2]);
    return Pokemon(
      id: id,
      name: json['name'],
      url: json['url'],
    );
  }
}
