//
//  AppDelegate.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 07/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "LocalSubstitutionCache.h"


@interface AppDelegate () {
    NSMutableData *_data;
    BOOL firstLaunch;
}
- (void)setupAppearance;
- (BOOL)shouldProceedToMainInterface:(PFUser *)user;
- (BOOL)handleActionURL:(NSURL *)url;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@end

@implementation AppDelegate

@synthesize window;
@synthesize navController;
@synthesize networkStatus;

@synthesize homeViewController;
@synthesize welcomeViewController;


@synthesize hud;
@synthesize autoFollowTimer;

@synthesize hostReach;
@synthesize internetReach;
@synthesize wifiReach,imageCache;

#pragma mark - Local Methods

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [loginViewController setDelegate:self];
    loginViewController.fields = PFLogInFieldsFacebook;
    loginViewController.facebookPermissions = [NSArray arrayWithObjects:@"user_about_me", nil];
//    [self.welcomeViewController presentViewController:loginViewController animated:YES completion:nil];
    [self.welcomeViewController presentModalViewController:loginViewController animated:YES];
  //  LoginViewController *loginViewController = [[LoginViewController alloc] init];
    //[self.welcomeViewController presentModalViewController:loginViewController animated:NO];
}


- (void)presentLoginViewController {
    [self presentLoginViewControllerAnimated:YES];
}

-(void) showHome
{
    NSLog(@"show home::::");
    HomeController* homeController                      = [[HomeController alloc] init];
    UINavigationController* homeRootNavController       = [[UINavigationController alloc] initWithRootViewController:homeController];
    self.window.rootViewController                      =   homeRootNavController;
    [self setupAppearance];
}

- (void)logOut {
    // clear cache
    [[ASQCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kASQParseUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kASQParseUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by clearing the channels key (leaving only broadcast enabled).
    [[PFInstallation currentInstallation] setObject:@[@""] forKey:kASQParseInstallationChannelsKey];
    [[PFInstallation currentInstallation] removeObjectForKey:kASQParseInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    [self.navController popToRootViewControllerAnimated:NO];
    
    [self presentLoginViewController];
    
    self.homeViewController = nil;
}

- (void)setupAppearance {

    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbgonepx.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBar.png"] forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"ButtonNavigationBarSelected.png"] forState:UIControlStateHighlighted];
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];


  //  [[UIBarButtonItem appearance] setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Q_Logo.png"]]];
    
    int imageSize = 20;
    UIImage *barBackBtnImg = [[UIImage imageNamed:@"NavBackButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, imageSize, 0, 0)];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
                                                      forState:UIControlStateSelected
                                                    barMetrics:UIBarMetricsDefault];
    
}

- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    hostReach = [Reachability reachabilityWithHostName: @"api.parse.com"];
    [self.hostReach startNotifier];
    NSLog(@"hostreach::: %@",hostReach);
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    NSLog(@"internetreach::: %@",internetReach);
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
    NSLog(@"wifireach::: %@",wifiReach);
}

-(void) getTargetAsq
{
    PFQuery *query = [PFQuery queryWithClassName:kASQParseShareDetailsClassKey];
    [query includeKey:kASQParseQuestionClassKey];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
         if (!error){
             NSLog(@"dsfsdfs");
         }
         else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

- (void)handlePush:(NSDictionary *)launchOptions {
    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//    [self.hud setLabelText:@"Loading"];
//    [self.hud setDimBackground:YES];
    
    // If the app was launched in response to a push notification, we'll handle the payload here
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ASQParseAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:remoteNotificationPayload];
        
        if ([PFUser currentUser]) {

            NSString *asqObjectId = [remoteNotificationPayload objectForKey:kASQParsePushPayloadAsQObjectIdKey];
            NSString *fromObjectId = [remoteNotificationPayload objectForKey:kASQParsePushPayloadFromUserObjectIdKey];
            if (asqObjectId && asqObjectId.length > 0) {
                // check if this asq is already available locally.
            //PFObject *targetAsq = [PFObject objectWithoutDataWithClassName:kASQParseQuestionClassKey objectId:asqObjectId];

                
//////////////////////////// Pushing to the question view for notification //////////////////////////
            [self asqNotification:asqObjectId];
                
            } else if (fromObjectId && fromObjectId.length > 0) {
                // load fromUser's profile
                PFQuery *query = [PFUser query];
                query.cachePolicy = kPFCachePolicyCacheElseNetwork;
                [query getObjectInBackgroundWithId:fromObjectId block:^(PFObject *user, NSError *error) {
                    if (!error) {
                        [MBProgressHUD hideHUDForView:self.homeViewController.view animated:YES];
                    }
                }];
                
            }
        }
    }
}

-(void) asqNotification : (id) asqObjectId
{
    PFObject *ques = [PFObject objectWithClassName:kASQParseQuestionClassKey];
    ques.objectId = asqObjectId;
    
    PFQuery *query = [PFQuery queryWithClassName:kASQParseShareDetailsClassKey];
    [query whereKey:kASQParseShareDetailsQuestionIdKey equalTo:ques];
    [query includeKey:kASQParseShareDetailsQuestionIdKey];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *shareObject, NSError *error) {
        if (!error){
            
            PFObject *targetAsq = [shareObject objectForKey:kASQParseShareDetailsQuestionIdKey];
            [targetAsq addObject:kASQParseShareDetailsResponseKey forKey:kASQParseShareDetailsResponseKey];
            
            NSLog(@"the targetAsq::::%@",targetAsq);
            AsqDetailViewController *detailViewController = [[AsqDetailViewController alloc] initWithAsQ:targetAsq];
        
            __strong HomeController* homeController             = [[HomeController alloc] init];
            UINavigationController* homeRootNavController       = [[UINavigationController alloc] initWithRootViewController:homeController];
            self.window.rootViewController                      =   homeRootNavController;
            
            [self.window makeKeyAndVisible];
            
            [homeRootNavController pushViewController:detailViewController animated:YES];
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                           initWithTitle: @"Back Button Text"
                                           style: UIBarButtonItemStyleBordered
                                           target: nil action: nil];
            
            [self.homeViewController.navigationItem setBackBarButtonItem: backButton];
            self.homeViewController.navigationItem.hidesBackButton = YES;
            [homeViewController.asqList_tableview reloadData];  
            NSLog(@"homeViewController.navigationController:::%@",detailViewController);
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void)autoFollowTimerFired:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
    [MBProgressHUD hideHUDForView:self.homeViewController.view animated:YES];
    //load first page data
}

