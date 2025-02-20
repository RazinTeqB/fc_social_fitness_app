import 'package:edge_alerts/edge_alerts.dart';
import 'package:fc_social_fitness/utils/app_database.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image/image.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import '../constants/app_routes.dart';
import '../constants/app_sizes.constant.dart';
import '../constants/app_strings.dart';
import '../models/api_response.dart';
import '../models/dialog_data.model.dart';
import '../models/subscription.model.dart';
import '../models/user.model.dart' as user_model;
import '../repositories/auth.repository.dart';
import '../repositories/payment.repository.dart';
import '../repositories/subscription.repository.dart';
import '../social/core/functions/notifications_permissions.dart';
import '../utils/shared_manager.dart';
import '../views/widgets/custom_dialog.widget.dart';

class CustomBaseViewModel extends BaseViewModel {
  late BuildContext viewContext;
  DialogData dialogData = DialogData();
  final pageController = PageController(initialPage: 0);
  static BehaviorSubject<int> activeTab = BehaviorSubject<int>.seeded(0);
  user_model.User? currentUser;
  static user_model.User? statiCcurrentUser;

  final PaymentRepository paymentRepository = PaymentRepository();
  final AuthRepository authRepository = AuthRepository();
  final GlobalKey<ScaffoldState> videoCallscaffoldKey =
  GlobalKey<ScaffoldState>();
  static BehaviorSubject<int> numberOfMessage = BehaviorSubject<int>.seeded(0);

  double? price;

  Future initialise() async {
    setBusy(true);
    currentUser = await AppDatabase.getCurrentUser();
    CustomBaseViewModel.statiCcurrentUser = currentUser;
    imageCache.clear();
    imageCache.clearLiveImages();
    await notificationPermissions(viewContext);
    setBusy(false);
  }

  bool checkSubscription() {
    DateTime now = DateTime.now();

    if (currentUser!.subscriptions!.isNotEmpty) {
      if (currentUser!.subscriptions!.where((element) => now.isAfter(element.dueSubscriptionDate!)).isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  //
  void showAlert() {
    edgeAlert(viewContext,
        title: dialogData.title,
        description: dialogData.body,
        gravity: Gravity.top,
        icon: dialogData.iconData,
        backgroundColor: dialogData.dialogType == DialogType.failed
            ? FlutterFlowTheme.of(viewContext).error
            : FlutterFlowTheme.of(viewContext).success);
  }

  void showDialogAlert({
    required DialogData dialogData,
    Function? onPositivePressed,
    required bool isDismissible,
  }) {
    CustomDialog.showAlertDialog(viewContext, dialogData,
        isDismissible: isDismissible);
  }

  void showCustomDialogAlert({
    required Widget content,
    Function? onPositivePressed,
    required bool isDismissible,
  }) {
    CustomDialog.showCustomMaterialAlertDialog(viewContext,
        content: content, isDismissible: isDismissible);
  }

  showCustomBottomSheet(
      BuildContext context, {
        required Widget content,
        EdgeInsetsGeometry? contentPadding,
      }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: AppSizes.containerTopRadiusShape(),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      builder: (BuildContext bc) {
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.only(
                top: 15,
                right: 15,
                left: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: content,
          ),
        );
      },
    );
  }

  void updateCurrentPageIndex(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      curve: Curves.ease,
      duration: const Duration(
        microseconds: 10,
      ),
    );
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
    //return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future doLogout() async {
    setBusy(true);
    await AppDatabase.deleteCurrentUser();
    await AppDatabase.deleteCurrentUserModel();
    await AppDatabase.deleteAllTrainings();
    currentUser = null;
    await SharedManager.prefs?.setBool(AppStrings.authenticated, false);
    Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
    setBusy(false);
  }

