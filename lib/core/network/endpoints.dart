class ApiEndpoints {
  static String languageList = 'api/v1/translation/list';
  static String countryList = 'api/v1/countries';
  //  static String exceptionCheck = 'api/v1/test-exception?';
  // Onboarding
  static String onBoarding = 'api/v1/on-boarding';

  static String updateLocation = 'api/v1/user/update-location';

  // Authentication
  static String verifyUser = 'api/v1/user/validate-mobile-for-login'; 
  static String userLogin = 'api/v1/user/login';
  static String commonModule = 'api/v1/common/modules';
  static String sendMobileOtp = 'api/v1/mobile-otp';
  static String verifyMobileOtp = 'api/v1/validate-otp';
  static String sendEmailOtp = 'api/v1/send-mail-otp';
  static String verifyEmailOtp = 'api/v1/validate-email-otp';
  static String registerUser = 'api/v1/user/register';
  static String referral = 'api/v1/update/user/referral';
  static String updatePassword = 'api/v1/user/update-password';

  // Home
  static String userDetails = 'api/v1/user';
  static String recentRoutes = 'api/v1/request/list-recent-searches';

  //co-share
  static String getAllCoShareTrip =  'api/coshare/requests';
  static String joinCoShareTrip =  'api/coshare/join-trip';

  //notifications
  static String notification = 'api/v1/notifications/get-notification';
  static String deleteNotification = 'api/v1/notifications/delete-notification';

  //History
  static String history = 'api/v1/request/history';

  //Outstation
  static String outstation = 'api/v1/request/outstation_rides';

  //logout
  static String logout = 'api/v1/logout';

  //delete account
  static String deleteAccount = 'api/v1/user/delete-user-account';

  // make complaint
  static String makeComplaint = 'api/v1/common/complaint-titles';
  static String makeComplaintButton = 'api/v1/common/make-complaint';

  //update Details button
  static String updateUserDetailsButton = 'api/v1/user/profile';

  // Booking
  static String etaDetails = 'api/v1/request/eta';
  static String rentalEtaDetails = 'api/v1/request/list-packages';
  static String createRequest = 'api/v1/request/create';
  static String cancelRequest = 'api/v1/request/cancel';
  static String deliveryCreateRequest = 'api/v1/request/delivery/create';
  static String goodsType = 'api/v1/common/goods-types';
  static String userReview = 'api/v1/request/rating';
  static String biddingAccept = 'api/v1/request/respond-for-bid';
  static String cancelReasons = 'api/v1/common/cancallation/reasons';
  static String chatHistory = 'api/v1/request/chat-history';
  static String chatMessageSeen = 'api/v1/request/seen';
  static String sendChatMessage = 'api/v1/request/send';

  // Favourite Locations
  static String addFavLocation = 'api/v1/user/add-favourite-location';
  static String removeFavAddress = 'api/v1/user/delete-favourite-location';

  //Faq
  static String faqData = 'api/v1/common/faq/list';

  //wallet
  static String walletHistory = 'api/v1/payment/wallet/history';
  static String transferMoney =
      'api/v1/payment/wallet/transfer-money-from-wallet';
  static String stripCreate = 'api/v1/payment/stripe/create-setup-intent';
  static String stripSavedCardsDetail = 'api/v1/payment/stripe/save-card';
  static String savedCardList = 'api/v1/payment/cards/list';
  static String deleteCardsDetail = 'api/v1/payment/cards/delete/';
  static String makeDefaultCard = 'api/v1/payment/cards/make-default';
  //sos
  static String addSosContact = 'api/v1/common/sos/store';
  static String deleteSosContact = 'api/v1/common/sos/delete';

  //admin chat
  // static String sendAdminMessage = 'api/v1/request/send-message';
  // static String adminChatHistory = 'api/v1/request/admin-chat-history';
  static String sendAdminMessage = 'api/v1/request/user-send-message';
  static String adminChatHistory = 'api/v1/request/user-chat-history';
  static String adminMessageSeen = 'api/v1/request/update-notification-count';

  //Map Apis
  // static String getPolyline =
  //     'https://maps.googleapis.com/maps/api/directions/json?origin=pickLat%2CpickLng&destination=dropLat%2CdropLng&avoid=ferries|indoor&transit_mode=bus&mode=driving&key=mapkey';

  static String getPolyline =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  //Update Language
  static String updateLanguage = 'api/v1/user/update-my-lang';

  // Service Verify
  static String serviceVerify = 'api/v1/request/serviceVerify';
}
