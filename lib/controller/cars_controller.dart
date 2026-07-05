import 'package:car_companion/controller/cars_list_data.dart';
import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/service/auth/auth_service.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:car_companion/service/notification/mileage_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'cars_controller.g.dart';

@riverpod
class CarsController extends _$CarsController { 

  final firestore = FirebaseFirestore.instance;



  @override
  FutureOr<void> build() {
    // void
  }

  // For using in the stream builder for detecting changes in login / logout
  Stream<User?> onAuthStateChange() {
    return ref.read(authServiceProvider.notifier).onAuthStateChange();
  }

  String? getUserId() {
    return ref.read(authServiceProvider.notifier).getUserId();
  }

  Future<void> login(String email, String password) async {
    await ref.read(authServiceProvider.notifier).login(email, password);
    // update the user's notification settings
    await ref.read(mileageNotificationServiceProvider.notifier).handleUserChange();
  }

  Future<void> logout() async {
    ref.read(authServiceProvider.notifier).logout();

    // erase all of the notifications for the device
    await ref.read(mileageNotificationServiceProvider.notifier).updateMessagingSettings("None");
  }

  Future<void> createAccount(String email, String password) async {
    ref.read(authServiceProvider.notifier).createAccount(email, password);
  }

  Future<void> deleteAccount(String password) async {
    ref.read(authServiceProvider.notifier).deleteAccount(password);
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final authRepository = ref.read(authServiceProvider.notifier);
    state = AsyncLoading();
    // ref.read(authServiceProvider.notifier).changePassword(oldPassword, newPassword);
    state = await AsyncValue.guard(() => authRepository.changePassword(oldPassword, newPassword));
    // await authRepository.changePassword(oldPassword, newPassword);
  }

  Future<void> editAccountDetails() async {
    // Possibly change username, profile picture, notification settings?
  }


  Future<void> saveNewInsurance(DateTime selectedExpirationDate, String providerText, String policyNumberText) async {
    // If the user selected a photo, get the downloadUrl, if not leave blank
    String downloadUrl = "";
    var file = ref.read(addPhotoProvider);
    if (file != null) {
      var filename = DateTime.now().millisecondsSinceEpoch.toString();
      // TODO: extract this out into controller/service/repository
      var photoRef = FirebaseStorage.instance.ref().child(filename);
      await photoRef.putFile(file);
      downloadUrl = await photoRef.getDownloadURL();
    }

    // Hand off to current car repository
    await ref.read(currentCarProvider.notifier).createInsurance(
        selectedExpirationDate,
        downloadUrl,
        providerText,
        policyNumberText);

    // Reset the addPhotoProvider  
    ref.read(addPhotoProvider.notifier).setImage(null);
  }


  Future<void> saveNewRegistration(DateTime selectedExpirationDate, String plateText, String stateText) async {
    // If the user selected a photo, get the downloadUrl, if not leave blank
    String downloadUrl = "";
    var file = ref.read(addPhotoProvider);
    if (file != null) {
      var filename = DateTime.now().millisecondsSinceEpoch.toString();
      // TODO: extract this out into controller/service/repository
      var photoRef = FirebaseStorage.instance.ref().child(filename);
      await photoRef.putFile(file);
      downloadUrl = await photoRef.getDownloadURL();
    }

    // Hand off to current car repository
    await ref.read(currentCarProvider.notifier).createRegistration(
        selectedExpirationDate,
        downloadUrl,
        plateText,
        stateText);

    // Reset the addPhotoProvider  
    ref.read(addPhotoProvider.notifier).setImage(null);
  }


  Future<void> saveNewCar(String nicknameText, String vinText, String yearText, String makeText, String modelText, String colorText, int mileage) async {
    // Save the Photo with the car id as the image name
    var file = ref.read(addPhotoProvider);
    if (file == null) {
      return;
    }
    var filename = DateTime.now().millisecondsSinceEpoch.toString();
    var photoRef = FirebaseStorage.instance.ref().child(filename);
    await photoRef.putFile(file);
    var downloadUrl = await photoRef.getDownloadURL();

    print("Calling createCar()");

    // Save the car with the photo download URL
    await ref.read(asyncCarsListDataProvider.notifier).createCar(
        downloadUrl,
        nicknameText,
        vinText,
        yearText,
        makeText,
        modelText,
        colorText,
        mileage);
    
    // Reset the add photo
    ref.read(addPhotoProvider.notifier).setImage(null);
  }

  Future<void> deleteRegistration(String registrationId, String carId) async {
    // Delete the registration object
    await ref.read(currentCarProvider.notifier).deleteRegistration(registrationId, carId);

    // Delete the registration Id from the Car object
    await ref.read(currentCarProvider.notifier).updateCurrentCar(carId, registrationId: "");
  }

  Future<void> deleteInsurance(String insuranceId, String carId) async {
    // Delete the insurance object
    await ref.read(currentCarProvider.notifier).deleteInsurance(insuranceId, carId);

    // Delete the insurance Id from the Car object
    await ref.read(currentCarProvider.notifier).updateCurrentCar(carId, insuranceId: "");
  }

  Future<void> saveNewMaintenanceRecord(String description, String moreDetails, DateTime date, String type) async {
    await ref.read(currentCarProvider.notifier).createMaintenanceRecord(description, moreDetails, date, type);
  }





}