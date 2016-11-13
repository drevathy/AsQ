//
//  AsqAnsweredPplCell.h
//  AsQ
//
//  Created by drevathy-0847 on 4/29/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTTimeIntervalFormatter.h"

@interface AsqAnsweredPplCell : UITableViewCell
{
        TTTTimeIntervalFormatter* timeIntervalFormatter;
        UIView *nameAndPicView;
        PFObject *friendObj;
        UIView *bgColorFill;
}
-(void) setupVotedPeople:(PFObject*) profileData thisPersonvote :(NSNumber*)thisPersonVote;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end
