//
//  AsQCreatePoll.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AsqTextView;
@class  VoteOptionView;
@class  RESwitch;
@class  FriendsView;
@class  HomeController;

@protocol AsqCreatePollDelegate <NSObject>

-(void) pollSaveToDB: (NSDictionary*) asqDictionary withArray : (NSMutableArray*) sharedTo;

@end

@interface AsQCreatePoll : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UITextViewDelegate>
{
    UIWindow*                   window;
    UINavigationController*     navigationController;
    UIImageView*                imgPicture;
	NSData*                     dataImage;
    UIActionSheet*              actionSheet;
    UIButton*                   cameraButton;
    int                         anonymous;
    HomeController*             homeListView;
    FriendsView*                friendListView;
    UIView*                     createPollView;
    UIBarButtonItem*            cancel;
    UIBarButtonItem*            save;
    UIBarButtonItem*            next;
    UIBarButtonItem*            customItem;
    UIBarButtonItem*            edit;
    AsqTextView*                descTextView;
    VoteOptionView*             voteOptionView;
    RESwitch*                   switchView;
    UITapGestureRecognizer*     singleTapRecognizer;

    id<AsqCreatePollDelegate> delegate;
}
- (void)btnTakePicture_Clicked:(id)sender;

@property NSMutableDictionary*      asqDataDictionary;
@property UIWindow*                 window;
@property UIScrollView*             scrollView;
@property UINavigationController*   navigationController;

@property id<AsqCreatePollDelegate> delegate;

@end



