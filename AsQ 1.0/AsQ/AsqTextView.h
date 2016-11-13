//
//  AsqTextViewController.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 04/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsqTextView : UITextView <UITextViewDelegate>
{
    UITextView*  descTextView;
}
@property(nonatomic, copy) UITextView* descTextView;
@end