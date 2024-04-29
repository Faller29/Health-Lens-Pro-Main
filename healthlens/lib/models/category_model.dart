import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String imageUrl;

  Category({
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [name, imageUrl];

  static List<Category> categories = [
    Category(
        name: 'Egg',
        imageUrl:
            'https://images.unsplash.com/photo-1498654077810-12c21d4d6dc3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxlZ2dzfGVufDB8fHx8MTcxNDI5ODQ1OXww&ixlib=rb-4.0.3&q=80&w=1080'),
    Category(
        name: 'Apple',
        imageUrl:
            'https://images.unsplash.com/photo-1584306670957-acf935f5033c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw5fHxhcHBsZXxlbnwwfHx8fDE3MTQyMTk4NzR8MA&ixlib=rb-4.0.3&q=80&w=1080'),
    Category(
        name: 'Banana',
        imageUrl:
            'https://images.unsplash.com/photo-1587132137056-bfbf0166836e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxiYW5hbmF8ZW58MHx8fHwxNzE0MzAyMTMwfDA&ixlib=rb-4.0.3&q=80&w=1080'),
    Category(
        name: 'Milk',
        imageUrl:
            'https://images.unsplash.com/photo-1550583724-b2692b85b150?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxtaWxrfGVufDB8fHx8MTcxNDMwMjE4OXww&ixlib=rb-4.0.3&q=80&w=1080'),
  ];
}