- (BOOL)shouldProceedToMainInterface:(PFUser *)user {
    if ([ASQUtility userHasValidFacebookData:[PFUser currentUser]]) {
        NSLog(@"User has valid Facebook data, granting permission to use app.");
        [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
        [self.navController dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    return NO;
}

- (BOOL)handleActionURL:(NSURL *)url {
    NSLog(@"urlhost::: %@", url);
    if ([[url host] isEqualToString:kASQParseLaunchURLHostTakePicture])
    {
        if ([PFUser currentUser])
        {
            NSLog(@"current user... %@",[PFUser currentUser].sessionToken);
        }
    }
    
    return NO;
}

#pragma mark - PFLoginViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    NSLog(@"loginviewcontroller::: %@",user);
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    if (![self shouldProceedToMainInterface:user]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.navController.presentedViewController.view animated:YES];
        [self.hud setLabelText:@"Loading"];
        [self.hud setDimBackground:YES];
        NSLog(@"%d",[self shouldProceedToMainInterface:user]);
    }
    
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:@"me/?fields=name,picture"];
    [request setDelegate:self];
    [request startWithCompletionHandler:NULL];
    
    // Subscribe to private push channel
    if (user) {
        NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kASQParseInstallationUserKey];
        [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kASQParseInstallationChannelsKey];
        [[PFInstallation currentInstallation] saveEventually];
        [user setObject:privateChannelName forKey:kASQParseUserPrivateChannelKey];
    }
    
}

#pragma mark - PF_FBRequestDelegate

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:data.count];
//        for (NSDictionary *friendData in data) {
//            [facebookIds addObject:[friendData objectForKey:@"id"]];
//        }
        
        // cache friend data
        [[ASQCache sharedCache] setFacebookFriends:facebookIds];
        
        if (![[PFUser currentUser] objectForKey:kASQParseUserFacebookFriendsKey]) {
            [self.hud setLabelText:@"Following Friends"];
            firstLaunch = YES;
            
            [[PFUser currentUser] setObject:facebookIds forKey:kASQParseUserFacebookFriendsKey];
            
            NSLog(@"Downloading user's profile picture");
            NSLog(@"facebook id :::%@",[[PFUser currentUser] objectForKey:kASQParseUserFacebookIDKey]);
            // Download user's profile picture
            NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kASQParseUserFacebookIDKey]]];
            NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
            [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
        }
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            if(!error)
            {
                [self showHome];
            }
        }];
        
    } else {
        [self.hud setLabelText:@"Creating Profile"];
        NSString *facebookId = [result objectForKey:@"id"];
        NSString *facebookName = [result objectForKey:@"name"];
        
        if (facebookName && facebookName != 0) {
            [[PFUser currentUser] setObject:facebookName forKey:kASQParseUserDisplayNameKey];
        }
        
        if (facebookId && facebookId != 0) {
            [[PFUser currentUser] setObject:facebookId forKey:kASQParseUserFacebookIDKey];
        }
        
        PF_FBRequest *request = [PF_FBRequest requestForMyFriends];
        [request setDelegate:self];
        [request startWithCompletionHandler:nil];
    }
}




