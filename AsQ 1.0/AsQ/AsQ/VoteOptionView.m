//
//  voteOptionLabel.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 05/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "VoteOptionView.h"
#import "AsqTextView.h"
#import "AsQCreatePoll.h"

#define M_PI   3.14159265358979323846264338327950288

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@implementation VoteOptionView;

@synthesize voteType, globalOptionField;

@synthesize allOptionsArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self voteButton];
        [self optionButton];
        [self ratingButton];
        [self sliderButton];
        [self showVotesTab];
        [self addBinary];
        [self addOptions];
        [self addRating];
        [self addSlider];
        
        squareView = [[UIView alloc] initWithFrame:CGRectMake(20, -5, 10, 10)];
        squareView.backgroundColor = [UIColor whiteColor];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
        squareView.transform = transform;
        [self addSubview:squareView];
        squareView.hidden = YES;
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(116, 80, 10, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:175.0/255 green:209.0/255 blue:223.0/255 alpha:1.0];
        lineView.transform = transform;
        [binaryDiv addSubview:lineView];
        lineView.hidden = YES;
        
        [self showBinaries:1];
    }
    return self;
}

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
    [self ShowThisBinary:voteType];
}

-(void) showBinaries: (int) binaryId
{
    NSString* path1 = @"";
    NSString* path2 = @"";
    path1 = [path1 stringByAppendingFormat:@"%dblue.png", binaryId];
    path2 = [path2 stringByAppendingFormat:@"other-%dblue.png", binaryId];
    
    NSLog(@"path1::: %@ path2::: %@",path1,path2);
    UIView* binaryRootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 90)];
    
    UIView *binaryView = [[UIView alloc] initWithFrame:CGRectMake(14, 30, 200, 70)];
    binaryView.backgroundColor = [UIColor colorWithRed:198.0/255 green:232.0/255 blue:247.0/255 alpha:1.0];
    
    UIImageView* arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(106.0, 99.0f, 18.0f,10.0f)];
    arrowImgView.image = [UIImage imageNamed:@"triangle.png"];
    
    [binaryRootView addSubview:arrowImgView];
    [binaryRootView sendSubviewToBack:binaryView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 300, 12);
    binaryView.clipsToBounds = YES;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:175.0/255 green:209.0/255 blue:223.0/255 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:198.0/255 green:232.0/255 blue:247.0/255 alpha:1.0] CGColor], nil];
    // Specify your own colors above to acquire a gradient
    binaryView.layer.cornerRadius=34.0f;
    binaryView.layer.borderColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0].CGColor;
    binaryView.layer.borderWidth = 2.0f;
    [binaryView.layer insertSublayer:gradient atIndex:0];
    
    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(92.0, 20.0f, 32.0f,30.0f)];
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.textColor = [UIColor colorWithRed:107.0/255 green:141.0/255 blue:156.0/255 alpha:1.0];
    [orLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:20.0f ]];
    orLabel.text = @"or";
    orLabel.lineBreakMode=UILineBreakModeWordWrap;
    orLabel.numberOfLines=0;
    orLabel.shadowColor = [UIColor whiteColor]; // Choose your color here - in the example
    orLabel.shadowOffset = CGSizeMake(-1,0);
    
    [binaryView addSubview:orLabel];
    
    UIButton* smiley1           = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 56, 56)];
    [smiley1 setImage:[UIImage imageNamed:path1] forState:UIControlStateNormal];
    
    NSLog(@"[UIImage imageNamed::::%@",[UIImage imageNamed:@"1.png"]);
    UIButton* smiley2           = [[UIButton alloc] initWithFrame:CGRectMake(136, 7, 56, 56)];
    [smiley2 setImage:[UIImage imageNamed:path2] forState:UIControlStateNormal];
    
    [binaryView addSubview:smiley1];
    [binaryView addSubview:smiley2];
    [binaryRootView addSubview:binaryView];
    [binaryDiv addSubview:binaryRootView];
}

-(void) ShowThisBinary : (int) binaryId
{
    NSLog(@"changeIcon highlighterd %d", binaryId);
    NSLog(@"hide lastChosen:::%d",lastChosenBinary);
    
    UIButton* selected_btn  =   (UIButton*)[binaryDiv viewWithTag:binaryId];
    __block CGRect frame = selected_btn.frame;
    if(!lastChosenBinary)
    {
         lastChosenBinary = 4;
    }
    
    if(lastChosenBinary>0)
    {
        UIButton* lastSelected_btn = (UIButton*)[binaryDiv viewWithTag:lastChosenBinary];
        NSLog(@"lastChosenBinary::: %@",lastSelected_btn);
        [UIView animateWithDuration:0.3 animations:^{
            lastSelected_btn.frame = frame;
        }];
        [UIView commitAnimations];
    }
    [self moveLine:binaryId];
    [self showBinaries:binaryId];
    [UIView animateWithDuration:0.3 animations:^{
        frame.origin.x = 100;
        selected_btn.frame = frame;
    }];
    [UIView commitAnimations];
    
    lastChosenBinary = binaryId;
}

