
#define APP_NAME                    @"SocialMarketplace"
//27.72.88.241
//192.168.10.100:8888

#define BASE_URL                    @"http://mesaffairessn.com/api/backend/api/"
#define URL_FILE                    @"http://mesaffairessn.com/api/uploads/files/"

#define API_SETTING_APP             @"settingApp"
#define API_REGISTER                @"register"
#define API_EDIT_INFO               @"updateProfile"
#define API_GET_LIST_ADS            @"showAds"
#define API_GET_LIST_NEAR_BY        @"nearby"
#define API_GET_BOOKMARKS_ADS       @"myBookmark"
#define API_GET_ADS_BY_ID           @"showAdsByAccount"
#define API_LOGIN_DEFAULT           @"login"
#define API_LOGIN_FB                @"login"
#define API_GET_ADS_DETAIL          @"showAdsDetail"
#define API_GET_AGENT_INFO          @"showAccountDetail"
#define API_GET_NEWS                @"searchNews"
#define API_GET_LIST_CITY           @"city"
#define API_GET_LIST_ACCOUNT        @"showAccountList"
#define API_GET_LIST_FOLLOWED       @"listSellerFollowed"
#define API_FORGET_PASS             @"forgetPassword"
#define API_CHANGE_PASS             @"changePassword"
#define API_GET_SELLER_INFO         @"showAccountDetail"
#define API_GET_LIST_CATEGORY       @"category"
#define API_SEARCH_ADS              @"searchAds"
#define API_SEND_MESSAGE            @"addMessages"
#define API_SUBCRIPTION_TYPE        @"subscriptionType"
#define API_INCREASE_ADS_VIEW       @"viewAds"
#define API_LIKE                    @"like"
#define API_UPLOAD_FILE             @"uploadFile"
#define URL_LOGOUT                  @"logout"
#define URL_FOLLOW                  @"follow"

#define API_ADD_ADS                 @"addAds"
#define API_UPDATE_ADS              @"updateAds"
#define API_GET_MESSAGE             @"messages"
#define API_GET_LIST_COMMENT        @"showComment"
#define API_ADD_COMMENT             @"comment"
#define API_SEND_PUSH_MSG           @"sendMessage"
#define API_CONTACT_US              @"contact"
#define API_ADD_SUBCRIPTION         @"addSubscription"
#define API_SHOW_SUBCRIPTON         @"showSubscriptionByAccount"
#define API_CLICK_BOOKMARK          @"bookmark"
#define API_DELETE_ADS              @"deleteAds"



#define IMAGE_HODER             [UIImage imageNamed:@"avatar_default-1.png"]
#define CONTACT_FEEDBACK        @"Feedback"
#define CONTACT_CONTACT         @"Contact us"
#define CONTACT_REPORT_SELLER   @"Report seller"
#define CONTACT_REPORT_ADS      @"Report Seller"


#define OUT_STATUS_LASTMSG      @"OUT_STATUS_LASTMSG"
#define IN_STATUS_LASTMSG       @"IN_STATUS_LASTMSG"

#define PLATFORM_DEVICE         @"2"

//---------KEY NOTIFICATION NAME--------//
#define kNotifiAdsDetailComment  @"K_NOTI_ADS_DETAIL"


//------------ KEY NSUSERDEFAULT---------------//

#define KEY_LOGIN                   @"KEY_IS_LOGIN"
#define KEY_SAVE_gUSER              @"KEY_SAVE_gUSER"
#define KEY_SAVE_TOKEN          @"KEY_SAVE_TOKEN"
#define KEY_SAVE_LANGUAGE           @"KEY_SAVE_LANGUAGE"


//------------ PAYPAL Email to receive money -----------------//

#define kPayPalClientId @"ARR3YZ29JFSRJVIto4SXEqW3s9IddLWdEz5QM8e8VniV-OimdTQDE8VWOBmENwFgAq9P2wZA202z8YYd"
#define kPayPalReceiverEmail @"hicom.david-facilitator@gmail.com"

#define GOOGLE_MAP_KEY          @"AIzaSyAVS7WvgPDd1Bb3kZJgrmylIAW1ivt4w48"
#define GOOGLE_API_KEY          @"AIzaSyAVS7WvgPDd1Bb3kZJgrmylIAW1ivt4w48"

