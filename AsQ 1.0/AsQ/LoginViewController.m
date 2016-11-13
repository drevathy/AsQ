//
//  LoginViewController.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle Methods

-(void) loadView
{
    [super loadView];
    
    //self.view.backgroundColor   =   [UIColor brownColor];
    
    [self createLoginUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

#pragma mark - Local Methods

-(void) createLoginUI
{
    // Attach Background image
    
    UIImageView*    bg_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 320,[UIScreen mainScreen].applicationFrame.size.height + 20)];
    
    if(IS_IPHONE_5)     [bg_view setImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
                else    [bg_view setImage:[UIImage imageNamed:@"Default.png"]];
    
    [self.view addSubview:bg_view];
    
    // Add a Facebook button
    
    fbButton  =   [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(IS_IPHONE_5)     fbButton.frame      =   CGRectMake(53, 430, 211, 46);
    else    fbButton.frame      =   CGRectMake(53, 342, 212, 37);
    
    [fbButton setImage:[UIImage imageNamed:@"fb_button.png"] forState:UIControlStateNormal];
    [fbButton setImage:[UIImage imageNamed:@"fb_button_pressed.png"] forState:UIControlStateHighlighted];
    
    [fbButton addTarget:self action:@selector(fbLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbButton];
}

-(void) signUp :(PFUser *)user
{
    NSLog(@"loginviewcontroller::: %@",user);
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:@"me/?fields=name,picture"];
    [request startWithCompletionHandler:NULL];
    
    // Subscribe to private push channel
    if (user) {
        NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kASQParseInstallationUserKey];
        [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kASQParseInstallationChannelsKey];
        [[PFInstallation currentInstallation] saveEventually];
        [user setObject:privateChannelName forKey:kASQParseUserPrivateChannelKey];
        
        [self.hud setLabelText:@"Loading"];
        [self.hud setDimBackground:YES];
    }
    
}

-(void) fbLogin
{
    NSLog(@"FB login");
    
    activityIndicator       =   [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    if(IS_IPHONE_5)     activityIndicator.frame     =   CGRectMake(144, 430, 30, 30);
                else    activityIndicator.frame     =   CGRectMake(144, 430, 30, 30);
    
    [self.view addSubview:activityIndicator];
    
    // Set permissions required from the facebook user account
    
    NSArray *permissionsArray = @[@"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        [activityIndicator stopAnimating]; // Hide loading indicator
        fbButton.hidden =   NO;
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew)
        {
            //[self signUp: user];
            NSLog(@"User with facebook signed up and logged in!");
            NSLog(@"[PFUser currentUser]::: %@",[PFUser currentUser]);
            
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] logInViewController:self didLogInUser:user];
            
        } else
        {
            NSLog(@"User with facebook logged in!");
             NSLog(@"[PFUser currentUser]::: %@",[PFUser currentUser]);
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] showHome];
        }
    }];
    
    fbButton.hidden =   YES;
   
    if(![PFUser currentUser])
    {
        [activityIndicator startAnimating]; // Show loading indicator until login is finished
    }
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)logInViewController:(LoginViewController *)logInController didLogInUser:(PFUser *)user {
//    
//}

@end
