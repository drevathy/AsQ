//
//  AsqTextViewController.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 04/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsqTextView.h"
#import "AsQCreatePoll.h"

@implementation AsqTextView

@synthesize descTextView;
@synthesize polldel;

//@synthesize textView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = CGRectMake(0, 2, 320, 140);
        [self setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:17.0f ]];
        self.textColor = [UIColor darkGrayColor];
        self.backgroundColor = [UIColor whiteColor];
        self.delegate=self;
        // Initialization code
        askHere = [[UILabel alloc] initWithFrame:CGRectMake(8, 12, 100, 15)];
        askHere.text = @"AsQ here...";
        [askHere setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:17.0f ]];
        askHere.textColor = [UIColor darkGrayColor];
        [self addSubview:askHere];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    askHere.hidden = YES;
    self.polldel.scrollView.contentSize = CGSizeMake(320, 400);
    if(askHere.hidden){
        self.textColor = [UIColor blackColor];
        //self.text = @"\u200B";
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)asqTextView
{
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         NSLog(@"%@",voteView);
                     }
                     completion:^(BOOL finished){
                     }];
    if(asqTextView.text.length == 0){
        askHere.hidden = NO;
    }
    else
    {
        askHere.hidden = YES;
    }
}

@end




