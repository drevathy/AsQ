//
//  UpArrowUIView.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 05/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "UpArrowUIView.h"

@implementation UpArrowUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (float) hypotenuse {
    
    return (CGFloat)self.frame.size.width / sqrt(2.0);
    
}

-(id) initWithFrame:(CGRect)frame color:(UIColor*) color {
    
    if (self = [super initWithFrame:frame]) {
        
        self.isShowing = YES;
        
        
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        //        CGPathMoveToPoint(path,NULL,0.0,0.0);
        
        //        CGPathAddLineToPoint(path, NULL, 0.0f, 0.0f);
        
        //        CGPathAddLineToPoint(path, NULL, frame.size.width, 0.0f);
        
        //        CGPathAddLineToPoint(path, NULL, frame.size.width/2.0, frame.size.height);
        
        
        
        CGPathMoveToPoint(path,NULL,0.0,0.0);
        
        CGPathAddLineToPoint(path, NULL, frame.size.width, 0);
        
        CGPathAddLineToPoint(path, NULL, frame.size.width/2,  frame.size.height*-1);
        
        CGPathAddLineToPoint(path, NULL, frame.size.width/2, frame.size.height*-1);
        
        
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        [shapeLayer setPath:path];
        
        [shapeLayer setFillColor:[[UIColor colorWithRed:206.0/255 green:206.0/255 blue:206.0/255 alpha:1.0] CGColor]];
        
        
        
        [self.layer addSublayer:shapeLayer];
        
        
        
        CGPathRelease(path);
        
        
        
        [self setAnchorPoint:CGPointMake(0.5, 0.0) forView:self];
        
        
        
    }
    
    return self;
    
}

-(void) show:(BOOL) animated {
    
    if (!self.isShowing) {
        
        if (animated) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.layer setTransform: CATransform3DRotate(self.layer.transform, (1/4.0)*M_PI, 1.0, 0.0, 0.0)];
                
            }];
            
        }
        
        {
            
            [self.layer setTransform: CATransform3DRotate(self.layer.transform,(1/4.0)*M_PI, 1.0, 0.0, 0.0)];
            
        }
        
    }
    
    
    
    self.isShowing = YES;
    
}



//Allows setting of the anchor point for animations without moving the sublayers (i.e the drawn arrow) to the origin of the anchor

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view

{
    
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    
    
    CGPoint position = view.layer.position;
    
    
    
    position.x -= oldPoint.x;
    
    position.x += newPoint.x;
    
    
    
    position.y -= oldPoint.y;
    
    position.y += newPoint.y;
    
    
    
    view.layer.position = position;
    
    view.layer.anchorPoint = anchorPoint;
    
}

-(void) hide:(BOOL) animated {
    
    if (self.isShowing) {
        
        if (animated) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.layer setTransform: CATransform3DRotate(self.layer.transform, -(1/4.0)*M_PI,1.0, 0.0, 0.0)];
                
                
                
            }];
            
        }
        
        {
            
            [self.layer setTransform: CATransform3DRotate(self.layer.transform, -(1/4.0)*M_PI, 1.0, 0.0, 0.0)];
            
        }
        
    }
    
    self.isShowing = NO;
    
}

-(void) toggle:(BOOL) animated {
    
    if (self.isShowing) {
        
        [self hide:animated];
        
    }
    
    else {
        
        [self show:animated];
        
    }
    
}
@end
