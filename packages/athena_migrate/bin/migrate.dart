import 'package:dcli/dcli.dart';

void main() {
  var name = ask('whats your name:', required: true, validator: Ask.alpha);
  print('Hello $name');
  
  print('Here is a list of your files');
  find('*').forEach(print);
  
}
