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
    UITableView*            asqList_tableview;
    
    NSMutableArray*         asqListArray;
    UIView*                 noDataView;
}

@end
