//
//  ASQWelcomeViewController.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 07/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "ASQWelcomeViewController.h"
#import "AppDelegate.h"

@interface ASQWelcomeViewController ()

@end

@implementation ASQWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    // If not logged in, present login view controller
    if (![PFUser currentUser])
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewControllerAnimated:NO];
        return;
    }
    else
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] showHome];
        return;
    }
    // Present Main UI
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] showHome];
    
    // Refresh current user with server side data -- checks if user is still valid and so on
    [[PFUser currentUser] refreshInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
}


#pragma mark - ()

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }
    
    // Check if user is missing a Facebook ID
    if ([ASQUtility userHasValidFacebookData:[PFUser currentUser]]) {
        // User has Facebook ID.
        
        // refresh Facebook friends on each launch
        PF_FBRequest *request = [PF_FBRequest requestForMyFriends];
        [request setDelegate:(AppDelegate*)[[UIApplication sharedApplication] delegate]];
        [request startWithCompletionHandler:nil];
    } else {
        NSLog(@"User missing Facebook ID");
        PF_FBRequest *request = [PF_FBRequest requestForGraphPath:@"me/?fields=first_name,picture,email"];
        [request setDelegate:(AppDelegate*)[[UIApplication sharedApplication] delegate]];
        [request startWithCompletionHandler:nil];
    }
}


@end
