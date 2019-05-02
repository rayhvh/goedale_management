import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalModel extends Model{
  String _removeMe = "nothing";

  String get removeMe => _removeMe;


}