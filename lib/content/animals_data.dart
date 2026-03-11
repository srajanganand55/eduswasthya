class AnimalItem {
  final String name;
  final String image;
  final String sound;

  const AnimalItem({
    required this.name,
    required this.image,
    required this.sound,
  });
}

const List<AnimalItem> nurseryAnimals = [
  AnimalItem(
    name: 'Dog',
    image: 'assets/images/animals/dog.png',
    sound: 'Dog',
  ),
  AnimalItem(
    name: 'Cat',
    image: 'assets/images/animals/cat.png',
    sound: 'Cat',
  ),
  AnimalItem(
    name: 'Cow',
    image: 'assets/images/animals/cow.png',
    sound: 'Cow',
  ),
  AnimalItem(
    name: 'Lion',
    image: 'assets/images/animals/lion.png',
    sound: 'Lion',
  ),
  AnimalItem(
    name: 'Elephant',
    image: 'assets/images/animals/elephant.png',
    sound: 'Elephant',
  ),
  AnimalItem(
    name: 'Tiger',
    image: 'assets/images/animals/tiger.png',
    sound: 'Tiger',
  ),
  AnimalItem(
    name: 'Horse',
    image: 'assets/images/animals/horse.png',
    sound: 'Horse',
  ),
  AnimalItem(
    name: 'Monkey',
    image: 'assets/images/animals/monkey.png',
    sound: 'Monkey',
  ),
];