- (void)request:(PF_FBRequest *)request didLoad2:(id)result {
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    
    NSArray *data = [result objectForKey:@"data"];
    
    NSLog(@"friends resquest data:::: %@",data);
    if (data) {
        NSLog(@"Downloading user's profile picture");
        NSLog(@"facebook id :::%@",[[PFUser currentUser] objectForKey:kASQParseUserFacebookIDKey]);
        // Download user's profile picture
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kASQParseUserFacebookIDKey]]];
        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
        [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
        
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:data.count];
        NSLog(@"facebookIds::: %@",facebookIds);
        for (NSDictionary *friendData in data) {
            [facebookIds addObject:[friendData objectForKey:@"id"]];
        }
        
        // cache friend data
        [[ASQCache sharedCache] setFacebookFriends:facebookIds];
        
        if (![self shouldProceedToMainInterface:[PFUser currentUser]]) {
            [self logOut];
            return;
        }
    
    }
        if (![PFUser currentUser]) {
            firstLaunch = YES;
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            if(!error && [[PFUser currentUser] objectForKey:kASQParseUserProfilePicSmallKey]!=NULL)
            {
                    [self showHome];
            }
        }];
        } else {
        NSLog(@"PFUSER:::%@",[PFUser currentUser]);
        [self.hud setLabelText:@"Creating Profile"];
        NSString *facebookId = [result objectForKey:@"id"];
        NSString *facebookName = [result objectForKey:@"name"];
        
        if (facebookName && facebookName != 0) {
            [[PFUser currentUser] setObject:facebookName forKey:kASQParseUserDisplayNameKey];
        }
        
        if (facebookId && facebookId != 0) {
            [[PFUser currentUser] setObject:facebookId forKey:kASQParseUserFacebookIDKey];
        }
        
        PF_FBRequest *request = [PF_FBRequest requestForMyFriends];
        [request setDelegate:self];
        [request startWithCompletionHandler:nil];
    }
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser]) {
        if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
             isEqualToString: @"OAuthException"]) {
            NSLog(@"The facebook token was invalidated");
            [self logOut];
        }
    }
}


- (void) reachabilityChanged:(NSNotification *)notice {
    Reachability *curReach = (Reachability *)[notice object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus internetStatus = [internetReach currentReachabilityStatus];
    NSLog(@"internetStatus::: %@",curReach);
    BOOL reachable = NO;
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            //self.internetReach = NO;
            reachable = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            //self.internetReach = YES;
            reachable = YES;
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            //self.internetReach = YES;
            reachable = YES;
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReach currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            //self.hostReach = NO;
            reachable = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            reachable = YES;
            //self.hostReach = YES;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            reachable = YES;
            //self.hostReach = YES;
            break;
        }
    }
//    if(reachable)
//    {
//        NSLog(@"reachable::::hiding %i",reachable);
//        [MBProgressHUD hideHUDForView:self.window animated:YES];
//        [self.navController dismissViewControllerAnimated:YES completion:nil];
//    }
//    else
//    {
//            self.hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//            [self.hud setLabelText:@"Network connection failed!"];
//            [self.hud setDimBackground:YES];
//    }
//    if (reachable && [PFUser currentUser] && [self.homeViewController.asqListArray count]== 0) {
//        NSLog(@"[self.homeViewController.asqListArray count]::: %d",[self.homeViewController.asqListArray count]);
//        [MBProgressHUD hideHUDForView:self.window animated:YES];
//        [self.navController dismissViewControllerAnimated:YES completion:nil];
//        [self.homeViewController loadView];
//    }
}

#pragma mark - UITabBarControllerDelegate
//
//- (BOOL)tabBarController:(UITabBarController *)aTabBarController shouldSelectViewController:(UIViewController *)viewController {
//    // The empty UITabBarItem behind our Camera button should not load a view controller
//    return ![viewController isEqual:[[aTabBarController viewControllers] objectAtIndex:PAPEmptyTabBarItemIndex]];
//}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [ASQUtility processFacebookProfilePictureData:_data];
}


