//
//  UpArrowUIView.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 05/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpArrowUIView : UIView

@property (nonatomic) BOOL isShowing;

-(void) show:(BOOL) animated;

-(void) hide:(BOOL) animated;

-(void) toggle:(BOOL) animated;

-(id) initWithFrame:(CGRect)frame color:(UIColor*) color;

@end


