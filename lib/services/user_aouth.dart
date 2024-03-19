import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uzayprojesi/util/model/anket_model.dart';
import 'package:uzayprojesi/util/model/user_model.dart';

class FirebaseServices with ChangeNotifier {
//DEğişkenler ve veri t abanı çağırımları burada olacak

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

//   K A Y I T
  Future<UserModel?> userKayit() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google ile giriş başarısız');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final UserModel? userModel = _userCredentialToUserModel(userCredential);
      if (userModel == null) {
        throw Exception('Kullanıcı bilgileri alınamadı');
      } else {
        userKayitVeritabi(userModel);
        return userModel;
      }
    } catch (e) {
      debugPrint('Kullanıcı girişi sırasında bir hata oluştu: $e');
      return null;
    }
  }

  Future<void> userKayitVeritabi(UserModel userModel) async {
    var userDoc = firestore.collection('users').doc(userModel.userID);
    var userDocSnapshot = await userDoc.get();

    if (userDocSnapshot.exists) {
      // Kullanıcı zaten mevcut, verileri güncelle
    } else {
      // Kullanıcı yok, yeni kullanıcıyı kaydet
      await userDoc.set(userModel.toMap());
    }
  }

//  U P D A T E
  Future<void> userUpdate(UserModel userModel) async {
    await firestore
        .collection('users')
        .doc(userModel.userID)
        .set(userModel.toMap());
  }

//  S T R E A M
  Stream<UserModel> get onOuthStateChange => firebaseAuth
      .authStateChanges()
      .map((user) => _convertUserUserModel(user));

//  Ç I K I Ş
  Future<void> outUser() async {
    firebaseAuth.signOut();
  }

  Future<UserModel?> getUserModel() async {
    var userModel = firebaseAuth.currentUser;
    if (userModel == null) {
      throw Exception('Firebase kullanıcı bilgisi alınamadı');
    }

    final userSnapshot =
        await firestore.collection('users').doc(userModel.uid).get();

    if (userSnapshot.exists) {
      final data = userSnapshot.data();
      if (data != null) {
        final UserModel kayitliUser = UserModel.fromMap(data);
        return kayitliUser;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> updateUserModel(UserModel updatedUserModel) async {
    var userModel = firebaseAuth.currentUser;
    if (userModel == null) {
      throw Exception('Firebase kullanıcı bilgisi alınamadı');
    }

    try {
      await firestore
          .collection('users')
          .doc(userModel.uid)
          .set(updatedUserModel.toMap());
    } catch (e) {
      throw Exception('Kullanıcı bilgileri güncellenirken bir hata oluştu: $e');
    }
  }

//  Bir userın verisini stream dinleme

  Stream<UserModel> listenToActiveUser(String userID) {
    return firestore
        .collection('users')
        .doc(userID)
        .snapshots()
        .map((snapshot) {
      // Firestore'dan gelen belgeyi UserModel'e dönüştür
      return UserModel.fromMap(snapshot.data() ?? {});
    });
  }

  Future<void> updateUserTel(String userID, String tel) async {
    try {
      await firestore.collection('users').doc(userID).update({
        'tel': tel,
      });
    } catch (e) {
      debugPrint('Kullanıcı TELEFON güncellenirken bir hata oluştu: $e');
    }
  }

  Future<void> updateUserPuanForVatandaslikTuru(
      String userID, UserModel userModel) async {
    try {
      // Kullanıcı daha önce vatandaşlık türü girmemişse puanı artır
      if (userModel.vatandaslikTuru.isEmpty ||
          userModel.vatandaslikTuru == '') {
        await firestore.collection('users').doc(userID).update({
          'puan': userModel.puan + 100,
        });
      }
    } catch (e) {
      debugPrint('Kullanıcı puanı güncellenirken bir hata oluştu: $e');
    }
  }

  Future<void> updateUserPuan(
      String userID, int yeniPuan, int oncekiPuan) async {
    try {
      await firestore.collection('users').doc(userID).update({
        'puan': oncekiPuan + yeniPuan,
      });
    } catch (e) {
      debugPrint('Kullanıcı puan güncellenirken bir hata oluştu: $e');
    }
  }

  Future<void> updateUserUlke(String userID, String ulke) async {
    try {
      await firestore.collection('users').doc(userID).update({
        'vatandaslikTuru': ulke,
      });
    } catch (e) {
      debugPrint('Kullanıcı TELEFON güncellenirken bir hata oluştu: $e');
    }
  }

  Future<List<UserModel>> getUsers() async {
    // Firestore'dan tüm kullanıcıları getir
    QuerySnapshot querySnapshot = await firestore.collection('users').get();
    List<UserModel> users = querySnapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()! as Map<String, dynamic>))
        .toList();
    return users;
  }

  Future<void> updateUser(UserModel user) async {
    // Kullanıcıyı Firestore'da güncelle
    await firestore.collection('users').doc(user.userID).update(user.toMap());
  }

//!ANKET
  Future<void> saveAnket(AnketModel anket) async {
    try {
      // Anketi Firestore'a kaydet
      await firestore
          .collection('anketler')
          .doc(anket.anketID)
          .set(anket.toMap());

      // Tüm kullanıcıları getir
      List<UserModel> users = await getUsers();

      // Her bir kullanıcının bekleyenAnket listesine yeni anketi ekle
      for (var user in users) {
        user.bekleyenAnket.add(anket);
        await updateUser(user);
      }
    } catch (e) {
      debugPrint('Anket kaydedilirken bir hata oluştu: $e');
    }
  }

  // Tüm anketleri çekme
  Future<List<AnketModel>> getAnketler() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('anketler').get();
      return querySnapshot.docs
          .map((doc) => AnketModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // Hata durumunda boş bir liste döndürülebilir veya hata işlenebilir.
      debugPrint('Anketleri getirirken hata oluştu: $e');
      return [];
    }
  }

  // Tüm anketleri stream olarak getirme
  Stream<List<AnketModel>> getAnketlerStream() {
    return firestore.collection('anketler').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AnketModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Anket güncelleme
  Future<void> updateAnket(AnketModel anket) async {
    try {
      await firestore
          .collection('anketler')
          .doc(anket.anketID)
          .update(anket.toMap());
    } catch (e) {
      debugPrint('Anket güncellenirken bir hata oluştu: $e');
    }
  }

  // Anket silme
  Future<void> deleteAnket(String anketID) async {
    try {
      await firestore.collection('anketler').doc(anketID).delete();
    } catch (e) {
      debugPrint('Anket silinirken bir hata oluştu: $e');
    }
  }
}

//!  B U R A D A         S E R V İ S    K O D L A R I
//!  D I Ş I N D A K İ   K O D L A R    O L A C A K
//gelen userCredantrıl'ı benim usermodelime çevirecek
UserModel? _userCredentialToUserModel(UserCredential? userCredential) {
  if (userCredential == null) return null;

  final User? user = userCredential.user;
  if (user == null) return null;

  return UserModel(
    puan: 0,
    userID: user.uid,
    userName: user.displayName ?? '',
    mail: user.email ?? 'mail çekilemedi',
    photoURL: user.photoURL ?? '',
  );
}

//Firebaseden gelen user moderlini kendi Usermodelimiz'e çevirme

UserModel _convertUserUserModel(User? user) {
  return UserModel(
    userID: user!.uid,
    mail: user.email.toString(),
    puan: 0,
  );
}
