class FruitItem {
  final String name;
  final String image;
  final String sound;

  const FruitItem({
    required this.name,
    required this.image,
    required this.sound,
  });
}

const List<FruitItem> nurseryFruits = [
  FruitItem(
    name: 'Apple',
    image: 'assets/images/fruits/apple.png',
    sound: 'Apple',
  ),
  FruitItem(
    name: 'Banana',
    image: 'assets/images/fruits/banana.png',
    sound: 'Banana',
  ),
  FruitItem(
    name: 'Mango',
    image: 'assets/images/fruits/mango.png',
    sound: 'Mango',
  ),
  FruitItem(
    name: 'Orange',
    image: 'assets/images/fruits/orange.png',
    sound: 'Orange',
  ),
  FruitItem(
    name: 'Grapes',
    image: 'assets/images/fruits/grapes.png',
    sound: 'Grapes',
  ),
  FruitItem(
    name: 'Pineapple',
    image: 'assets/images/fruits/pineapple.png',
    sound: 'Pineapple',
  ),
  FruitItem(
    name: 'Strawberry',
    image: 'assets/images/fruits/strawberry.png',
    sound: 'Strawberry',
  ),
  FruitItem(
    name: 'Watermelon',
    image: 'assets/images/fruits/watermelon.png',
    sound: 'Watermelon',
  ),
];
