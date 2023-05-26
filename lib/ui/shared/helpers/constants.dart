import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static const Color enabledColor = Color(0xff76C81B);
  static const Color disabledColor = Color(0xffEFEFEF);

  // Strings
  static const String landingLabel = 'Promote your business\nDiscover local services';

  static const String createAccountLabel = 'Create Account';

  static const String alreadyHaveAnAccountLabel = 'Already have an account? ';

  static const String loginLabel = 'Login';
  static const String firstName = 'First name';
  static const String hintFirstName = 'Enter your first name';
  static const String lastName = 'Last name';
  static const String hintLastName = 'Enter your last name';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String hintPasswordLabel = 'Enter a Password';
  static const String forgotPasswordLabel = 'Forgot Password';
  static const String nextLabel = 'Next';
  static const String backLabel = 'Back';

  static const String bySigningLabel = "By signing up you accept MiyPromo's ";
  static const String tAndCLabel = "Terms of Service";
  static const String andLabel = " and ";
  static const String privacyPolicyLabel = "Privacy Policy";

  static const String signupLabel = 'Create account';
  static const String signupTitle = 'Create a customer acccount';
  static const String signupSubTitle = "You're almost there!Create your new account for Sadje.entertainment1@gmail.com by completing these detail";
  static const String createUsernameLabel = 'Create a Username';
  static const String editProfileLabel = 'Edit Profile';
  static const String changeProfileImageLabel = 'Change Profile Image';
  static const String usernameLabel = 'Username';
  static const String openShopLabel = 'Open a shop';

  static const String broughtLabel = "Product/Service brought";
  static const String referralsLabel = "Referrals";
  static const String earnedLabel = "Earned in 60 days";
  static const String createSellerLabel = "Create Seller";
  static const String createLabel = "Create";
  static const String dobLabel = "Date of Birth";
  static const String dobHelperTextLabel = "You must be over 16 to create a seller account";
  static const String fullNameLabel = "Full name";
  static const String mobileNumberLabel = "Mobile number";
  static const String hintMobileNumberLabel = "Enter your mobile number";
  static const String createShopLabel = "Create Shop";
  static const String createShopInfoLabel = "Create a new Shop and showcase your services to new customers";

  static const String categoryLabel = 'Category';
  static const String locationLabel = 'Location';
  static const String boroughsLabel = 'Boroughs';
  static const String fontLabel = "Select Font";
  static const String themeLabel = "Select Theme";

  static const String addServiceLabel = "Add Service/Product";
  static const String editServiceLabel = "Edit Service/Product";
  static const String serviceNameLabel = "Service/Product Name";
  static const String descriptionLabel = 'Description';
  static const String typeLabel = "Type";
  static const String serviceLabel = "Service";
  static const String productLabel = "Product";
  static const String selectSizesLabel = "Select Sizes";
  static const String sizeLabel = "Size";
  static const String onesizeLabel = "Onesize";
  static const String xsLabel = "XS";
  static const String sLabel = "S";
  static const String mLabel = "M";
  static const String lLabel = "L";
  static const String xlLabel = "XL";
  static const String xxlLabel = "XXL";
  static const String priceLabel = "Price";
  static const String bookLabel = "Book";
  static const String buyLabel = "Buy";
  static const String paymentMethodLabel = "Payment Method";
  static const String paypalLabel = "PayPal";
  static const String placeOrderLabel = "Place Order";
  static const String confirmBookingLabel = "Confirm Booking";
  static const String viewShopLabel = "View Shop";
  static const String selectGenderLabel = "Select Gender";
  static const String maleLabel = 'Male';
  static const String femaleLabel = 'Female';
  static const String otherLabel = 'Other';

  // "Data
  // Font Style
  static const List<String> fontstyle = [
    "Aladin",
    "Kaushan",
    "Niconne",
    "Merienda",
    "Miriam",
    "Monts",
    "Satisfy",
    "Default",
  ];

  // Shop Categories
  static const List<String> categories = [
    "Nails",
    "Hair Salons",
    "Makeup Services",
    "EyeLash Extensions",
    "Clothing Brands",
    "Footwear & Resellers",
    "Accessories",
    "Photography & Videography",
    "Aesthetics",
    "Barber Shop",
    "Piercings",
    "Other",
  ];

  // City
  static const List<String> cities = [
    "Aberdeen",
    "Armagh",
    "Bangor",
    "Bath",
    "Belfast",
    "Birmingham",
    "Bradford",
    "Brighton & Hove",
    "Bristol",
    "Cambridge",
    "Canterbury",
    "Cardiff",
    "Carlisle",
    "Chelmsford",
    "Chester",
    "Chichester",
    "Coventry",
    "Derby",
    "Derry",
    "Dundee",
    "Durham",
    "Edinburgh",
    "Ely",
    "Exeter",
    "Glasgow",
    "Gloucester",
    "Hertfordshire",
    "Inverness",
    "Kingston upon Hull",
    "Lancaster",
    "Leeds",
    "Leicester",
    "Lichfield",
    "Lincoln",
    "Lisburn",
    "Liverpool",
    "London",
    "Manchester",
    "Newcastle upon Tyne",
    "Newport",
    "Newry",
    "Norwich",
    "Nottingham",
    "Oxford",
    "Perth",
    "Peterborough",
    "Plymouth",
    "Portsmouth",
    "Preston",
    "Ripon",
    "St Albans",
    "St Asaph",
    "St Davids",
    "Salford",
    "Salisbury",
    "Sheffield",
    "Southampton",
    "Stirling",
    "Stoke-on-Trent",
    "Sunderland",
    "Swansea",
    "Truro",
    "Wakefield",
    "Wells",
    "Westminster",
    "Winchester",
    "Wolverhampton",
    "Worcester",
    "York",
    "Luton",
    "Northamptonshire",
    "Milton Keynes",
    "Hemel Hempstead",
    "Bedford",
    "Kent",
    "Cornwall",
    "Slough",
    "Guildford",
    "Stafford",
    "Basildon",
    "Braintree",
    "Brentwood",
    "Castle Point",
    "Chelmsford",
    "Colchester",
    "Epping Forest",
    "Harlow",
    "Maldon",
    "Rochford",
    "Tendring",
    "Uttlesford",
    "Thurrock",
    "Norfolk",
    "Suffolk",
  ];

  // London boroughs
  static const List<String> londonBoroughs = [
    "Barking and Dagenham",
    "Barnet",
    "Bexley",
    "Brent",
    "Bromley",
    "Camden",
    "Croydon",
    "Ealing",
    "Enfield",
    "Greenwich",
    "Hackney",
    "Hammersmith and Fulham",
    "Haringey",
    "Harrow",
    "Havering",
    "Hillingdon",
    "Hounslow",
    "Islington",
    "Kensington and Chelsea",
    "Kingston upon Thames",
    "Lambeth",
    "Lewisham",
    "Merton",
    "Newham",
    "Redbridge",
    "Richmond upon Thames",
    "Southwark",
    "Sutton",
    "Tower Hamlets",
    "Waltham Forest",
    "Wandsworth",
    "Westminster",
    
  ];

  // Hertfordshire boroughs
  static const List<String> hertfordshireBoroughs = [
    "Borough of Broxbourne",
    "Dacorum",
    "East Hertfordshire",
    "Hertsmere",
    "North Hertfordshire",
    "St Albans City and District",
    "Stevenage",
    "Three Rivers District",
    "Watford",
    "Welwyn Hatfield",
  ];

  // All locations
  static final List<String> allLocations = cities + londonBoroughs + hertfordshireBoroughs;
  static const String addressLabel = 'Address';
  static const String postCodeLabel = 'Postcode';
}
