import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_guide_app/core/constants/firebase_names.dart';
import 'package:my_guide_app/core/helpers/cache_helper.dart';
import 'package:my_guide_app/core/services/firestore_service.dart';
import 'package:my_guide_app/core/services/connectivity_service.dart';
import 'package:my_guide_app/models/place_model.dart';
import 'package:my_guide_app/repositories/abstract/i_place_repository.dart';

class PlaceRepository implements IPlaceRepository {
  final FirestoreService _firestore;
  final FirebaseStorage _storage;
  final ConnectivityService _connectivity;

  PlaceRepository(this._firestore, this._storage, this._connectivity);

  @override
  Stream<List<PlaceModel>> getPlacesStream({String? categoryId}) {
    List<QueryFilter> filters = [];
    if (categoryId != null) {
      filters.add(QueryFilter(FirestoreNames.fieldCategoryId, categoryId));
    }
    filters.add(QueryFilter(FirestoreNames.fieldVisible, true));
    return _firestore
        .streamCollection(
          FirestoreNames.collectionPlaces,
          orderBy: FirestoreNames.fieldCreatedDate,
          descending: true,
          filters: filters,
        )
        .map((snapshot) {
      final places = snapshot.docs.map((doc) => PlaceModel.fromFirestore(doc)).toList();
      _cachePlacesIfOnline(places);
      return places;
    });
  }

  Future<void> _cachePlacesIfOnline(List<PlaceModel> places) async {
    if (await _connectivity.isConnected()) {
      await CacheHelper.savePlaces(places);
    }
  }

  @override
  Future<List<PlaceModel>> getCachedPlaces() async {
    return CacheHelper.getPlaces();
  }

  @override
  Future<void> cachePlaces(List<PlaceModel> places) async {
    await CacheHelper.savePlaces(places);
  }

  @override
  Future<PlaceModel> addPlace(PlaceModel place, List<String> imageFiles) async {
    List<String> uploadedUrls = [];
    for (var filePath in imageFiles) {
      final ref = _storage.ref().child('${FirestoreNames.storagePlaces}${DateTime.now().millisecondsSinceEpoch}_$filePath');
      final file = File(filePath);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      uploadedUrls.add(url);
    }

    final newPlace = place.copyWith(
      images: uploadedUrls,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final docRef = await _firestore.addDocument(
      FirestoreNames.collectionPlaces,
      newPlace.toJson(),
    );
    return newPlace.copyWith(id: docRef.id);
  }

  @override
  Future<void> updatePlace(PlaceModel place) async {
    await _firestore.updateDocument(
      FirestoreNames.collectionPlaces,
      place.id!,
      place.toJson(),
    );
  }

  @override
  Future<void> deletePlace(String id) async {
    await _firestore.deleteDocument(FirestoreNames.collectionPlaces, id);
  }
}
