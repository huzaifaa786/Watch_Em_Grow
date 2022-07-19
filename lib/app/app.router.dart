// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/app_user.dart';
import '../models/book_service.dart';
import '../models/order.dart';
import '../models/shop.dart';
import '../models/shop_service.dart';
import '../ui/auth/buyer_signup/buyer_signup_view.dart';
import '../ui/auth/buyer_signup/email_verify.dart';
import '../ui/auth/buyer_signup/profile_update.dart';
import '../ui/auth/login/discover_page.dart';
import '../ui/auth/login/forgot_password_view.dart';
import '../ui/auth/login/login_view.dart';
import '../ui/auth/seller_signup/seller_signup_view.dart';
import '../ui/booking/booking_view.dart';
import '../ui/category/category_view.dart';
import '../ui/category/filter/category_filter_view.dart';
import '../ui/chats/chats_view.dart';
import '../ui/chats/messages/messages_view.dart';
import '../ui/follow/followers/followers_view.dart';
import '../ui/follow/following/following_view.dart';
import '../ui/landing/landing_view.dart';
import '../ui/main/main_view.dart';
import '../ui/profile/buyer/editProfile/buyer_edit_profile.view.dart';
import '../ui/profile/buyer/buyer_profile_view.dart';
import '../ui/profile/buyer/paypal_verification_view.dart';
import '../ui/profile/seller/editProfile/seller_edit_profile.view.dart';
import '../ui/profile/seller/seller_profile_view.dart';
import '../ui/quick_settings/earnings/earnings_view.dart';
import '../ui/quick_settings/orders/orderdetail_view.dart';
import '../ui/quick_settings/orders/orders_view.dart';
import '../ui/service/bookservice_view.dart';
import '../ui/service/buyservice_view.dart';
import '../ui/service/create_service_view.dart';
import '../ui/service/inputaddress_view.dart';
import '../ui/service/order_success_view.dart';
import '../ui/service/service_view.dart';
import '../ui/settings/about/about_view.dart';
import '../ui/settings/help/help_view.dart';
import '../ui/settings/privacy/privacy_policy_view.dart';
import '../ui/settings/settings_view.dart';
import '../ui/settings/terms/terms_and_conditions_view.dart';
import '../ui/shop/create_shop_view.dart';
import '../ui/shop/editShop/edit_shop_view.dart';
import '../ui/startup/startup_view.dart';
import '../ui/contact_us/contact_us_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String landingView = '/landing-view';
  static const String buyerSignupView = '/buyer-signup-view';
  static const String loginView = '/login-view';
  static const String forgotPasswordView = '/forgot-password-view';
  static const String emailVerify = '/email-verify';
  static const String mainView = '/main-view';
  static const String discoverPage = '/discover-page';
  static const String buyerEditProfileView = '/buyer-edit-profile-view';
  static const String buyerProfileView = '/buyer-profile-view';
  static const String paypalVerificationView = '/paypal-verification-view';
  static const String sellerEditProfileView = '/seller-edit-profile-view';
  static const String sellerProfileView = '/seller-profile-view';
  static const String sellerSignupView = '/seller-signup-view';
  static const String createShopView = '/create-shop-view';
  static const String editShopView = '/edit-shop-view';
  static const String createServiceView = '/create-service-view';
  static const String serviceView = '/service-view';
  static const String profileUpdate = '/profile-update';
  static const String buyServiceView = '/buy-service-view';
  static const String categoryView = '/category-view';
  static const String categoryFilterView = '/category-filter-view';
  static const String settingsView = '/settings-view';
  static const String contactUs = '/contactUs-view';
  static const String chatsView = '/chats-view';
  static const String followersView = '/followers-view';
  static const String followingView = '/following-view';
  static const String messagesView = '/messages-view';
  static const String earningsView = '/earnings-view';
  static const String ordersView = '/orders-view';
  static const String ordersBuyerView = '/orders-buyer-view';
  static const String orderDetailView = '/order-detail-view';
  static const String termsAndConditionsView = '/terms-and-conditions-view';
  static const String privacyPolicyView = '/privacy-policy-view';
  static const String aboutView = '/about-view';
  static const String helpView = '/help-view';
  static const String inputAddressView = '/input-address-view';
  static const String orderSuccessView = '/order-success-view';
  static const String bookServiceView = '/book-service-view';
  static const String bookingView = '/booking-view';
  static const all = <String>{
    startUpView,
    landingView,
    buyerSignupView,
    loginView,
    forgotPasswordView,
    emailVerify,
    mainView,
    discoverPage,
    buyerEditProfileView,
    buyerProfileView,
    paypalVerificationView,
    sellerEditProfileView,
    sellerProfileView,
    sellerSignupView,
    createShopView,
    editShopView,
    createServiceView,
    serviceView,
    profileUpdate,
    buyServiceView,
    categoryView,
    categoryFilterView,
    settingsView,
    contactUs,
    chatsView,
    followersView,
    followingView,
    messagesView,
    earningsView,
    ordersView,
    ordersBuyerView,
    orderDetailView,
    termsAndConditionsView,
    privacyPolicyView,
    aboutView,
    helpView,
    inputAddressView,
    orderSuccessView,
    bookServiceView,
    bookingView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.landingView, page: LandingView),
    RouteDef(Routes.buyerSignupView, page: BuyerSignupView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.forgotPasswordView, page: ForgotPasswordView),
    RouteDef(Routes.emailVerify, page: EmailVerify),
    RouteDef(Routes.mainView, page: MainView),
    RouteDef(Routes.discoverPage, page: DiscoverPage),
    RouteDef(Routes.buyerEditProfileView, page: BuyerEditProfileView),
    RouteDef(Routes.buyerProfileView, page: BuyerProfileView),
    RouteDef(Routes.paypalVerificationView, page: PaypalVerificationView),
    RouteDef(Routes.sellerEditProfileView, page: SellerEditProfileView),
    RouteDef(Routes.sellerProfileView, page: SellerProfileView),
    RouteDef(Routes.sellerSignupView, page: SellerSignupView),
    RouteDef(Routes.createShopView, page: CreateShopView),
    RouteDef(Routes.editShopView, page: EditShopView),
    RouteDef(Routes.createServiceView, page: CreateServiceView),
    RouteDef(Routes.serviceView, page: ServiceView),
    RouteDef(Routes.profileUpdate, page: ProfileUpdate),
    RouteDef(Routes.buyServiceView, page: BuyServiceView),
    RouteDef(Routes.categoryView, page: CategoryView),
    RouteDef(Routes.categoryFilterView, page: CategoryFilterView),
    RouteDef(Routes.settingsView, page: SettingsView),
    RouteDef(Routes.contactUs, page: ContactUsView),
    RouteDef(Routes.chatsView, page: ChatsView),
    RouteDef(Routes.followersView, page: FollowersView),
    RouteDef(Routes.followingView, page: FollowingView),
    RouteDef(Routes.messagesView, page: MessagesView),
    RouteDef(Routes.earningsView, page: EarningsView),
    RouteDef(Routes.ordersView, page: OrdersView),
    RouteDef(Routes.ordersBuyerView, page: OrdersView),
    RouteDef(Routes.orderDetailView, page: OrderDetailView),
    RouteDef(Routes.termsAndConditionsView, page: TermsAndConditionsView),
    RouteDef(Routes.privacyPolicyView, page: PrivacyPolicyView),
    RouteDef(Routes.aboutView, page: AboutView),
    RouteDef(Routes.helpView, page: HelpView),
    RouteDef(Routes.inputAddressView, page: InputAddressView),
    RouteDef(Routes.orderSuccessView, page: OrderSuccessView),
    RouteDef(Routes.bookServiceView, page: BookServiceView),
    RouteDef(Routes.bookingView, page: BookingView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    LandingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LandingView(),
        settings: data,
      );
    },
    BuyerSignupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const BuyerSignupView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LoginView(),
        settings: data,
      );
    },
    ForgotPasswordView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ForgotPasswordView(),
        settings: data,
      );
    },
    EmailVerify: (data) {
      var args = data.getArgs<EmailVerifyArguments>(
        orElse: () => EmailVerifyArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => EmailVerify(
          key: args.key,
          code: args.code,
          email: args.email,
        ),
        settings: data,
      );
    },
    MainView: (data) {
      var args = data.getArgs<MainViewArguments>(
        orElse: () => MainViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => MainView(
          key: args.key,
          selectedIndex: args.selectedIndex,
        ),
        settings: data,
      );
    },
    DiscoverPage: (data) {
      var args = data.getArgs<DiscoverPageArguments>(
        orElse: () => DiscoverPageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => DiscoverPage(key: args.key),
        settings: data,
      );
    },
    BuyerEditProfileView: (data) {
      var args = data.getArgs<BuyerEditProfileViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BuyerEditProfileView(
          key: args.key,
          user: args.user,
        ),
        settings: data,
      );
    },
    PaypalVerificationView: (data) {
      var args = data.getArgs<PaypalVerificationViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => PaypalVerificationView(
          key: args.key,
          email: args.email,
        ),
        settings: data,
      );
    },

    SellerEditProfileView: (data) {
      var args = data.getArgs<SellerEditProfileViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SellerEditProfileView(
          key: args.key,
          user: args.user,
        ),
        settings: data,
      );
    },
    SellerProfileView: (data) {
      var args = data.getArgs<SellerProfileViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SellerProfileView(
          key: args.key,
          seller: args.seller,
          viewingAsProfile: args.viewingAsProfile,
        ),
        settings: data,
      );
    },
    BuyerProfileView: (data) {
      var args = data.getArgs<BuyerProfileViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BuyerProfileView(
          key: args.key,
          user: args.user,
          viewingAsProfile: args.viewingAsProfile,
        ),
        settings: data,
      );
    },
    SellerSignupView: (data) {
      var args = data.getArgs<SellerSignupViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SellerSignupView(
          key: args.key,
          user: args.user,
        ),
        settings: data,
      );
    },
    CreateShopView: (data) {
      var args = data.getArgs<CreateShopViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreateShopView(
          key: args.key,
          user: args.user,
        ),
        settings: data,
      );
    },
    EditShopView: (data) {
      var args = data.getArgs<EditShopViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditShopView(
          key: args.key,
          shop: args.shop,
        ),
        settings: data,
      );
    },
    CreateServiceView: (data) {
      var args = data.getArgs<CreateServiceViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreateServiceView(
          key: args.key,
          user: args.user,
          shop: args.shop,
        ),
        settings: data,
      );
    },
    ServiceView: (data) {
      var args = data.getArgs<ServiceViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ServiceView(
          key: args.key,
          service: args.service,
          color: args.color,
          fontStyle: args.fontStyle,
        ),
        settings: data,
      );
    },
    ProfileUpdate: (data) {
      var args = data.getArgs<ProfileUpdateArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProfileUpdate(
          key: args.key,
          user: args.user,
        ),
        settings: data,
      );
    },
    BuyServiceView: (data) {
      var args = data.getArgs<BuyServiceViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BuyServiceView(
          key: args.key,
          user: args.user,
          service: args.service,
          selectedSize: args.selectedSize,
        ),
        settings: data,
      );
    },
    CategoryView: (data) {
      var args = data.getArgs<CategoryViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CategoryView(
          key: args.key,
          category: args.category,
          categoryShops: args.categoryShops,
          allOtherShops: args.allOtherShops,
          allSellers: args.allSellers,
          allServices: args.allServices,
        ),
        settings: data,
      );
    },
    CategoryFilterView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const CategoryFilterView(),
        settings: data,
      );
    },
    SettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SettingsView(),
        settings: data,
      );
    },
    ContactUsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ContactUsView(),
        settings: data,
      );
    },
    ChatsView: (data) {
      var args = data.getArgs<ChatsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatsView(
          key: args.key,
          currentUser: args.currentUser,
          onMainView: args.onMainView,
        ),
        settings: data,
      );
    },
    FollowersView: (data) {
      var args = data.getArgs<FollowersViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => FollowersView(
          key: args.key,
          sellerId: args.sellerId,
        ),
        settings: data,
      );
    },
    FollowingView: (data) {
      var args = data.getArgs<FollowingViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => FollowingView(
          key: args.key,
          sellerId: args.sellerId,
        ),
        settings: data,
      );
    },
    MessagesView: (data) {
      var args = data.getArgs<MessagesViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => MessagesView(
          key: args.key,
          currentUser: args.currentUser,
          receiver: args.receiver,
        ),
        settings: data,
      );
    },
    EarningsView: (data) {
      var args = data.getArgs<EarningsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => EarningsView(
          key: args.key,
          user: args.user,
        ),
        settings: data,
      );
    },
    OrdersView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => OrdersView(),
        settings: data,
      );
    },
    OrderDetailView: (data) {
      var args = data.getArgs<OrderDetailViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => OrderDetailView(
          key: args.key,
          order: args.order,
          color: args.color,
          fontStyle: args.fontStyle,
          currentUser: args.currentUser,
        ),
        settings: data,
      );
    },
    TermsAndConditionsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const TermsAndConditionsView(),
        settings: data,
      );
    },
    PrivacyPolicyView: (data) {
      var args = data.getArgs<PrivacyPolicyViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => PrivacyPolicyView(
          key: args.key,
          url: args.url,
        ),
        settings: data,
      );
    },
    AboutView: (data) {
      var args = data.getArgs<AboutViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => AboutView(
          key: args.key,
          url: args.url,
        ),
        settings: data,
      );
    },
    HelpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HelpView(),
        settings: data,
      );
    },
    InputAddressView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => InputAddressView(),
        settings: data,
      );
    },
    OrderSuccessView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => OrderSuccessView(),
        settings: data,
      );
    },
    BookServiceView: (data) {
      var args = data.getArgs<BookServiceViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BookServiceView(
          key: args.key,
          user: args.user,
          bookingservice: args.bookingservice,
          //order: args.order,
          service: args.service,
        ),
        settings: data,
      );
    },
    BookingView: (data) {
      var args = data.getArgs<BookingViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BookingView(
          key: args.key,
          user: args.user,
          //order: args.order,
          service: args.service,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// EmailVerify arguments holder class
class EmailVerifyArguments {
  final Key? key;
  final dynamic code;
  final dynamic email;
  EmailVerifyArguments({this.key, this.code, this.email});
}

/// MainView arguments holder class
class MainViewArguments {
  final Key? key;
  final int selectedIndex;
  MainViewArguments({this.key, this.selectedIndex = 0});
}

/// DiscoverPage arguments holder class
class DiscoverPageArguments {
  final Key? key;
  DiscoverPageArguments({this.key});
}

/// BuyerEditProfileView arguments holder class
class BuyerEditProfileViewArguments {
  final Key? key;
  final AppUser user;
  BuyerEditProfileViewArguments({this.key, required this.user});
}

class BuyerProfileViewArguments {
  final Key? key;
  final AppUser user;
  final bool? viewingAsProfile;
  BuyerProfileViewArguments({this.key, required this.user, this.viewingAsProfile});
}

class PaypalVerificationViewArguments {
  final Key? key;
  final String email;
  PaypalVerificationViewArguments({this.key, required this.email});
}

/// SellerEditProfileView arguments holder class
class SellerEditProfileViewArguments {
  final Key? key;
  final AppUser user;
  SellerEditProfileViewArguments({this.key, required this.user});
}

/// SellerProfileView arguments holder class
class SellerProfileViewArguments {
  final Key? key;
  final AppUser seller;
  final bool? viewingAsProfile;
  SellerProfileViewArguments(
      {this.key, required this.seller, this.viewingAsProfile});
}

/// SellerSignupView arguments holder class
class SellerSignupViewArguments {
  final Key? key;
  final AppUser user;
  SellerSignupViewArguments({this.key, required this.user});
}

/// CreateShopView arguments holder class
class CreateShopViewArguments {
  final Key? key;
  final AppUser user;
  CreateShopViewArguments({this.key, required this.user});
}

/// EditShopView arguments holder class
class EditShopViewArguments {
  final Key? key;
  final Shop shop;
  EditShopViewArguments({this.key, required this.shop});
}

/// CreateServiceView arguments holder class
class CreateServiceViewArguments {
  final Key? key;
  final AppUser user;
  final Shop shop;
  CreateServiceViewArguments(
      {this.key, required this.user, required this.shop});
}

/// ServiceView arguments holder class
class ServiceViewArguments {
  final Key? key;
  final ShopService service;
  final int color;
  final String fontStyle;
  ServiceViewArguments(
      {this.key,
      required this.service,
      required this.color,
      required this.fontStyle});
}

/// ProfileUpdate arguments holder class
class ProfileUpdateArguments {
  final Key? key;
  final AppUser user;
  ProfileUpdateArguments({this.key, required this.user});
}

/// BuyServiceView arguments holder class
class BuyServiceViewArguments {
  final Key? key;
  final AppUser user;
  final ShopService service;
  final int? selectedSize;
  BuyServiceViewArguments(
      {this.key, required this.user, required this.service, this.selectedSize});
}

/// CategoryView arguments holder class
class CategoryViewArguments {
  final Key? key;
  final String category;
  final List<Shop> categoryShops;
  final List<Shop> allOtherShops;
  final List<AppUser> allSellers;
  final List<ShopService> allServices;
  CategoryViewArguments(
      {this.key,
      required this.category,
      required this.categoryShops,
      required this.allOtherShops,
      required this.allSellers,
      required this.allServices});
}

/// ChatsView arguments holder class
class ChatsViewArguments {
  final Key? key;
  final AppUser currentUser;
  final bool onMainView;
  ChatsViewArguments(
      {this.key, required this.currentUser, required this.onMainView});
}

/// FollowersView arguments holder class
class FollowersViewArguments {
  final Key? key;
  final String sellerId;
  FollowersViewArguments({this.key, required this.sellerId});
}

/// FollowingView arguments holder class
class FollowingViewArguments {
  final Key? key;
  final String sellerId;
  FollowingViewArguments({this.key, required this.sellerId});
}

/// MessagesView arguments holder class
class MessagesViewArguments {
  final Key? key;
  final AppUser currentUser;
  final AppUser receiver;
  MessagesViewArguments(
      {this.key, required this.currentUser, required this.receiver});
}

/// EarningsView arguments holder class
class EarningsViewArguments {
  final Key? key;
  final AppUser user;
  EarningsViewArguments({this.key, required this.user});
}

/// OrderDetailView arguments holder class
class OrderDetailViewArguments {
  final Key? key;
  final Order order;
  final int color;
  final String fontStyle;
  final AppUser currentUser;
  OrderDetailViewArguments(
      {this.key,
      required this.order,
      required this.color,
      required this.fontStyle,
      required this.currentUser});
}

/// PrivacyPolicyView arguments holder class
class PrivacyPolicyViewArguments {
  final Key? key;
  final String url;
  PrivacyPolicyViewArguments({this.key, required this.url});
}

/// AboutView arguments holder class
class AboutViewArguments {
  final Key? key;
  final String url;
  AboutViewArguments({this.key, required this.url});
}

/// BookServiceView arguments holder class
class BookServiceViewArguments {
  final Key? key;
  final AppUser user;
  final BookkingService bookingservice;
  final ShopService service;
  BookServiceViewArguments(
      {this.key,
      required this.user,
      required this.bookingservice,
      required this.service});
}

/// BookingView arguments holder class
class BookingViewArguments {
  final Key? key;
  final AppUser user;
  final ShopService service;
  BookingViewArguments({this.key, required this.user, required this.service});
}
