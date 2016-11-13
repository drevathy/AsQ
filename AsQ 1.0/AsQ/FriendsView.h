//
//  FriendsView.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 22/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsQCreatePoll;

@interface FriendsView : UIView < UITableViewDataSource, UITableViewDelegate >
{
    UITableView*                friendList_tableview;
    NSMutableArray*             friendListArray;
    UIView*                     noFriendsView;
    UIActivityIndicatorView*    activityIndicator;
    UIView*                     activityView;
}
@property NSMutableArray* selectedMembers_array;
-(void) loadView;
@end
