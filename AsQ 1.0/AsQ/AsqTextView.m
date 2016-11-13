//
//  AsqTextViewController.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 04/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsqTextView.h"

@implementation AsqTextView
@synthesize descTextView;
//@synthesize textView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.text = @"AsQ here...\u200B";
        self.textColor = [UIColor lightGrayColor];
        self.delegate = self;
        
    }
    return self;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)asqTextView
{
    if([self.text isEqualToString:@"AsQ here...\u200B"]){
        self.text = @"\u200B";
    }
    asqTextView.textColor = [UIColor blackColor];
    return YES;
}

//-(BOOL) textViewShouldEndEditing:(UITextView *)asqTextView
//{
////    NSstring asqText = asqTextView.text;
////    asqDataDictionary = 
//}

-(void) textViewDidChange:(UITextView *)asqTextView
{
    if(asqTextView.text.length == 0){
        asqTextView.textColor = [UIColor lightGrayColor];
        asqTextView.text = @"AsQ here...";
        [asqTextView resignFirstResponder];
    }
}

@end




