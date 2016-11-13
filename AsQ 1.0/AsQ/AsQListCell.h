//
//  AsqListCell.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 10/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTTimeIntervalFormatter.h"
#import "ASQUtility.h"
@class AppDelegate;
@interface AsqListCell : UITableViewCell
{
    TTTTimeIntervalFormatter* timeIntervalFormatter;
    BOOL globalIsDetail;
}

@property (nonatomic,strong) AppDelegate *appDelegate;
-(void) setupPollValues:(PFObject *) object nonDetail: (BOOL) isDetail;
-(id)initCell :(NSString *)reuseIdentifier referenceClass:(HomeController*) referenceClass;

@end
