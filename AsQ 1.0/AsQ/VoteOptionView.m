//
//  voteOptionLabel.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 05/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "VoteOptionView.h"
#import "UpArrowUIView.h"
#import "AsqTextView.h"

@implementation VoteOptionView

@synthesize voteType;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self voteButton];
        [self optionButton];
        [self showVotesTab];
        
        self.arrow = [[UpArrowUIView alloc] initWithFrame:CGRectMake(0, 50, 15, 6)color:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1]];
        [self.arrow setCenter:CGPointMake(86.0, self.arrow.center.y)];
        [self addSubview:self.arrow];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//}


#pragma mark - Votes and Option layout methods

-(void) selectedVote : (id) sender
{
    [asqTextView.descTextView resignFirstResponder];
    UIButton *selector = (UIButton*) sender;
    if(selectedVote != selector){
        selectedVote.selected=NO;
    }
    selectedVote = selector;
    selector.selected = !selector.selected;
    NSLog(@" selected Vote....%d",[sender tag]);
    voteType        =  [sender tag];
    //[selector setImage:[UIImage imageNamed:[NSString stringWithFormat:@"vote-1-1.png"]] forState:UIControlStateNormal];
}
- (void) genrateSmileys
{
    int w = 76;
    int h = 50;
    int y = 74;
    int x = 22;
    int xIncrement = 101;
    for (int i=1; i<=6; i++) {
        if(i==4)
        {
            y = 74*2;
            x = 22;
        }
        
        UIButton *smiley = [UIButton buttonWithType:UIButtonTypeCustom];
        smiley.backgroundColor = [UIColor redColor];
       
        smiley.frame = CGRectMake(x, y, w, h);
        x = x + xIncrement;
        
        [smiley setImage:[UIImage imageNamed:[NSString stringWithFormat:@"vote-%d-0.png",i]] forState:UIControlStateNormal];
        [smiley setImage:[UIImage imageNamed:[NSString stringWithFormat:@"vote-%d-1.png",i]] forState:UIControlStateSelected];
        [smiley addTarget:self action:@selector(selectedVote:) forControlEvents:UIControlEventTouchUpInside];
        smiley.tag  = i;
        [self addSubview:smiley];

    }
}
- (void) createOptionFields
{
    CGRect frame = CGRectMake(20, 60, 280, 30);
    option1 = [[UITextField alloc] initWithFrame:frame];
    option1.borderStyle = UITextBorderStyleRoundedRect;
    option1.textColor = [UIColor blackColor];
    option1.font = [UIFont systemFontOfSize:17.0];
    option1.placeholder = @"Option1";
    option1.backgroundColor = [UIColor whiteColor];
    option1.autocorrectionType = UITextAutocorrectionTypeYes;
    option1.keyboardType = UIKeyboardTypeDefault;
    option1.clearButtonMode = UITextFieldViewModeWhileEditing;
    option1.delegate = self;
    [self addSubview:option1];
    
    CGRect frame2 = CGRectMake(20, 100, 280, 30);
    option2 = [[UITextField alloc] initWithFrame:frame2];
    option2.borderStyle = UITextBorderStyleRoundedRect;
    option2.textColor = [UIColor blackColor];
    option2.font = [UIFont systemFontOfSize:17.0];
    option2.placeholder = @"Option2";
    option2.backgroundColor = [UIColor whiteColor];
    option2.autocorrectionType = UITextAutocorrectionTypeYes;
    option2.keyboardType = UIKeyboardTypeDefault;
    option2.clearButtonMode = UITextFieldViewModeWhileEditing;
    option2.delegate = self;
    [self addSubview:option2];
    
    
    CGRect frame3 = CGRectMake(20, 140, 280, 30);
    option3 = [[UITextField alloc] initWithFrame:frame3];
    option3.borderStyle = UITextBorderStyleRoundedRect;
    option3.textColor = [UIColor blackColor];
    option3.font = [UIFont systemFontOfSize:17.0];
    option3.placeholder = @"Option3";
    option3.backgroundColor = [UIColor whiteColor];
    option3.autocorrectionType = UITextAutocorrectionTypeYes;
    option3.keyboardType = UIKeyboardTypeDefault;
    option3.clearButtonMode = UITextFieldViewModeWhileEditing;
    option3.delegate = self;
    [self addSubview:option3];
    
    
    CGRect frame4 = CGRectMake(20, 180, 280, 30);
    option4 = [[UITextField alloc] initWithFrame:frame4];
    option4.borderStyle = UITextBorderStyleRoundedRect;
    option4.textColor = [UIColor blackColor];
    option4.font = [UIFont systemFontOfSize:17.0];
    option4.placeholder = @"Option4";
    option4.backgroundColor = [UIColor whiteColor];
    option4.autocorrectionType = UITextAutocorrectionTypeYes;
    option4.keyboardType = UIKeyboardTypeDefault;
    option4.clearButtonMode = UITextFieldViewModeWhileEditing;
    option4.delegate = self;
    [self addSubview:option4];
}

#pragma mark - Votes and Option Tab control event methods

- (void) showVotesTab
{
    [asqTextView.descTextView resignFirstResponder];
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 170)];
    bgLabel.backgroundColor   =   [[UIColor alloc]initWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1];
    [self addSubview:bgLabel];
    [self genrateSmileys];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.arrow setCenter:CGPointMake((self.frame.size.width/2)/2, self.arrow.center.y)];
    }];
}

- (void) showOptionsTab
{
    [asqTextView.descTextView resignFirstResponder];
    UILabel *bgLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 170)];
    bgLabel2.backgroundColor   = [[UIColor alloc]initWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1];
    [self addSubview:bgLabel2];
    [self createOptionFields];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.arrow setCenter:CGPointMake((self.frame.size.width/2)+(self.frame.size.width/4), self.arrow.center.y)];
    }];
}

- (void) voteButton
{
    votes = [[UIButton alloc] init];
    votes.frame=CGRectMake(0, 0, 166, 50);
    [votes setTitle:@"Votes" forState:UIControlStateNormal];
    [votes addTarget:self action:@selector(showVotesTab) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:votes];
}
- (void) optionButton
{
    options = [[UIButton alloc] init];
    options.frame   =   CGRectMake(150, 0, 170, 50);
    [options setTitle:@"Options" forState:UIControlStateNormal];
    [options addTarget:self action:@selector(showOptionsTab) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:options];
}

@end
