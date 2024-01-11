import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:presentation_displays_example/main.dart';

void main() async {
  await dotenv.load(fileName: "dev.env");
  mainProgram();
}

@pragma('vm:entry-point')
void secondaryDisplayMain() async {
  await dotenv.load(fileName: "dev.env");
  secondaryProgram();
}