#define NAVIGATION_BACKGROUND_COLOR             [UIColor colorWithRed:0 green:0.612 blue:0.694 alpha:1]
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IP4() ([[UIScreen mainScreen] bounds].size.height == 480)
#define IS_IP5() ([[UIScreen mainScreen] bounds].size.height == 568)
#define IS_IP6() ([[UIScreen mainScreen] bounds].size.height == 667)
#define IS_IP6p() ([[UIScreen mainScreen] bounds].size.height == 736)
#define SCREEN_WIDTH                                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                               [[UIScreen mainScreen] bounds].size.height
//#endif

#pragma mark =>> ------------SORT CONSTANTAN-----------------

#define SORT_BY_ALL @""
#define SORT_BY_NAME @"1"
#define SORT_BY_POSTED_DATE @"2"
#define SORT_BY_VIEW @"3"
#define SORT_BY_ACTIVE @"4"
#define SORT_BY_EXPIRED @"5"
#define SORT_BY_DRAFT @"6"
#define SORT_BY_PENDING @"7"
#define SORT_BY_REGISTERED_DATE @"8"
#define SORT_BY_VERIFIED @"10"
#define SORT_BY_NUMBER_OF_ADS @"11"
#define SORT_BY_INDIVIDUAL @"12"
#define SORT_BY_COMPANY @"13"

#define SORT_TYPE_NORMAL @""
#define SORT_TYPE_ASC @"ASC"
#define SORT_TYPE_DESC @"DESC"


#pragma mark =>> Define Color

#define COLOR_TF_LINE [UIColor lightGrayColor]
// color theme
#define COLOR_DARK_PR_MARY  \
[UIColor colorWithRed:((float)((0xF70000 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xF70000 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0xF70000 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_PRIMARY_DEFAULT  \
[UIColor colorWithRed:((float)((0xF44336 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xF44336 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0xF44336 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_BTN_SMALL  \
[UIColor colorWithRed:((float)((0x4caf50 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x4caf50 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0x4caf50 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_LIGHT_PRIMARY  \
[UIColor colorWithRed:((float)((0xFFCDD2 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xFFCDD2 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0xFFCDD2 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_TEXT_PRIMARY  \
[UIColor colorWithRed:((float)((0xFFFFFF & 0xFF0000) >> 16))/255.0 \
green:((float)((0xFFFFFF & 0x00FF00) >>  8))/255.0 \
blue:((float)((0xFFFFFF & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_ACCENT  \
[UIColor colorWithRed:((float)((0x4CAF50 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x4CAF50 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0x4CAF50 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_PRIMARY_TEXT  \
[UIColor colorWithRed:((float)((0x212121 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x212121 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0x212121 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_SECONDARY_TEXT  \
[UIColor colorWithRed:((float)((0x727272 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x727272 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0x727272 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_DEVIDER  \
[UIColor colorWithRed:((float)((0xB6B6B6 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xB6B6B6 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0xB6B6B6 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_EFEFEF  \
[UIColor colorWithRed:((float)((0xEFEFEF & 0xFF0000) >> 16))/255.0 \
green:((float)((0xEFEFEF & 0x00FF00) >>  8))/255.0 \
blue:((float)((0xEFEFEF & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_0ALPHA80  \
[UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x000000 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0x000000 & 0x0000FF) >>  0))/255.0 \
alpha:0.8]

#define COLOR_SEGMENTTINT  \
[UIColor colorWithRed:((float)((0x939496 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x939496 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0x939496 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_BACKGROUD_VIEW  \
[UIColor colorWithRed:((float)((0xF3F3F3 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xF3F3F3 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0xF3F3F3 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_BG_MESSAGE_HOST \
[UIColor colorWithRed:((float)((0x4080ff & 0xFF0000) >> 16))/255.0 \
green:((float)((0x4080ff & 0x00FF00) >>  8))/255.0 \
blue:((float)((0x4080ff & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_BG_MESSAGE_GUESS \
[UIColor colorWithRed:((float)((0xf1f0f0 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xf1f0f0 & 0x00FF00) >>  8))/255.0 \
blue:((float)((0xf1f0f0 & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define COLOR_0 [[UIColor alloc]initWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:1]

