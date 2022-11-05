import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/api/image_selector_api.dart';
import 'package:mipromo/api/storage_api.dart';
import 'package:mipromo/api/paypal_api.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/auth/buyer_signup/buyer_signup_view.dart';
import 'package:mipromo/ui/auth/buyer_signup/email_verify.dart';
import 'package:mipromo/ui/auth/buyer_signup/profile_update.dart';
import 'package:mipromo/ui/auth/login/discover_page.dart';
import 'package:mipromo/ui/auth/login/forgot_password_view.dart';
import 'package:mipromo/ui/auth/login/login_view.dart';
import 'package:mipromo/ui/auth/seller_signup/seller_signup_view.dart';
import 'package:mipromo/ui/availlability/availablity_view.dart';
import 'package:mipromo/ui/booking/booking_view.dart';
import 'package:mipromo/ui/category/category_view.dart';
import 'package:mipromo/ui/category/filter/category_filter_view.dart';
import 'package:mipromo/ui/chats/chats_view.dart';
import 'package:mipromo/ui/chats/messages/messages_view.dart';
import 'package:mipromo/ui/connect_stripe/stripe_view.dart';
import 'package:mipromo/ui/follow/followers/followers_view.dart';
import 'package:mipromo/ui/follow/following/following_view.dart';
import 'package:mipromo/ui/landing/landing_view.dart';
import 'package:mipromo/ui/main/main_view.dart';
import 'package:mipromo/ui/profile/buyer/editProfile/buyer_edit_profile.view.dart';
import 'package:mipromo/ui/profile/seller/editProfile/seller_edit_profile.view.dart';
import 'package:mipromo/ui/profile/seller/seller_profile_view.dart';
import 'package:mipromo/ui/quick_settings/earnings/earnings_view.dart';
import 'package:mipromo/ui/quick_settings/orders/orders_view.dart';
import 'package:mipromo/ui/quick_settings/orders/orderdetail_view.dart';
import 'package:mipromo/ui/service/buyservice_view.dart';
import 'package:mipromo/ui/service/bookservice_view.dart';
import 'package:mipromo/ui/service/create_service_view.dart';
import 'package:mipromo/ui/service/order_success_view.dart';
import 'package:mipromo/ui/service/service_view.dart';
import 'package:mipromo/ui/service/inputaddress_view.dart';
import 'package:mipromo/ui/settings/about/about_view.dart';
import 'package:mipromo/ui/settings/help/help_view.dart';
import 'package:mipromo/ui/settings/privacy/privacy_policy_view.dart';
import 'package:mipromo/ui/settings/settings_view.dart';
import 'package:mipromo/ui/settings/terms/terms_and_conditions_view.dart';
import 'package:mipromo/ui/shop/create_shop_view.dart';
import 'package:mipromo/ui/shop/editShop/edit_shop_view.dart';
import 'package:mipromo/ui/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

/// Application setup for Routing and Service Locator
@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: LandingView),
    MaterialRoute(page: BuyerSignupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: ForgotPasswordView),
    MaterialRoute(page: EmailVerify),
    MaterialRoute(page: MainView),
    MaterialRoute(page: DiscoverPage),
    MaterialRoute(page: BuyerEditProfileView),
    MaterialRoute(page: SellerEditProfileView),
    MaterialRoute(page: SellerProfileView),
    MaterialRoute(page: SellerSignupView),
    MaterialRoute(page: CreateShopView),
    MaterialRoute(page: EditShopView),
    MaterialRoute(page: CreateServiceView),
    MaterialRoute(page: ServiceView),
    MaterialRoute(page: ProfileUpdate),
    MaterialRoute(page: BuyServiceView),
    MaterialRoute(page: CategoryView),
    MaterialRoute(page: CategoryFilterView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ChatsView),
    MaterialRoute(page: FollowersView),
    MaterialRoute(page: FollowingView),
    MaterialRoute(page: MessagesView),
    MaterialRoute(page: EarningsView),
    MaterialRoute(page: OrdersView),
    MaterialRoute(page: OrderDetailView),
    MaterialRoute(page: TermsAndConditionsView),
    MaterialRoute(page: PrivacyPolicyView),
    MaterialRoute(page: AboutView),
    MaterialRoute(page: HelpView),
    MaterialRoute(page: InputAddressView),
    MaterialRoute(page: OrderSuccessView),
    MaterialRoute(page: BookServiceView),
    MaterialRoute(page: BookingView),
    MaterialRoute(page: AvailabilityView),
    MaterialRoute(page: ConnectStripeView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: AuthApi),
    LazySingleton(classType: DatabaseApi),
    LazySingleton(classType: StorageApi),
    LazySingleton(classType: PaypalApi),
    LazySingleton(classType: ImageSelectorApi),
    LazySingleton(classType: UserService),
  ],
)
class AppSetup {}
