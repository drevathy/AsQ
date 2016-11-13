//
//  AsQProfileController.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsQCreatePoll.h"
#import "LoginViewController.h"
#import "TTTTimeIntervalFormatter.h"

@interface AsQProfileController : UIViewController < UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate >
{
    UITableView*            asqList_tableview;
    NSMutableArray*         asqListArray;
    UIView*                 noDataView;
    UIActivityIndicatorView* activityIndicator;
    TTTTimeIntervalFormatter* timeIntervalFormatter;
    PFUser*                   loadProfileForUser;
}
-(void) logOut;
-(id) loadProfile : (PFUser*) forUser;
@end