-(void) moveLine : (int) where
{
    lineView.hidden = NO;
    float moveXto = ((where-1)*50)+14;
    NSLog(@"squareView.frame = rectFrame; %f::: %d",moveXto,where);
    
    lineView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = lineView.frame;
        frame.origin.x = moveXto;
    }];
    [UIView commitAnimations];
    CGAffineTransform transformdegree = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
    lineView.transform = transformdegree;
}

-(void) addBinary
{
    UIView* bgView              = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 320)];
    bgView.backgroundColor   = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0];
    
    binaryDiv                   = [[UIView alloc] initWithFrame:CGRectMake(42, 70, 320, 320)];
    binaryDiv.backgroundColor   = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0];
    
    [self addSubview:bgView];
    [self addSubview:binaryDiv];
    float binaryY = 124;
    
    UIView *blueCircle = [[UIView alloc] initWithFrame:CGRectMake(101, binaryY-2, 38, 38)];
    blueCircle.layer.cornerRadius = 24.0f;
    blueCircle.backgroundColor = [UIColor colorWithRed:117.0/255 green:174.0/255 blue:214.0/255 alpha:1.0];
    [binaryDiv addSubview:blueCircle];
    
    UIButton* binary1           = [[UIButton alloc] initWithFrame:CGRectMake(0, binaryY, 36, 36)];
    [binary1 setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [binary1 setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    binary1.tag = 1;
    [binary1 addTarget:self action:@selector(selectedVote:) forControlEvents:UIControlEventTouchUpInside];
    [binaryDiv addSubview:binary1];
    
    UIButton* binary5           = [[UIButton alloc] initWithFrame:CGRectMake(50, binaryY, 36, 36)];
    [binary5 setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
    [binary5 setImage:[UIImage imageNamed:@"5blue.png"] forState:UIControlStateHighlighted];
    binary5.tag = 5;
    [binary5 addTarget:self action:@selector(selectedVote:) forControlEvents:UIControlEventTouchUpInside];
    [binaryDiv addSubview:binary5];
    
    UIButton* binary4           = [[UIButton alloc] initWithFrame:CGRectMake(100, binaryY, 36, 36)];
    [binary4 setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
    [binary4 setImage:[UIImage imageNamed:@"4blue.png"] forState:UIControlStateHighlighted];
    binary4.tag = 4;
    [binary4 addTarget:self action:@selector(selectedVote:) forControlEvents:UIControlEventTouchUpInside];
    [binaryDiv addSubview:binary4];
    
    UIButton* binary2           = [[UIButton alloc] initWithFrame:CGRectMake(150, binaryY, 36, 36)];
    [binary2 setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [binary2 setImage:[UIImage imageNamed:@"2blue.png"] forState:UIControlStateHighlighted];
    binary2.tag = 2;
    [binary2 addTarget:self action:@selector(selectedVote:) forControlEvents:UIControlEventTouchUpInside];
    [binaryDiv addSubview:binary2];
    
    UIButton* binary3           = [[UIButton alloc] initWithFrame:CGRectMake(200, binaryY, 36, 36)];
    [binary3 setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    [binary3 setImage:[UIImage imageNamed:@"3blue.png"] forState:UIControlStateHighlighted];
    binary3.tag = 3;
    [binary3 addTarget:self action:@selector(selectedVote:) forControlEvents:UIControlEventTouchUpInside];
    [binaryDiv addSubview:binary3];

    binaryDiv.hidden = YES;
}

- (void) addOptions
{
    optionTabView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 320)];
    optionTabView.backgroundColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0];
    [self addSubview:optionTabView];
    optionTabView.userInteractionEnabled = YES;
    allOptionsArray = [[NSArray alloc]initWithObjects:nil];
    CGRect frame = CGRectMake(20, 20, 280, 30);
    option1 = [[UITextField alloc] initWithFrame:frame];
    option1.borderStyle = UITextBorderStyleNone;
    [option1 setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:17.0f ]];
    option1.textColor = [UIColor darkGrayColor];
    UIView *paddingView1         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    option1.leftView             = paddingView1;
    option1.leftViewMode         = UITextFieldViewModeAlways;
    option1.placeholder = @"Option1";
    option1.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    option1.backgroundColor = [UIColor whiteColor];
    option1.autocorrectionType = UITextAutocorrectionTypeYes;
    option1.keyboardType = UIKeyboardTypeDefault;
    option1.clearButtonMode = UITextFieldViewModeWhileEditing;
    option1.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    option1.delegate = self;
    option1.layer.cornerRadius = 5.0f;
    [self textFieldShouldBeginEditing:option1];
    [optionTabView addSubview:option1];
    
    CGRect frame2 = CGRectMake(20, 60, 280, 30);
    option2 = [[UITextField alloc] initWithFrame:frame2];
    option2.borderStyle = UITextBorderStyleNone;
    [option2 setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:17.0f ]];
    option2.textColor = [UIColor darkGrayColor];
    option2.placeholder = @"Option2";
    UIView *paddingView2           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    option2.leftView             = paddingView2;
    option2.leftViewMode         = UITextFieldViewModeAlways;
    option2.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    option2.backgroundColor = [UIColor whiteColor];
    option2.autocorrectionType = UITextAutocorrectionTypeYes;
    option2.keyboardType = UIKeyboardTypeDefault;
    option2.clearButtonMode = UITextFieldViewModeWhileEditing;
    option2.delegate = self;
    option2.layer.cornerRadius = 5.0f;
    [self textFieldShouldBeginEditing:option2];
    [optionTabView addSubview:option2];
    
    CGRect frame3 = CGRectMake(20, 100, 280, 30);
    option3 = [[UITextField alloc] initWithFrame:frame3];
    option3.borderStyle = UITextBorderStyleNone;
    option3.textColor = [UIColor blackColor];
    [option3 setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:17.0f ]];
    option3.placeholder = @"Option3";
    UIView *paddingView3         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    option3.leftView             = paddingView3;
    option3.leftViewMode         = UITextFieldViewModeAlways;
    option3.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    option3.backgroundColor = [UIColor whiteColor];
    option3.autocorrectionType = UITextAutocorrectionTypeYes;
    option3.keyboardType = UIKeyboardTypeDefault;
    option3.clearButtonMode = UITextFieldViewModeWhileEditing;
    option3.delegate = self;
    option3.layer.cornerRadius = 5.0f;
    [self textFieldShouldBeginEditing:option3];
    [optionTabView addSubview:option3];
    
    CGRect frame4 = CGRectMake(20, 140, 280, 30);
    option4 = [[UITextField alloc] initWithFrame:frame4];
    option4.borderStyle = UITextBorderStyleNone;
    option4.textColor = [UIColor blackColor];
    [option4 setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:17.0f ]];
    option4.placeholder = @"Option4";
    UIView *paddingView4         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    option4.leftView             = paddingView4;
    option4.leftViewMode         = UITextFieldViewModeAlways;
    option4.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    option4.backgroundColor = [UIColor whiteColor];
    option4.autocorrectionType = UITextAutocorrectionTypeYes;
    option4.keyboardType = UIKeyboardTypeDefault;
    option4.clearButtonMode = UITextFieldViewModeWhileEditing;
    option4.delegate = self;
    option4.layer.cornerRadius = 5.0f;
    [optionTabView addSubview:option4];
    [self textFieldShouldBeginEditing:option4];
    
    allOptionsArray = [NSArray arrayWithObjects:option1, option2, option3, option4, nil];
    optionTabView.hidden = YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: UIViewAnimationCurveEaseOut
    animations:^{
     self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 420, 330, 350);
        optionTabView.contentSize = CGSizeMake(320, 400);
        optionTabView.showsVerticalScrollIndicator = NO;
        optionTabView.showsHorizontalScrollIndicator = NO;
    }
    completion:^(BOOL finished){
    }];
}

