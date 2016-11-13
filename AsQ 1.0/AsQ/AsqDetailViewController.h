//
//  AsqDetailViewController.h
//  AsQ
//
//  Created by drevathy-0847 on 4/28/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeController;
@interface AsqDetailViewController : UITableViewController
{
    NSMutableArray*             peopleListArray;
    UITableView*                peopleList_tableview;
    UIActivityIndicatorView*    activityIndicator;
    HomeController*             HomeVc;
}
@property UIView *asqDetailView;
@property PFObject *asqObj;
- (id)initWithAsQ:(PFObject *)asq;
- (id)initAsQWithContent:(PFObject *)asq referenceClass:(HomeController*) referenceClass;
- (id)initWithAsQ:(UIView *)asqView asqObject:(PFObject *)asqObj;
@end