#pragma mark -  UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.imageCache = [[NSMutableDictionary alloc] init];
    // ****************************************************************************
    // Parse initialization
    // [Parse setApplicationId:@"APPLICATION_ID" clientKey:@"CLIENT_KEY"];
    //
    // Make sure to update your URL scheme to match this facebook id. It should be "fbFACEBOOK_APP_ID" where FACEBOOK_APP_ID is your Facebook app's id.
    // You may set one up at https://developers.facebook.com/apps
    // [PFFacebookUtils initializeWithApplicationId:@"FACEBOOK_APP_ID"];
    // ****************************************************************************
    
    LocalSubstitutionCache *cache = [[LocalSubstitutionCache alloc] init];
    [NSURLCache setSharedURLCache:cache];
    
    [Parse setApplicationId:@"W9cC7kMUBcPVSRGem669FodusnPDrt9ViXfxmHQ0"
                  clientKey:@"C3Hb4RJ6PH0xBtQMG9mM5Rw1Aj0uA67p6VUemCxe"];
    [PFFacebookUtils initializeWithApplicationId:@"247731448681062"];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        homeViewController.badgeValue = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
    
    PFACL *defaultACL = [PFACL ACL];
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Set up our app's global UIAppearance
    [self setupAppearance];
    
    // Use Reachability to monitor connectivity
    [self monitorReachability];
    
    self.welcomeViewController = [[ASQWelcomeViewController alloc] init];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
    self.navController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [self handlePush:launchOptions];
    
    [self createDatabaseWithSchema];
    
    return YES;
}

-(void) createDatabaseWithSchema
{
    NSString *persistentStoreNamePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"AsQ.db"];
    
    //NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PicoShow.sqlite"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if (![fileManager fileExistsAtPath:persistentStoreNamePath])
    {
        NSString *payloadPath = [[NSBundle mainBundle] pathForResource:@"AsQDB" ofType:@"db"];
        [fileManager copyItemAtPath:payloadPath toPath:persistentStoreNamePath error:nil];
    }
    
    NSLog(@"toPath >>>> %@", persistentStoreNamePath);
}

#pragma mark - URL handler
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handledActionURL = [self handleActionURL:url];
    
    if (handledActionURL) {
        return YES;
    }
    
    return [PFFacebookUtils handleOpenURL:url];
}

#pragma mark - Notification accessory methods

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    
    [PFPush storeDeviceToken:newDeviceToken];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    
    [PFPush storeDeviceToken:newDeviceToken];
    
    // Store the deviceToken in the current Installation and save it to Parse.
    currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    
    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:kASQParseInstallationChannelsKey];
    if ([PFUser currentUser]) {
        // Make sure they are subscribed to their private push channel
        NSString *privateChannelName = [[PFUser currentUser] objectForKey:kASQParseUserPrivateChannelKey];
        if (privateChannelName && privateChannelName.length > 0) {
            NSLog(@"Subscribing user to %@", privateChannelName);
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kASQParseInstallationChannelsKey];
        }
    }
    [[PFInstallation currentInstallation] saveEventually];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	if ([error code] != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"notification badge...%d",homeViewController.badgeValue);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ASQParseAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    if (application.applicationState != UIApplicationStateActive ) {
    id asqObjectId = [userInfo objectForKey:kASQParsePushPayloadAsQObjectIdKey];
    [self asqNotification:asqObjectId];
    }
    else
    {
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        NSString *alert = [aps objectForKey:@"alert"];
        notificationAsqId = [userInfo objectForKey:kASQParsePushPayloadAsQObjectIdKey];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AsQ"
                                                            message: alert
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"See", nil]; 
        [alertView show];
        [self.homeViewController fetchPollList];
    }
    
    if ([PFUser currentUser]) {
        int currentBadgeValue = homeViewController.badgeValue;
        if (currentBadgeValue && currentBadgeValue > 0) {
            int badgeValue = currentBadgeValue;
            int newBadgeValue = badgeValue+1;
            homeViewController.badgeValue = newBadgeValue;
        } else {
            homeViewController.badgeValue = 1;
        }
        [self.homeViewController setNotificationBadge];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertview::index%d",buttonIndex);
    if(buttonIndex==1)
    {
        [self asqNotification:notificationAsqId];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
}

@end