- (void) addSlider
{
    sliderTab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 320)];
    sliderTab.backgroundColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0];
    [self addSubview:sliderTab];
    [globalOptionField resignFirstResponder];
    
    [asqTextView.descTextView resignFirstResponder];
    UIView *sliderStick      = [[UIView alloc] initWithFrame:CGRectMake(16, 128, 290, 5)];
    sliderStick.backgroundColor = [UIColor colorWithRed:179.0/255 green:181.0/255 blue:188.0/255 alpha:1.0];
    sliderStick.layer.cornerRadius = 3.0f;
    UIView* sliderbar = [[UIView alloc] initWithFrame:CGRectMake(18, 128, 6, 6)];
    sliderbar.backgroundColor = [UIColor colorWithRed:91.0/255 green:98.0/255 blue:114.0/255 alpha:1.0];
    sliderbar.layer.cornerRadius = 14.0f;
    
    [sliderStick addSubview:sliderbar];
    [sliderTab addSubview:sliderStick];
    sliderTab.hidden = YES;
}

-(void) addRating
{
    [globalOptionField resignFirstResponder];
    [asqTextView.descTextView resignFirstResponder];
    ratingTab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 320)];
    ratingTab.backgroundColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0];
    [self addSubview:ratingTab];
    UIImageView *ratingImg      = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 320, 60)];
    ratingImg.backgroundColor   = [UIColor whiteColor];
    ratingImg.image             = [UIImage imageNamed:@"star.png"];
    [ratingTab addSubview:ratingImg];
    
    UIImageView *feedbackImg        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 320, 56)];
    feedbackImg.backgroundColor     = [UIColor whiteColor];
    feedbackImg.image               = [UIImage imageNamed:@"feedback.png"];
    [ratingTab addSubview:feedbackImg];
    ratingTab.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    globalOptionField = textField;
    //CGRect frame = CGRectMake(0, 0, 300, 300);
   // votes.frame = frame;
   // options.frame = frame;
    return YES;
}

