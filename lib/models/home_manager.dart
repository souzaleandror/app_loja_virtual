import 'package:app_loja_virtual/models/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeManager extends ChangeNotifier {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  final List<Section> _sections = [];
  List<Section> _editingSections = [];

  List<Section> get sections {
    if (editing) {
      return _editingSections;
    } else {
      return _sections;
    }
  }

  HomeManager() {
    _loadAllSections();
  }

  bool editing = false;
  bool loading = false;

  Future<void> _loadAllSections() async {
    _firebase.collection('home').orderBy('pos').snapshots().listen((snapshot) {
      _sections.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        _sections.add(Section.fromDocument(document));
        debugPrint(_sections.toString());
      }
      debugPrint(_sections.toString());
    });
    notifyListeners();
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;

    /// TODO: VALIDACAO
    for (final section in _editingSections) {
      if (!section.valid()) valid = false;
    }

    if (!valid) return;
    loading = true;
    notifyListeners();
    int pos = 0;
    for (final section in _editingSections) {
      await section.save(pos);
      pos++;
    }

    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await section.delete();
      }
    }

    /// SALVAMENTO
    editing = false;
    loading = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }
}
