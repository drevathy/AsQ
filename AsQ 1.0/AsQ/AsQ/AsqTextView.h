//
//  AsqTextView.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 04/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsQCreatePoll;
@class VoteOptionView;

@interface AsqTextView : UITextView <UITextViewDelegate>
{
    UITextView* descTextView;
    UILabel *askHere;
    VoteOptionView* voteView;
}
@property (nonatomic,strong) AsQCreatePoll *polldel;
@property(nonatomic, copy) UITextView* descTextView;
@end