#pragma mark - Move white triangle with animation
-(void) moveTriangle : (int) where
{
    if(where!=1 || lastChosen==where)
    {
        [globalOptionField resignFirstResponder];
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 330, 330, 350);
                             optionTabView.contentSize = CGSizeMake(320, 200);
                             optionTabView.showsVerticalScrollIndicator = NO;
                         }
                         completion:^(BOOL finished){
                         }];
    }
    squareView.hidden = NO;
    
    float moveXto = (where*50)+20;
    NSLog(@"squareView.frame = rectFrame; %f::: %d",moveXto,where);
    CGRect rectFrame = CGRectMake(moveXto, -5, 10, 10);

    squareView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        squareView.frame = rectFrame;
    }];
    [UIView commitAnimations];
    CGAffineTransform transformdegree = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
    squareView.transform = transformdegree;

}

#pragma mark - Votes and Option Tab control event methods


-(void) showThisVoteTab:(id)sender
{
    NSLog(@"hide lastChosen:::%d",lastChosen);
    NSMutableArray* votesTab = [[NSMutableArray alloc]initWithObjects:binaryDiv,optionTabView,ratingTab,sliderTab,nil];
    if(lastChosen)
    {
        UIView* hideThisTab = [votesTab objectAtIndex:lastChosen];
        hideThisTab.hidden = YES;
    }
    NSLog(@"[sender tag]:: %d",[sender tag]);
    [self moveTriangle:[sender tag]];
    UIView* showThisTab = [votesTab objectAtIndex:[sender tag]];
    
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.1];
    [showThisTab setAlpha:1];
    [UIView commitAnimations];
    
    showThisTab.hidden = NO;
    lastChosen = [sender tag];
    NSLog(@"now Chosen:::%d",lastChosen);
}

- (void) showVotesTab
{
    [globalOptionField resignFirstResponder];
    [asqTextView.descTextView resignFirstResponder];
    [self moveTriangle:0];
}

- (void) showOptionsTab
{
    NSLog(@"scroll view::::%@",self.polldel.scrollView);
    if(!IS_IPHONE_5)
    {
        self.polldel.scrollView.contentSize = CGSizeMake(320, 598);
        self.polldel.scrollView.bounces = false;
    }
    else
    {
        self.polldel.scrollView.contentSize = CGSizeMake(320, 600);
        self.polldel.scrollView.bounces = false;
    }
    [asqTextView.descTextView resignFirstResponder];
   
    [self addOptions];
    
    [self moveTriangle:1];
}

- (void) voteButton
{
    votes                   = [[UIButton alloc] init];
    votes.frame             = CGRectMake(0, 2, 50, 50);
    [votes setImage:[UIImage imageNamed:@"binary.png"] forState:UIControlStateNormal];
    votes.tag = 0;
    [votes addTarget:self action:@selector(showThisVoteTab:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:votes];
}
- (void) optionButton
{
    options                     = [[UIButton alloc] init];
    options.frame               = CGRectMake(50, 0, 50, 50);
    [options setImage:[UIImage imageNamed:@"options.png"] forState:UIControlStateNormal];
    options.tag = 1;
    [options addTarget:self action:@selector(showThisVoteTab:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:options];
}
- (void) ratingButton
{
    rating                      = [[UIButton alloc] init];
    rating.frame                = CGRectMake(100, 6, 50, 50);
    [rating setImage:[UIImage imageNamed:@"rating.png"] forState:UIControlStateNormal];
    rating.tag = 2;
    [rating addTarget:self action:@selector(showThisVoteTab:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rating];
}
- (void) sliderButton
{
    slider                      = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, 50, 50)];
    [slider setImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    slider.tag = 3;
    [slider addTarget:self action:@selector(showThisVoteTab:) forControlEvents:UIControlEventTouchUpInside];    [self addSubview:slider];
}

@end
