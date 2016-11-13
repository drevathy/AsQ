//
//  AppDelegate.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeController.h"
#import "LoginViewController.h"
#import "ASQWelcomeViewController.h"
#import "DDMenuController.h"
#import "AsQProfileController.h"
#import "UIImage+ResizeAdditions.h"
#import "AsqDetailViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate, PF_FBRequestDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate>
{
    id notificationAsqId;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navController;

@property (nonatomic, strong) HomeController *homeViewController;
@property (nonatomic, strong) ASQWelcomeViewController *welcomeViewController;
@property (nonatomic, strong) PFLogInViewController *LogInViewController;


@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;
@property (nonatomic, strong) NSMutableDictionary *imageCache;
@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;

- (void)logOut;


- (BOOL)shouldProceedToMainInterface:(PFUser *)user;


// Instance Methods

-(void) showLogin;

-(void) showHome;

- (void)setupAppearance;

- (void)presentLoginViewControllerAnimated:(BOOL)animated;

@end
