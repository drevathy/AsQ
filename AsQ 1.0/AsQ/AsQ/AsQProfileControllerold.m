//
//  AsQProfileController.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsQProfileController.h"
#import "AppDelegate.h"
#import "ASQWelcomeViewController.h"

@interface AsQProfileController ()

@end

@implementation AsQProfileController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Q_Logo.png"]];
        UIButton *logoutBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *logoutBtnImage = [UIImage imageNamed:@"backgroundBtn.png"];
        [logoutBtn setBackgroundImage:logoutBtnImage forState:UIControlStateNormal];
        [logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
        [logoutBtn setFont:[UIFont boldSystemFontOfSize:13]];
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        logoutBtn.frame = CGRectMake(0, 0, 54, 30);
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
        self.navigationItem.rightBarButtonItem = logoutButton;

        UIButton *backBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]  ;
        [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
        [backBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, 0, 27, 21);
        UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.hidesBackButton = YES;
        [self.navigationItem setLeftBarButtonItem: customItem];
    }
    return self;
}

-(void) logout
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] logOut];
}
-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor   =   [UIColor darkGrayColor];
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

@end
