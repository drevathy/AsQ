//
//  AsQNoficationController.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsQNoficationController.h"

@interface AsQNoficationController ()

@end

@implementation AsQNoficationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title  =   @"Notifications";
    }
    return self;
}

-(void) loadView
{
    [super loadView];
    
    self.title          =   @"Notifications";
    CGFloat nRed        =   238.0/255.0;
    CGFloat nBlue       =   238.0/255.0;
    CGFloat nGreen      =   238.0/255.0;
    self.view.backgroundColor   =   [[UIColor alloc]initWithRed:nRed green:nBlue blue:nGreen alpha:1];
    
    UIButton *cancelBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelBtnImage = [UIImage imageNamed:@"backgroundBtn.png"];
    [cancelBtn setBackgroundImage:cancelBtnImage forState:UIControlStateNormal];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 50, 44);
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];

    self.navigationItem.rightBarButtonItem   =   cancel;
}
-(void) dismissView
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
