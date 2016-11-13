//
//  AsQCreatePoll.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 03/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsQCreatePoll.h"
#import "AsqTextView.h"
#import "VoteOptionView.h"
#import "RESwitch.h"
#import "FriendsView.h"
#import "HomeController.h"

@interface AsQCreatePoll ()

@end

@implementation AsQCreatePoll

@synthesize window;
@synthesize navigationController;
@synthesize delegate, scrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle Methods

-(void) loadView
{
    [super loadView];
    
    self.title          =   @"Create Poll";
    CGFloat nRed        =   238.0/255.0;
    CGFloat nBlue       =   238.0/255.0;
    CGFloat nGreen      =   238.0/255.0;
    self.view.backgroundColor   =   [[UIColor alloc]initWithRed:nRed green:nBlue blue:nGreen alpha:1];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Q_Logo.png"]];
    
    UIButton *cancelBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelBtnImage = [UIImage imageNamed:@"backgroundBtn.png"];
    [cancelBtn setBackgroundImage:cancelBtnImage forState:UIControlStateNormal];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 50, 44);
    cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIButton *editBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *editBtnImage = [UIImage imageNamed:@"backgroundBtn.png"];
    [editBtn setBackgroundImage:editBtnImage forState:UIControlStateNormal];
    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [editBtn addTarget:self action:@selector(backToEditPoll) forControlEvents:UIControlEventTouchUpInside];
    editBtn.frame = CGRectMake(0, 0, 50, 44);
    edit = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    UIButton *nextBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *nextBtnImage = [UIImage imageNamed:@"backgroundBtn.png"];
    [nextBtn setBackgroundImage:nextBtnImage forState:UIControlStateNormal];
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [nextBtn addTarget:self action:@selector(pollNext) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(0, 0, 50, 44);
    next = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    
    UIButton *saveBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *saveBtnImage = [UIImage imageNamed:@"backgroundBtn.png"];
    [saveBtn setBackgroundImage:saveBtnImage forState:UIControlStateNormal];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveBtn addTarget:self action:@selector(pollSend) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.frame = CGRectMake(0, 0, 50, 44);
    save = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    self.navigationItem.leftBarButtonItems  = [NSArray arrayWithObjects:cancel, nil];

    self.navigationItem.rightBarButtonItems =  [NSArray arrayWithObjects:next, nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(320, 400);
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [createPollView addSubview:scrollView];
    
    createPollView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    createPollView.backgroundColor = [UIColor whiteColor];
    createPollView.hidden          =  NO;
    [scrollView addSubview:createPollView];
    [self.view addSubview:scrollView];
    
    if(friendListView==nil){
        
    friendListView        =   [[FriendsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height-45)];
    
    friendListView.backgroundColor      = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    //friendListView.hidden               =  YES;
     
    [self.view addSubview:friendListView];
    }
    [self asqLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Local Methods

- (void) asqTextView
{
    float textBoxHeight = [UIScreen mainScreen].bounds.size.height - 334;
    descTextView         =  [[AsqTextView alloc] init];
    
    
    NSLog(@"height of textbox %f",textBoxHeight);
    descTextView.frame = CGRectMake(0, 0, 250,textBoxHeight+4);
    
    descTextView.polldel=self;
    //descTextView.delegate=self;
    [createPollView  addSubview:descTextView];

     [descTextView becomeFirstResponder];
    // single tap to resign (hide) the keyboard
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.cancelsTouchesInView = NO;
    [createPollView addGestureRecognizer:singleTapRecognizer];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"shouldChangeTextInRange:::");
    
    return YES;
}

/**
 * Handles a recognized single tap gesture.
 */
- (void) handleTapFrom: (UITapGestureRecognizer *) recognizer {
    // hide the keyboard
    NSLog(@"hiding the keyboard");
    [descTextView resignFirstResponder];
}


- (void) addCameraButton
{
    UIImageView *clip       = [[UIImageView alloc] initWithFrame:CGRectMake(300, 4, 18, 18)];
    clip.image              = [UIImage imageNamed:@"clip.png"];

    cameraButton            =   [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame      =   CGRectMake(260, 10, 53, 41);
    
    [cameraButton setImage:[UIImage imageNamed:@"uploadpic.png"] forState:UIControlStateNormal];
    cameraButton.contentMode = UIViewContentModeScaleAspectFit;
    
    [cameraButton addTarget:self action:@selector(btnTakePicture_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [createPollView addSubview:cameraButton];
        [createPollView addSubview:clip];
    
    NSLog(@"Add camera button...");
}
- (void) asqTextBg
{
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 320, 156)];
    [createPollView addSubview:myLabel];
}

- (void) votesAndOptions
{
    float voteOptionXPos = [UIScreen mainScreen].bounds.size.height - 330;
    voteOptionView     =  [[VoteOptionView alloc] initWithFrame:CGRectMake(0,voteOptionXPos, 320, 350)];
    voteOptionView.backgroundColor   =  [UIColor colorWithRed:73.0/255 green:118.0/255 blue:150.0/255 alpha:1.0];
    voteOptionView.polldel=self;
    
    [createPollView  addSubview:voteOptionView];
}

//Constructing asq layout

- (void) asqLayout
{
    [self asqTextBg];
    [self asqTextView];
    [self addCameraButton];
    [self votesAndOptions];
    [self anonymousToggle];
    
    NSLog(@"hi there...");  
}

#pragma mark - anonymous on/off toggle

- (void) anonymousToggle
{
    switchView = [[RESwitch alloc] initWithFrame:CGRectMake(218, 4, 94, 40)];
    [switchView setBackgroundImage:[UIImage imageNamed:@"Switch_Background"]];
    //[switchView setBackgroundColor:[UIColor colorWithRed:102.0/255 green:152.0/255 blue:187.0/255 alpha:1.0]];
    [switchView setKnobImage:[UIImage imageNamed:@"switchBlueKnob"]];
    [switchView setOverlayImage:[UIImage imageNamed:@"Switch_Background"]];
    [switchView setHighlightedKnobImage:nil];
    [switchView setCornerRadius:0];
    [switchView setKnobOffset:CGSizeMake(0, 0)];
    [switchView setTextShadowOffset:CGSizeMake(0, 0)];
    [switchView setFont:[UIFont boldSystemFontOfSize:14]];
    [switchView setTextOffset:CGSizeMake(0, 0) forLabel:RESwitchLabelOn];
    [switchView setTextOffset:CGSizeMake(20, 0) forLabel:RESwitchLabelOff];
    [switchView setTextColor:[UIColor blackColor] forLabel:RESwitchLabelOn];
    [switchView setTextColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forLabel:RESwitchLabelOn];
    [switchView setTextColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forLabel:RESwitchLabelOff];
    
    switchView.layer.cornerRadius = 5;
    switchView.layer.masksToBounds = YES;
    [switchView addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
    
//    UILabel *anonymousLabel         = [[UILabel alloc] initWithFrame:CGRectMake(62, 352, 120, 32)];
//    anonymousLabel.text             = @"Anonymous";
//    anonymousLabel.textColor        = [UIColor colorWithRed:85/255.0 green:147/255.0 blue:190/255.0 alpha:1];
//    anonymousLabel.backgroundColor  = [UIColor clearColor];
//    [anonymousLabel setFont:[UIFont boldSystemFontOfSize:14]];
//
//    [createPollView addSubview:anonymousLabel];   
    
    
    [voteOptionView addSubview:switchView];
    
    switchView.on = NO;
}

- (void)switchViewChanged:(RESwitch *)swichToggle
{
    NSLog(@"Value: %i", swichToggle.on);
    anonymous = swichToggle.on;
}

#pragma mark - Camera accessing methods
- (void) changeCameraThumb
{
    [cameraButton setImage:[[UIImage alloc] initWithData:dataImage] forState:UIControlStateNormal];
    cameraButton.contentMode = UIViewContentModeScaleAspectFit;
//    UILabel *remove         = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, 68, 20)];
//    remove.text             = @"Remove";
//    remove.textColor        = [UIColor whiteColor];
//    remove.backgroundColor  = [[UIColor alloc]initWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
//    [cameraButton addSubview:remove];
    cameraButton.tag = 1;
}
- (void)btnTakePicture_Clicked:(id)sender
{
    [descTextView resignFirstResponder];
    UIActionSheet *cameraActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallery", nil];
    NSLog(@"[sender tag]::: %d",[sender tag]);
    if([sender tag]==1)
    {
        cameraActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallery", @"Delete",nil];
    }
    cameraActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    cameraActionSheet.alpha=0.90;
    cameraActionSheet.tag = 1;
    [cameraActionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)cameraActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (cameraActionSheet.tag)
	{
		case 1:
			switch (buttonIndex)
		{
			case 0:
			{
                #if TARGET_IPHONE_SIMULATOR
				
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Saw Them" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				
                #elif TARGET_OS_IPHONE
				
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				picker.delegate = self;
				picker.allowsEditing = YES;
				[self presentModalViewController:picker animated:YES];
				
                #endif
			}
                break;
			case 1:
			{
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				picker.delegate = self;
                picker.allowsEditing = YES;
				[self presentModalViewController:picker animated:YES];
			}
				break;
            case 2:
			{
                [cameraButton setImage:[UIImage imageNamed:@"uploadpic.png"] forState:UIControlStateNormal];
                cameraButton.tag = 0;
			}
				break;
		}
			break;
			
		default:
            break;
	}
}

//	edit selected image

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    imgPicture.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	dataImage           =   UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"],1);
	imgPicture.image    =  [[UIImage alloc] initWithData:dataImage];
    [self changeCameraThumb];
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	NSLog(@"UIImagePickerControllerDelegate imagePickerControllerDidCancel");
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Local Methods

-(void) backToEditPoll
{
    self.navigationItem.leftBarButtonItems  = [NSArray arrayWithObjects:cancel, nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:next, nil];
    [UIView beginAnimations:@"categories_panel" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition: UIViewAnimationOptionAutoreverse forView:friendListView cache:NO];
    [UIView setAnimationDuration:0.6];
    friendListView.frame = CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void) pollNext
{
    [friendListView loadView];
    [voteOptionView.globalOptionField resignFirstResponder];
    [descTextView resignFirstResponder];
    self.navigationItem.leftBarButtonItems  = [NSArray arrayWithObjects:edit, nil];
    self.navigationItem.rightBarButtonItems =  [NSArray arrayWithObjects:save, nil];
    
    [UIView beginAnimations:@"categories_panel" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition: UIViewAnimationOptionAutoreverse forView:friendListView cache:NO];
    
    [UIView setAnimationDuration:0.6];
    friendListView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void) pollSend
{
    NSString *authorName = (NSString *)[[PFUser currentUser] objectForKey:kASQParseUserDisplayNameKey];
    NSMutableDictionary* asqDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *optionsText = [[NSMutableArray alloc] init];
    NSArray *optionObjs = voteOptionView.allOptionsArray;
    
    [asqDictionary setValue:descTextView.text forKey:@"question"];
    [asqDictionary setValue:[NSNumber numberWithInt:voteOptionView.voteType] forKey:@"voteType"];
    
    if(voteOptionView.voteType==0)
    {
        for(int i=0; i<[optionObjs count]; i++)
        {
            UITextField *textVal = (UITextField*)[optionObjs objectAtIndex:i];
            NSLog(@"textVal.text::::%@",textVal.text);
            if(textVal!=Nil && !([textVal.text isEqual:@""]) && textVal.text!=NULL)
            {
                [optionsText addObject:textVal.text];
            }
            if(i==([optionObjs count]-1))
            {
                [asqDictionary setValue:optionsText forKey:@"optionsArray"];
                NSLog(@"Options array::::%@:::: %d",optionsText,[optionObjs count]);
            }
        }
    }
    if(dataImage != nil){
        [asqDictionary setValue:dataImage forKey:@"imageData"];
    }
    [asqDictionary setValue:authorName forKey:@"authorName"];
    [asqDictionary setValue:[NSNumber numberWithInt:anonymous] forKey:@"allowUnknown"];

    if([delegate respondsToSelector:@selector(pollSaveToDB: withArray:)]){
        [delegate pollSaveToDB: asqDictionary withArray:friendListView.selectedMembers_array];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void) saveAndGoToHome
{
    homeListView    =   [[HomeController alloc] init];
    [self.navigationController pushViewController:homeListView animated:YES];
}

-(void) dismissView
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)hideKeyBoard
{
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didShow) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(didHide) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
