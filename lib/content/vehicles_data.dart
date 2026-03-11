class VehicleItem {
  final String name;
  final String image;
  final String sound;

  const VehicleItem({
    required this.name,
    required this.image,
    required this.sound,
  });
}

const List<VehicleItem> nurseryVehicles = [
  VehicleItem(
    name: 'Car',
    image: 'assets/images/vehicles/car.png',
    sound: 'Car',
  ),
  VehicleItem(
    name: 'Bus',
    image: 'assets/images/vehicles/bus.png',
    sound: 'Bus',
  ),
  VehicleItem(
    name: 'Truck',
    image: 'assets/images/vehicles/truck.png',
    sound: 'Truck',
  ),
  VehicleItem(
    name: 'Bicycle',
    image: 'assets/images/vehicles/bicycle.png',
    sound: 'Bicycle',
  ),
  VehicleItem(
    name: 'Motorcycle',
    image: 'assets/images/vehicles/motorcycle.png',
    sound: 'Motorcycle',
  ),
  VehicleItem(
    name: 'Train',
    image: 'assets/images/vehicles/train.png',
    sound: 'Train',
  ),
  VehicleItem(
    name: 'Airplane',
    image: 'assets/images/vehicles/airplane.png',
    sound: 'Airplane',
  ),
  VehicleItem(
    name: 'Boat',
    image: 'assets/images/vehicles/boat.png',
    sound: 'Boat',
  ),
  VehicleItem(
    name: 'Ambulance',
    image: 'assets/images/vehicles/ambulance.png',
    sound: 'Ambulance',
  ),
  VehicleItem(
    name: 'Fire Truck',
    image: 'assets/images/vehicles/fire_truck.png',
    sound: 'Fire Truck',
  ),
];
