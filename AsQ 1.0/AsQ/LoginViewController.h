//
//  LoginViewController.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : PFLogInViewController
{
    UIButton*                   fbButton;
    
    UIActivityIndicatorView*    activityIndicator;
}
@property (nonatomic, retain) PFSignUpViewController *signUpController;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

