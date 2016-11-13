//
//  AsqListCell.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 10/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTTimeIntervalFormatter.h"
#import "sqlite3.h"
#import "AsqDetailViewController.h"
@class AppDelegate;
@class HomeController;
@interface AsqListCell : UITableViewCell
{
    float quesYOffset;
    CGFloat totalHeight;
    UIView *questionBgView;
    PFFile *imageFile;
    UIView *questionBox;
    UIView *questionBoxBg;
    UIView *resultHolderView;
    CGSize size;
    UIButton *smileyVote;
    UIButton *frownyVote;
    UIView *voteBgView;
    
    sqlite3 *contactDB;
    NSString *databasePath;
    NSArray* contactsData;
    NSArray* foldersData;
    NSArray* labelsData;
    NSArray *categorieList;
    NSArray *responseArray;
    NSArray *labels;
    UILabel *percentNumberLabel;
    BOOL globalIsDetail;
    HomeController* homeVc;
}

-(void) setupPollValues:(PFObject *) object nonDetail: (BOOL) isDetail;
- (id)initCell :(NSString *)reuseIdentifier referenceClass:(HomeController*) referenceClass;
- (void) setQuestionPicture:(PFObject*) object;
@property BOOL *loadedProfileImg;
@property PFObject* quesObj;
@property NSString *incColumn;
@property NSMutableArray *barObj;
@property NSMutableArray *percentObj;
@property (nonatomic,retain) NSMutableData *receivedData;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@property int cellTag;
@property (nonatomic,strong) AppDelegate *appDelegate;

@end
