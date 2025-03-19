
class PrinterConfig {
  int id;
  String name; // Bar, Kitchen, Refrigerator, Service
  String type; // Network or Bluetooth
  String address; // IP address for network, MAC address for Bluetooth
  int textSize;
  int width;

  PrinterConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.textSize,
    required this.width,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'textSize': textSize,
      'width': width,
    };
  }

  // Convert from JSON
  factory PrinterConfig.fromJson(Map<String, dynamic> json) {
    return PrinterConfig(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      address: json['address'],
      textSize: json['textSize'],
      width: json['width'],
    );
  }
}
