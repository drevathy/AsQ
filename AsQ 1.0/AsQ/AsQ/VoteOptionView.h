//
//  voteOptionLabel.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 05/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AsqTextView,AsQCreatePoll;

@interface VoteOptionView : UIView <UITextFieldDelegate>
{
        UIButton*           votes;
        UIButton*           options;
        UIButton*           rating;
        UIButton*           slider;
        UILabel*            bgLabel;
        UIViewController*   voteOptionsView;
        UITextField*        option1;
        UITextField*        option2;
        UITextField*        option3;
        UITextField*        option4;
        UIButton*           selectedVote;
        UIView*             lineView;
        AsqTextView*        asqTextView;
        UIView*             squareView;
        UIView*             binaryDiv;
        UIScrollView*       optionTabView;
        int                 lastChosen;
        int                 lastChosenBinary;
        UIView*             ratingTab;
        UIView*             sliderTab;
}
@property (nonatomic,strong) AsQCreatePoll *polldel;
@property int voteType;
@property NSArray* allOptionsArray;
@property UITextField* globalOptionField;
@end
