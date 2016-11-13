//
//  voteOptionLabel.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 05/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UpArrowUIView;
@class  AsqTextView;

@interface VoteOptionView : UIView <UITextFieldDelegate>
{
        UIButton*  votes;
        UIButton*  options;
        UIViewController *voteOptionsView;
        UITextField* option1;
        UITextField* option2;
        UITextField* option3;
        UITextField* option4;
        UIButton *selectedVote;
        int      voteType;
    
        AsqTextView *asqTextView;
}

@property (strong, nonatomic) UpArrowUIView *arrow;
@property int voteType;
@end
