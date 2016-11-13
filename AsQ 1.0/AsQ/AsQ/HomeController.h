//
//  HomeController.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsQCreatePoll.h"

@interface HomeController : UIViewController < AsqCreatePollDelegate, UITableViewDataSource, UITableViewDelegate >
{
    NSMutableArray*             newAsqIdListArray;
    NSMutableArray*             asqIdListArray;
    NSMutableArray*             newAsqListArray;
    UIView*                     noDataView;
    UIActivityIndicatorView*    activityIndicator;
    NSCache*                    _imageCache;
    PFQuery*                    AsQquery;
    int                         loadMoreCount;
    int                        oldasqListArrayCount;
}
@property UIButton*         notificsBtn;
@property UITableView*      asqList_tableview;
@property int               badgeValue;
@property BOOL              flag;
@property int               count;
@property int               detailViewTag;
@property NSMutableArray*   asqListArray;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) MBProgressHUD *hud;
-(void) refreshCellData : (PFObject*)quesObj;
-(void) fetchPollList;
-(void) setNotificationBadge;
@end