  /*Future<void> initPaymentSheet(
      {required Function onSuccess, required Function onFail}) async {
    if (price != null) {
      var response = await paymentRepository.createPaymentSheet(
          viewContext,
          currentUser!.userData!.name!,
          currentUser!.email!,
          price!);

      if (response == null) {
        ScaffoldMessenger.of(viewContext)
            .showSnackBar(SnackBar(content: Text('Error: Response is null')));
        return;
      }

      if (response is ApiResponse) {
        if (response.allGood) {
          final data = response.body;
          try {
            BillingDetails billingDetails = BillingDetails(
              name: currentUser?.userData?.name,
              email: currentUser?.email,
              phone: currentUser?.phone,
              address: const Address(
                city: 'Aversa',
                country: 'IT',
                line1: 'via maiuri 22',
                line2: '',
                state: 'Caserta',
                postalCode: '81031',
              ),
            );

            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                customFlow: true,
                paymentIntentClientSecret: data['client_secret'],
                merchantDisplayName: 'FC Social Fitness',
                customerId: data['customer'],
                customerEphemeralKeySecret: data['ephemeralKey'],
                primaryButtonLabel: 'Paga Ora',
                /*applePay: const PaymentSheetApplePay(
                  merchantCountryCode: 'IT',
                ),
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'IT',
                  testEnv: true,
                ),*/
                style: MediaQuery.of(viewContext).platformBrightness ==
                    Brightness.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                appearance: const PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    background: Colors.lightBlue,
                    primary: Colors.blue,
                    componentBorder: Colors.red,
                  ),
                  shapes: PaymentSheetShape(
                    //borderWidth: 4,
                    shadow: PaymentSheetShadowParams(color: Colors.red),
                  ),
                  primaryButton: PaymentSheetPrimaryButtonAppearance(
                    shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
                    colors: PaymentSheetPrimaryButtonTheme(
                      light: PaymentSheetPrimaryButtonThemeColors(
                        background: Color.fromARGB(255, 231, 235, 30),
                        text: Color.fromARGB(255, 235, 92, 30),
                        border: Color.fromARGB(255, 235, 92, 30),
                      ),
                    ),
                  ),
                ),
                billingDetails: billingDetails,
              ),
            );
            confirmPayment(onSuccess, onFail);
          } catch (e) {
            ScaffoldMessenger.of(viewContext).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
            rethrow;
          }
        } else {
          ScaffoldMessenger.of(viewContext)
              .showSnackBar(SnackBar(content: Text('Error')));
        }
      } else {
        ScaffoldMessenger.of(viewContext)
            .showSnackBar(SnackBar(content: Text('Error: Invalid response type')));
      }
    } else {
      ScaffoldMessenger.of(viewContext)
          .showSnackBar(SnackBar(content: Text('Error')));
      return;
    }
  }*/

  /*Future<void> initPaymentSheet({
    required Function onSuccess,
    required Function onFail,
  }) async {
    if (price != null) {
      print('Creating payment sheet for price: $price');

      var response = await paymentRepository.createPaymentSheet(
        viewContext,
        currentUser!.userData!.name!,
        currentUser!.email!,
        price!,
      );

      if (response == null) {
        print('Error: Response is null');
        ScaffoldMessenger.of(viewContext).showSnackBar(
          SnackBar(content: Text('Error: Response is null')),
        );
        return;
      }

      if (response is ApiResponse) {
        print('ApiResponse: ${response.body}');
        if (response.allGood) {
          final data = response.body;
          try {
            BillingDetails billingDetails = BillingDetails(
              name: currentUser?.userData?.name,
              email: currentUser?.email,
              phone: currentUser?.phone,
              address: const Address(
                city: 'Aversa',
                country: 'IT',
                line1: 'via maiuri 22',
                line2: '',
                state: 'Caserta',
                postalCode: '81031',
              ),
            );

            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                customFlow: true,
                paymentIntentClientSecret: data['client_secret'],
                merchantDisplayName: 'FC Social Fitness',
                customerId: data['customer'],
                customerEphemeralKeySecret: data['ephemeralKey'],
                primaryButtonLabel: 'Paga Ora',
                style: MediaQuery.of(viewContext).platformBrightness == Brightness.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                appearance: const PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    background: Colors.lightBlue,
                    primary: Colors.blue,
                    componentBorder: Colors.red,
                  ),
                  shapes: PaymentSheetShape(
                    shadow: PaymentSheetShadowParams(color: Colors.red),
                  ),
                  primaryButton: PaymentSheetPrimaryButtonAppearance(
                    shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
                    colors: PaymentSheetPrimaryButtonTheme(
                      light: PaymentSheetPrimaryButtonThemeColors(
                        background: Color.fromARGB(255, 231, 235, 30),
                        text: Color.fromARGB(255, 235, 92, 30),
                        border: Color.fromARGB(255, 235, 92, 30),
                      ),
                    ),
                  ),
                ),
                billingDetails: billingDetails,
              ),
            );
            print('PaymentSheet initialized successfully');
            confirmPayment(onSuccess, onFail);
          } catch (e) {
            print('Error initializing PaymentSheet: $e');
            ScaffoldMessenger.of(viewContext).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
            rethrow;
          }
        } else {
          print('ApiResponse error: ${response.message}');
          ScaffoldMessenger.of(viewContext).showSnackBar(const SnackBar(content: Text('Error')));
        }
      } else {
        print('Unexpected response type');
        ScaffoldMessenger.of(viewContext).showSnackBar(const SnackBar(content: Text('Error: Invalid response type')));
      }
    } else {
      print('Error: Price is null');
      ScaffoldMessenger.of(viewContext).showSnackBar(const SnackBar(content: Text('Error')));
    }
  }*/
  Future<void> initPaymentSheet({
    required Subscription subscription,
    required Function onSuccess,
    required Function onFail,
  }) async {
    if (price != null) {
      try {
        print('Avvio per pagare: €$price');

        var response = await paymentRepository.createPaymentSheet(
          viewContext,
          currentUser!.userData!.name!,
          currentUser!.email!,
          price!,
        );
        if (response == null) {
          print('Error: Response is null');
          ScaffoldMessenger.of(viewContext).showSnackBar(
            SnackBar(content: Text('Error: Response is null')),
          );
          return;
        }
        if (response is ApiResponse) {
          if (response.allGood) {
            final data = response.body;
            print('PaymentIntent ID: ${data['paymentIntent']['id']}');
            print('Client Secret: ${data['paymentIntent']['client_secret']}');
            try {
              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: data['paymentIntent']['client_secret'],
                  merchantDisplayName: 'FC Social Fitness',
                  //customerId: data['customer'],
                  //customerEphemeralKeySecret: data['ephemeralKey'],
                  style: ThemeMode.system,
                  /*googlePay: const PaymentSheetGooglePay(
                    merchantCountryCode: 'IT',
                    testEnv: true,
                  ),
                  applePay: const PaymentSheetApplePay(
                    merchantCountryCode: 'IT',
                    //merchantIdentifier: 'merchant.com.fcsocialfitness',
                  ),*/
                ),
              );

              print('Inizializziamo la madonna puttana per il pagamento');
              //await Stripe.instance.presentPaymentSheet();
              print('La madonna puttana è  davanti ai tuoi occhi');
              await confirmPayment(subscription,onSuccess, onFail);
            } catch (e) {
              print('Errore del porco dio: $e');
              ScaffoldMessenger.of(viewContext).showSnackBar(
                SnackBar(content: Text('Errore durante la presentazione del PaymentSheet: $e')),
              );
              onFail();
            }

          } else {
            print('Error: ${response.errorMessage ?? response.message}');
            ScaffoldMessenger.of(viewContext).showSnackBar(
              SnackBar(content: Text('Error: ${response.errorMessage ?? response.message}')),
            );
            onFail();
          }
        } else {
          print('Unexpected response type');
          ScaffoldMessenger.of(viewContext).showSnackBar(
            SnackBar(content: Text('Error: Invalid response type')),
          );
          onFail();
        }
      } catch (e) {
        print('Errore inizializzazione o visione dello sheet: $e');
        ScaffoldMessenger.of(viewContext).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        onFail();
      }
    } else {
      print('Error: Price is null');
      ScaffoldMessenger.of(viewContext).showSnackBar(
        SnackBar(content: Text('Error: Price is null')),
      );
      onFail();
    }
  }

  Future<void> confirmPayment(Subscription subscription,Function onSuccess, Function onFail) async {
    try {
      print('Attempting to present payment sheet...');
      await Stripe.instance.presentPaymentSheet();
      print('Lo vediii?');
      int? subscriptionID = subscription.id;
      if (subscriptionID != null) {
        SubscriptionRepository subscriptionRepository = SubscriptionRepository();
        ApiResponse apiResponse = await subscriptionRepository.attachSubscription(viewContext, subscriptionID);
        if (apiResponse.allGood) {
          print('Abbonamento collegato con successo: ${apiResponse.body}');
          DateTime newDueDate = subscription.dueSubscriptionDate ?? DateTime.now().add(Duration(days: 30));
          ApiResponse resultResponse = await authRepository.updateUser(viewContext, {"due_subscription_date": newDueDate.toIso8601String(),});
          if (resultResponse.allGood) {
            await saveUserData(resultResponse.body["user"], currentUser!.token!);
            onSuccess();
          } else {
            print('Errore durante l\'aggiornamento dell\'utente: ${resultResponse.errorMessage}');
            onFail();
          }
        } else {
          print('Errore durante la chiamata API per collegare l\'abbonamento: ${apiResponse.errorMessage}');
          onFail();
        }
      } else {
        print('Errore: ID dell\'abbonamento non valido.');
        onFail();
      }
    } on Exception catch (e) {
      print('Errore durante la presentazione del payment sheet: $e');
      if (e is StripeException) {
        if (e.error.code != FailureCode.Canceled) {
          onFail();
        }
      } else {
        onFail();
      }
    }
  }

  Future saveUserData(dynamic userObject, String token) async {
    final mUser = user_model.User.formJson(userJSONObject: userObject);
    mUser.token = token;
    await AppDatabase.deleteCurrentUser();
    await AppDatabase.storeUser(mUser);
    SharedManager.prefs!.setBool(AppStrings.authenticated, true);
  }
}