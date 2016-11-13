//
//  AsqListCell.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 10/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsqListCell.h"
#import "HomeController.h"

@implementation AsqListCell

@synthesize quesObj;
@synthesize barObj;
@synthesize percentObj;
@synthesize timeIntervalFormatter;
@synthesize timestampLabel;
@synthesize incColumn, cellTag, loadedProfileImg,appDelegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(id)initCell :(NSString *)reuseIdentifier referenceClass:(HomeController*) referenceClass
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        homeVc = referenceClass;
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - methods for displaying question with style in cell

- (void) setQuestionPicture:(PFObject*) object
{
    PFImageView *PictureImageView;
    PFFile *file = [object objectForKey:@"image"];
    
    quesYOffset = 10.0f;
    if(file)
    {
        PictureImageView = [[PFImageView alloc] initWithFrame:CGRectMake( 7.0f, quesYOffset, 306.0f, 306.0f)];
           
        PictureImageView.file = file;
        quesYOffset+=PictureImageView.frame.size.height;
        if (imageFile) {
            [PictureImageView setFile:imageFile];
            
            [PictureImageView loadInBackground:^(UIImage *image, NSError *error) {
                if (!error) {
                    PictureImageView.image  = [self scaleImage:image toSize:CGSizeMake(306, 306)];
                    CGRect frame = PictureImageView.frame;
                    frame.size=PictureImageView.image.size;
                    PictureImageView.frame = frame;
                    [PictureImageView setNeedsDisplay];
                    [UIView animateWithDuration:0.200f animations:^{
                        PictureImageView.alpha = 1.0f;
                    }];
                }
            }];
        }
        [questionBox addSubview:PictureImageView];
    }
}

- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    float width = newSize.width;
    float height= newSize.height;
    if( image.size.width >= image.size.height ) {
        scaleFactor = image.size.height / image.size.width;
        height=width*scaleFactor;
    }
    else{
        scaleFactor = image.size.width / image.size.height;
        width=height*scaleFactor;
    }
    
    scaledSize.width=width;
    scaledSize.height=height;
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, width, height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
-(void) setupPollValues:(PFObject *) object nonDetail: (BOOL) isDetail
{
    globalIsDetail = isDetail;
    NSLog(@"initialize detailview::: %d",globalIsDetail);
    NSLog(@"setuppollvalues");
    percentObj = [[NSMutableArray alloc]init];
    quesObj = object;
    //CGFloat totalHeight = 10 + 35 + 10 + 0 + 10 + 10 + 60 + 10 + 35 + 10;
    totalHeight = 10 + 35 + 10 + 0 + 10 + 10 + 60 + 10 + 25 + 10;
    NSString *content = [object objectForKey:@"content"];
    CGSize constraint = CGSizeMake(296,9999);
    size = [content sizeWithFont:[UIFont boldSystemFontOfSize:16.0]
               constrainedToSize:constraint
                   lineBreakMode:UILineBreakModeWordWrap];
    totalHeight += size.height;// [content sizeWithFont:[UIFont boldSystemFontOfSize:14.0] forWidth:320 lineBreakMode:UILineBreakModeWordWrap].height;
    
    int voteType      = [(NSNumber *)[object objectForKey:@"pollType"] intValue];
    int allowUnknown  = [(NSNumber *)[object objectForKey:@"allowUnknown"] intValue];
    NSArray* optionsArray;
    if(voteType==0)
    {
        optionsArray = [object objectForKey:@"choices"];
        totalHeight += ([optionsArray count]*45.0f)-70.0f;
    }
    
    imageFile = [object objectForKey:@"image"];
    if (imageFile) {
        totalHeight += 306;
    }
    
//    for(UIView *view in [self.contentView subviews]){
//        [view removeFromSuperview];
//    }
    
    //**** setting background with a color and corder radius of 5.0f for question holder ****//
    
    questionBgView = [[UIView alloc] initWithFrame:CGRectMake(12, 10, 320-24, totalHeight-10)];
    questionBgView.backgroundColor=[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    questionBgView.layer.cornerRadius = 5.0f;
    [self.contentView addSubview:questionBgView];
    
    questionBoxBg = [[UIView alloc] initWithFrame:CGRectMake(0, 10+33, 320, questionBgView.frame.size.height-56)];
    questionBoxBg.backgroundColor=[UIColor colorWithRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0];
    questionBoxBg.layer.opacity = 0.6;
    
    questionBox = [[UIView alloc] initWithFrame:CGRectMake(0, 10+35, 320, questionBgView.frame.size.height-60)];
    questionBox.backgroundColor=[UIColor whiteColor];
    
    [self.contentView addSubview:questionBoxBg];
    [self.contentView addSubview:questionBox];
    
    //**** adding name and profile image ****//
    [self setNameAndPhoto:object];
    
    //**** adding question image to the question box ****//
    [self setQuestionPicture:object];
    
    //**** adding question content to the question box ****//
    [self setQuestionContent:object];
    
    //**** adding responses count in the bottom ****//
    if(!isDetail)
    {
        [self setResponseCount];
    }
    else
    {
         if(allowUnknown==0)
         {
             [self detailResponseCount];
         }
         else
        {
            [self setResponseCount];
        }
    }
        //**** adding time ago for the asq created time ****//
    [self timeStamp];
    
    if(voteType!=0)
    {
        [self setSmileyVotePannel:voteType];
    }
    else
    {
        [self setOptionVotePannel:optionsArray];
        [self setOptionVoteGraph:NULL];
    }
    
    resultHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, questionBgView.frame.size.height-26, 300.0f, 24.0f)];
    resultHolderView.userInteractionEnabled = YES;
    
    [questionBgView addSubview:resultHolderView];
    
    if(allowUnknown!=0)
    {
        [self setMaskForAnonymous];
    }
    if([(NSNumber*)[quesObj objectForKey:kASQParseShareDetailsResponseKey] intValue])
    {
        NSLog(@"voted already");
        questionBox.tag = 4;
    }
    resultHolderView.tag = 2;
}

#pragma mark - - to display time interval
-(void) timeStamp
{
    timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    NSTimeInterval timeInterval = [[quesObj createdAt] timeIntervalSinceNow];
    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(196.0, 2.0f, 94.0f,30.0f)];
    [self.timestampLabel setText:timestamp];
    timestampLabel.backgroundColor = [UIColor clearColor];
    [timestampLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:12.0f ]];
    timestampLabel.textAlignment = NSTextAlignmentRight;
    timestampLabel.textColor = [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0];
    [questionBgView addSubview:timestampLabel];
}

#pragma mark - - this is just to alter the last cell in detailview
- (void) detailResponseCount
{
    UIView *bottomDiv = [[UIView alloc] initWithFrame:CGRectMake(0, questionBgView.frame.size.height-26, 296.0f, 36.0f)];
    bottomDiv.backgroundColor = [UIColor colorWithRed:57.0/255 green:62.0/255 blue:62.0/255 alpha:1.0];
    [questionBgView addSubview:bottomDiv];
    UIButton *resultDiv =  [[UIButton alloc] initWithFrame:CGRectMake(16, questionBgView.frame.size.height-20, 280.0f, 24.0f)];
    
    UILabel *replied = [[UILabel alloc] initWithFrame:CGRectMake(48.0f, 8.0f, 100.0f, 15.0f)];
    replied.text     = [NSString stringWithFormat:@"%@",[quesObj objectForKey:kASQParseQuestionAnsCountKey]];
    replied.textColor          = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1.0];
    replied.backgroundColor    =[UIColor clearColor];
    [replied setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];

    
    UILabel *replied_txt   = [[UILabel alloc] initWithFrame:CGRectMake(0, 8.0f, 50.0f, 15.0f)];
    replied_txt.text               = @"Replied";
    replied_txt.textColor          = [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0];
    [replied_txt setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];
    replied_txt.backgroundColor    =[UIColor clearColor];
    
    
    UILabel *asqed_txt   = [[UILabel alloc] initWithFrame:CGRectMake(214, 8.0f, 50.0f, 15.0f)];
    asqed_txt.text               = @"AsQed";
    asqed_txt.textColor          = [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0];
    asqed_txt.backgroundColor    =[UIColor clearColor];
    [asqed_txt setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];
    
    UILabel *askedTo           = [[UILabel alloc] initWithFrame:CGRectMake(224.0f, 8.0f, 75.0f, 15.0f)];
    askedTo.textColor          = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1.0];
    askedTo.backgroundColor    = [UIColor clearColor];
    askedTo.font               = [replied_txt.font copy];
    askedTo.textAlignment      = NSTextAlignmentCenter;
    askedTo.text               = [NSString stringWithFormat:@"%@",[quesObj objectForKey:kASQParseQuestionAskedToKey]];
    [askedTo setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];
    
    [questionBgView addSubview:resultDiv];
    [resultDiv addSubview:replied_txt];
    [resultDiv addSubview:replied];
    [resultDiv addSubview:asqed_txt];
    [resultDiv addSubview:askedTo];    
}


#pragma mark - - method to set response counts
- (void) setResponseCount
{
    UIButton *resultDiv =  [[UIButton alloc] initWithFrame:CGRectMake(186, questionBgView.frame.size.height-26, 150.0f, 24.0f)];
    
    UILabel *replied_txt   = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 44.0f, 24.0f)];
    replied_txt.text               = @"Replied";
    replied_txt.textColor          = [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0];
    replied_txt.backgroundColor    =[UIColor clearColor];
    [replied_txt setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];
    
    NSString *of               = @"of";
    UILabel *askedTo           = [[UILabel alloc] initWithFrame:CGRectMake(26, 8, 75.0f, 15.0f)];
    askedTo.textColor          = [UIColor colorWithRed:96.0/255 green:163.0/255 blue:210.0/255 alpha:1.0];
    askedTo.backgroundColor    = [UIColor clearColor];
    askedTo.font               = [replied_txt.font copy];
    askedTo.textAlignment      = NSTextAlignmentCenter;
    askedTo.text               = [NSString stringWithFormat:@"%@ %@ %@",[quesObj objectForKey:kASQParseQuestionAnsCountKey],of, [NSString stringWithFormat:@"%@",[quesObj objectForKey:kASQParseQuestionAskedToKey]]];
    
    UIImageView* result_img = [[UIImageView alloc] initWithFrame:CGRectMake(88, 6, 15.0f, 15.0f)];
    [result_img setImage:[UIImage imageNamed:@"result.png"]];
    
    [questionBgView addSubview:resultDiv];
    [resultDiv addSubview:replied_txt];
    [resultDiv addSubview:askedTo];
    [resultDiv addSubview:result_img];
    
    //    [resultDiv addTarget:self action:@selector(detailView:) forControlEvents:UIControlEventTouchUpInside];
    //[resultDiv addSubview:of];
    //    [resultDiv addSubview:replied];
    //    [resultDiv addSubview:result_img];
}

#pragma mark - - method to set anonymous vote layout
- (void) setMaskForAnonymous
{
    questionBgView.backgroundColor = [UIColor colorWithRed:57.0/255 green:62.0/255 blue:62.0/255 alpha:1.0];
    UIImageView* mask_view = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 13, 20)];
    
    [mask_view setImage:[UIImage imageNamed:@"mask.png"]];
    UILabel *textAllowUnknown = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 150.0f, 16.0f)];
    textAllowUnknown.text = @"Votes are anonymous";
    textAllowUnknown.textColor = [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0];
    textAllowUnknown.backgroundColor =[UIColor colorWithRed:57.0/255 green:62.0/255 blue:62.0/255 alpha:1.0];
    [textAllowUnknown setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];
    [mask_view addSubview:textAllowUnknown];
    
    [resultHolderView addSubview:mask_view];
}

#pragma mark - - option type vote pannel design
- (void) setOptionVotePannel: (NSArray*) optionsArray
{
    NSNumber* votedVal      = (NSNumber *)[quesObj objectForKey:kASQParseShareDetailsResponseKey];
    int response            = [votedVal intValue];
    int arrayLen            = [optionsArray count];
    UIColor* green          = [UIColor colorWithRed:150.0/255 green:187.0/255 blue:97.0/255 alpha:1.0];
    UIColor* red            = [UIColor colorWithRed:235.0/255 green:138.0/255 blue:135.0/255 alpha:1.0];
    UIColor* violet         = [UIColor colorWithRed:135.0/255 green:95.0/255 blue:129.0/255 alpha:1.0];
    UIColor* orange         = [UIColor colorWithRed:242.0/255 green:179.0/255 blue:104.0/255 alpha:1.0];
    NSArray *colorValueObj  = [[NSArray alloc]initWithObjects:nil];
    barObj                  = [[NSMutableArray alloc]initWithObjects:nil];
    
    colorValueObj           = [NSArray arrayWithObjects:green, red, orange, violet, nil];
    if(arrayLen!=0)
    {
        voteBgView          = [[UIView alloc] initWithFrame:CGRectMake(8, size.height+10, 300, (arrayLen*70.f))];
    }
    float yOffset           = (totalHeight-30)-questionBox.frame.size.height;
    
    [questionBox addSubview:voteBgView];
    for (int i=0; i<arrayLen; i++) {
        
        UIView *optionContainer = [[UIView alloc] initWithFrame:CGRectMake(2, yOffset-20, 300, 36.0f)];
        //optionContainer.backgroundColor = [UIColor brownColor];
        
        /********* Adding a view to show option bg  **********/
        UIView* optionElement               = [[UIView alloc] initWithFrame:CGRectMake(2, 5, 296, 26.0f)];
        optionElement.layer.cornerRadius    = 12.0f;
        optionElement.layer.borderWidth     = 1.0f;
        optionElement.layer.borderColor     = [UIColor whiteColor].CGColor;
        optionElement.backgroundColor       = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
        
        /********* Adding a view to show option text label **********/
        UILabel *optionLabel        = [[UILabel alloc] initWithFrame:CGRectMake(40, 3, 250, 20.f)];
        optionLabel.textColor       = [UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:1.0];
        optionLabel.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
        optionLabel.text            = [optionsArray  objectAtIndex:i];
        [optionLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:15.0f ]];
        
        if(votedVal!=NULL)
        {
            if(response==i)
            {
                optionElement.backgroundColor       = [UIColor colorWithRed:117.0/255 green:174.0/255 blue:214.0/255 alpha:1.0];
                optionLabel.backgroundColor         = [UIColor colorWithRed:117.0/255 green:174.0/255 blue:214.0/255 alpha:1.0];
                optionLabel.textColor               = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0];
            }
            else
            {
                
                optionElement.backgroundColor       = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
                optionLabel.backgroundColor         = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
                optionLabel.textColor               = [UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:1.0];
            }
            optionContainer.userInteractionEnabled = NO;
            optionContainer.userInteractionEnabled = NO;
        }
        else
        {
            optionElement.backgroundColor       = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
            optionLabel.backgroundColor         = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
            optionLabel.textColor               = [UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:1.0];
            optionContainer.userInteractionEnabled    = YES;
            optionContainer.userInteractionEnabled      = YES;
        }
        
        /********* percentage indication bgcolor behind the view **********/
        UIView* graphStartBg            = [[UIView alloc] initWithFrame:CGRectMake(12, 5, 22, 26.0f)];
        graphStartBg.backgroundColor    = [colorValueObj objectAtIndex:i];
        graphStartBg.layer.cornerRadius  = 8.0f;
        
        UIView* optionGraph             = [[UIView alloc] initWithFrame:CGRectMake(12, 10, 0, 26.0f)];
        optionGraph.backgroundColor     = [colorValueObj objectAtIndex:i];
        optionGraph.layer.cornerRadius  = 10.0f;
        
        [barObj addObject:optionGraph];
        /********* Adding a rounded view to show percentage **********/
        UIView* percentRound            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36.0f)];
        percentRound.backgroundColor    = [colorValueObj objectAtIndex:i];
        percentRound.layer.cornerRadius = 18.0f;
        percentRound.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        percentRound.layer.shadowRadius = 3.0f;
        percentRound.layer.shadowColor  = [UIColor grayColor].CGColor;
        percentRound.clipsToBounds      = YES;
        
        /********* Adding the background 0.5 alpha % in the circle **********/
        UILabel *percentAlphaLabel          = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 16.0f, 22.0f)];
        percentAlphaLabel.backgroundColor   = [colorValueObj objectAtIndex:i];
        percentAlphaLabel.text              = @"%";
        percentAlphaLabel.textColor         = [UIColor whiteColor];
        percentAlphaLabel.alpha             = 0.2f;
        
        [percentAlphaLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:26.0f ]];
        
        /********* Adding the percentage number to the circle **********/
        percentNumberLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 36.0f, 36.0f)];
        percentNumberLabel.backgroundColor  = [colorValueObj objectAtIndex:i];

        percentNumberLabel.text             = @"0";
        percentNumberLabel.textAlignment    = NSTextAlignmentCenter;
        percentNumberLabel.textColor        = [UIColor whiteColor];
        percentNumberLabel.shadowColor      = [UIColor grayColor];
        percentNumberLabel.shadowOffset     = CGSizeMake(0.5, 1.0);
        [percentNumberLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:16.0f ]];
        [percentObj addObject:percentNumberLabel];
        
      
        /********* Finaly adding all the views to the voteBgView ********/
        [optionElement addSubview:optionGraph];
        [optionElement addSubview:optionLabel];
        
        UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        tapGestureRecognize.delegate                = self;
        tapGestureRecognize.numberOfTapsRequired    = 1;
        optionContainer.tag   =   i;
        [optionContainer addGestureRecognizer:tapGestureRecognize];
        
        [optionContainer addSubview:graphStartBg];
        [optionContainer addSubview:optionGraph];
        [optionContainer addSubview:optionElement];
        [optionContainer addSubview:percentRound];
        [percentRound addSubview:percentNumberLabel];
        if(votedVal==NULL)
        {
            percentNumberLabel.hidden = YES;
        }
        [percentRound insertSubview:percentAlphaLabel aboveSubview:percentNumberLabel];
        
        [voteBgView addSubview:optionContainer];
        yOffset += (i + 1 * 2.0f) + 40;
    }
}

-(void)singleTapGestureRecognizer:(UIGestureRecognizer *)sender
{
//    sender.view.backgroundColor = [UIColor colorWithRed:117.0/255 green:174.0/255 blue:214.0/255 alpha:1.0];
//    UILabel *subviewLabel = (UILabel*)[sender.view.subviews objectAtIndex:0];
    UIView* optionElement = (UIView*)[sender.view.subviews objectAtIndex:2];
    optionElement.backgroundColor = [UIColor colorWithRed:117.0/255 green:174.0/255 blue:214.0/255 alpha:1.0];
    UILabel *subviewLabel = (UILabel*)[optionElement.subviews objectAtIndex:0];
    subviewLabel.backgroundColor = [UIColor colorWithRed:117.0/255 green:174.0/255 blue:214.0/255 alpha:1.0];
    subviewLabel.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0];
    [self submitVote:[sender.view tag]];
    voteBgView.userInteractionEnabled = NO;
    for(int i = 0; i<[percentObj count]; i++)
    {
        UILabel* percent = (UILabel*)[percentObj objectAtIndex:i];
        percent.hidden = NO;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    //HomeController *asqTable = (HomeController *)self.superview;
    //asqTable.detailViewTag = touch.view.tag;
    self.cellTag = touch.view.tag;
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - - setting smiley type of vote in cell with design

- (void) setSmileyVotePannel: (int) voteType
{
    NSNumber* response = (NSNumber *)[quesObj objectForKey:kASQParseShareDetailsResponseKey];
    NSLog(@"setsmileyvote:: %@",response);
    voteBgView = [[UIView alloc] initWithFrame:CGRectMake(12, quesYOffset+5.0f, 296, 70.0f)];
    smileyVote = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *smiley        = [NSString stringWithFormat:@"%i.png",voteType];
    NSString *frowny        = [NSString stringWithFormat:@"other%i.png",voteType*-1];
    NSString *smileyVoted   = [NSString stringWithFormat:@"%iblue",voteType];
    NSString *frownyVoted   = [NSString stringWithFormat:@"other%iblue.png",voteType*-1];
    if(response && response!=NULL)
    {
        int votedFor = NULL;
        if([response isKindOfClass:[NSArray class]]){
            NSArray *vote = (NSArray*)response;
            votedFor = (int)[vote objectAtIndex:0];
        }
        else
        {
            votedFor = (int)[response intValue];
        }
        
        if(votedFor > 0)
        {
            smiley = smileyVoted;
        }
        else
        {
            frowny = frownyVoted;
        }
    }
    [smileyVote setImage:[UIImage imageNamed:smiley] forState:UIControlStateNormal];
    [smileyVote setImage:[UIImage imageNamed:smileyVoted] forState:UIControlStateHighlighted];
    smileyVote.frame = CGRectMake(0,12.0f,46.0f,46.0f);
    
    smileyVote.tag = voteType;
    [smileyVote addTarget:self action:@selector(voteTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    frownyVote = [UIButton buttonWithType:UIButtonTypeCustom];
    [frownyVote setImage:[UIImage imageNamed:frowny] forState:UIControlStateNormal];
    [frownyVote setImage:[UIImage imageNamed:frownyVoted] forState:UIControlStateHighlighted];
    frownyVote.frame = CGRectMake(50.0f,12.0f,46.0f,46.0f);
    frownyVote.tag = -1*voteType;
    [frownyVote addTarget:self action:@selector(voteTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [voteBgView addSubview:frownyVote];
    [voteBgView addSubview:smileyVote];
    [questionBox addSubview:voteBgView];
    
    if(response && response!=NULL)
    {  
        frownyVote.userInteractionEnabled = NO;
        smileyVote.userInteractionEnabled = NO;
        frownyVote.frame = CGRectMake(250.0f,12.0f,46.0f,46.0f);
        [self setSmileyVoteGraph:NULL];
        voteBgView.tag = 4;
    }
}

#pragma mark - - fixing content of question in cell

- (void) setQuestionContent: (PFObject*) object
{
    NSString *content = [object objectForKey:@"content"];
    CGSize constraint = CGSizeMake(296,9999);
    size = [content sizeWithFont:[UIFont boldSystemFontOfSize:16.0]
               constrainedToSize:constraint
                   lineBreakMode:UILineBreakModeWordWrap];
   
    UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, quesYOffset-10.0f, 300.0,size.height+30.0)];
    //quesLabel.backgroundColor = [UIColor yellowColor];
    [quesLabel setTag:1];
    
    [quesLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    quesLabel.text =  [object objectForKey:@"content"];
    
    [quesLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:16.0f ]];
    quesLabel.lineBreakMode=UILineBreakModeWordWrap;
    quesLabel.numberOfLines=0;
    quesYOffset+=5.0+size.height;
    
    //[quesLabel sizeToFit];
    [questionBox addSubview:quesLabel];
}

#pragma mark - - fixing photo and name in cell

- (void) setNameAndPhoto: (PFObject*) object
{
    NSLog(@"setNameandPhoto %s",loadedProfileImg);
    
    UIView *nameAndPhoto = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160.0f, 30.0f)];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(36.0, 2.0f, 130.0f,30.0f)];
    [nameLabel setTag:1];
    
    [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    nameLabel.text =  [ASQUtility firstNameForDisplayName:[object objectForKey:kASQParseQuestionAuthorNameKey]];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [nameLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];
    nameLabel.textColor = [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0];
    nameLabel.lineBreakMode=UILineBreakModeWordWrap;
    nameLabel.numberOfLines=0;
    quesYOffset+=5.0f+size.height;
    [nameAndPhoto addSubview:nameLabel];
    
    quesYOffset = 10.0f;

    NSString *path  = @"http://graph.facebook.com/";
    path = [path stringByAppendingFormat:@"%@/picture", [quesObj objectForKey:kASQParseQuestionownerFbIdKey]];
    NSLog(@"path::: %@",path);
    NSURL *url = [NSURL URLWithString:path];
    
    UIImageView*  avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 4.0f, 25.0f, 25.0f)];
    avatarImageView.image = [UIImage imageNamed:@"profile.png"];
        [ASQUtility downloadImageInImageView:avatarImageView withURL:url];
        [avatarImageView.layer setMasksToBounds:YES];
        [avatarImageView.layer setCornerRadius:5.0f];
        [nameAndPhoto addSubview:avatarImageView];
        [questionBgView addSubview:nameAndPhoto];
    nameAndPhoto.tag = 3;
}

#pragma mark - - graph bar for smiley type vote
- (void) setSmileyVoteGraph : (NSNumber *)votedFor
{
    NSNumber* response  = (NSNumber *)[quesObj objectForKey:@"response"];
    int dbVoteCount1    = [[quesObj objectForKey:kASQParseQuestionOpt0Key] intValue];
    int dbAnsCount      = [[quesObj objectForKey:kASQParseQuestionAnsCountKey] intValue];
    int ansCount        = dbVoteCount1;
    int voteCount1      = dbAnsCount;
    if(votedFor && votedFor!=NULL)
    {
        int ansCountInc = dbAnsCount+1;
        ansCount = ansCountInc;
        if([votedFor intValue] > 0)
        {
            int increment0 = dbVoteCount1+1;
            voteCount1 = increment0;
        }
    }
    else if(response && response!=NULL)
    {
        voteCount1  = dbVoteCount1;
        ansCount    = dbAnsCount;
    }
    
    int percent         = 0;
    int totalPixel      = 240;
    if(ansCount!=0)
    {
       // NSLog(@"voteCountdb;;;;:::ulla %d:::;%d",voteCount1,ansCount);
        percent = ((float)voteCount1/(float)ansCount)*100;
    }
    if(percent==0 || percent==100)
    {
        totalPixel = 227;
    }
    
    float multiplyPixel     = totalPixel/100.0;
    float greenPixel = percent*multiplyPixel;
    
    UIView *greenBarView = [[UIView alloc] initWithFrame:CGRectMake(23.0f, 26.0f, 0.0f,20.0f)];
    greenBarView.layer.cornerRadius =10.0f;
    greenBarView.backgroundColor=[UIColor colorWithRed:149.0/255 green:187.0/255 blue:109.0/255 alpha:1.0];
    greenBarView.tag = 4;
    
    CGRect greenFrameOfMyView = CGRectMake(23.0f, 26.0f, 20.0f, 20.0f);
    //adjust the width according to vote count
    greenFrameOfMyView.size.width = greenPixel;
    
    UIView *redBarView = [[UIView alloc] initWithFrame:CGRectMake(290.0f, 26.0f, 0.0f,20.0f)];
    redBarView.layer.cornerRadius =10.0f;
    redBarView.backgroundColor=[UIColor colorWithRed:235.0/255 green:137.0/255 blue:137.0/255 alpha:1.0];
    //redBarView.alpha = 0.5;
    redBarView.tag = 4;
    CGRect redFrameOfMyView = CGRectMake(296.0f, 26.0f, totalPixel-greenPixel, 20.0f);
    //adjust the x co-ordinate to vote count
    redFrameOfMyView.origin.x = greenFrameOfMyView.origin.x + greenPixel;
    if((100-percent)==100)
    {
        redFrameOfMyView.origin.x = greenFrameOfMyView.origin.x + greenPixel+23;
    }
    //voteBgView.backgroundColor = [UIColor brownColor];

    CGRect voteBgFrame = CGRectMake(voteBgView.frame.origin.x, voteBgView.frame.origin.y, voteBgView.frame.size.width, 70.0f);
    voteBgView.frame = voteBgFrame;
    
    [voteBgView insertSubview:greenBarView belowSubview:smileyVote];
    [voteBgView insertSubview:redBarView belowSubview:frownyVote];
    
    if(votedFor && votedFor!=NULL)
    {
        [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationCurveEaseIn animations:^{
            greenBarView.frame  =   greenFrameOfMyView;
            redBarView.frame    =   redFrameOfMyView;
        } completion:nil];
    }
    else
    {
        greenBarView.frame  =   greenFrameOfMyView;
        redBarView.frame    =   redFrameOfMyView;
    }
    
    UILabel *percent1Txt = [[UILabel alloc] initWithFrame:CGRectMake(4.0f,58.0f,36.0f,20.0f)];
    [percent1Txt setFont:[UIFont boldSystemFontOfSize:12.0]];
    [percent1Txt setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:12.0f ]];
    percent1Txt.backgroundColor = [UIColor clearColor];
    percent1Txt.textColor = [UIColor colorWithRed:141.0/255 green:141.0/255 blue:141.0/255 alpha:1.0];
    percent1Txt.text = [NSString stringWithFormat:@"%d%%", percent];
    percent1Txt.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *percent2Txt = [[UILabel alloc] initWithFrame:CGRectMake(256.0f,58.0f,36.0f,20.0f)];
    percent2Txt.backgroundColor = [UIColor clearColor];
    [percent2Txt setFont:[UIFont boldSystemFontOfSize:12.0]];
    [percent2Txt setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:12.0f ]];
    percent2Txt.textColor = [UIColor colorWithRed:141.0/255 green:141.0/255 blue:141.0/255 alpha:1.0];
    percent2Txt.text = [NSString stringWithFormat:@"%d%%", 100-percent];
    percent2Txt.textAlignment = NSTextAlignmentCenter;
    
    [voteBgView addSubview:percent1Txt];
    [voteBgView addSubview:percent2Txt];
}
#pragma mark - - graph bar animation for option type vote
- (void) setOptionVoteGraph : (NSNumber*) votedFor
{
    NSNumber* response = (NSNumber *)[quesObj objectForKey:@"response"];
    float voteCount;
    float ansCount = [(NSNumber*) [quesObj objectForKey:kASQParseQuestionAnsCountKey] floatValue];
    if(response==NULL && votedFor!=NULL)
    {
        ansCount    = ansCount+1;
    }
    for(int i = 0; i<[barObj count]; i++)
    {
        UIView *optionBar = (UIView*)[barObj objectAtIndex:i];
        CGRect frame    = optionBar.frame;
        
        voteCount = [(NSNumber*)[quesObj objectForKey:[NSString stringWithFormat:@"opt%d", i]] floatValue];

        if(response==NULL && votedFor!=NULL && [votedFor intValue]==i)
        {
            voteCount   = [(NSNumber*)[quesObj objectForKey:[NSString stringWithFormat:@"opt%d", [votedFor intValue]]] floatValue]+1;
        }
        
        int percent = 0;
        float extra = 0.0;
        if(ansCount!=0)
        {
            percent   = round((voteCount/ansCount)*100);
            
            NSLog(@"percent:::%d",percent);
        }
        if(percent!=NAN)
        {
            extra = 9.0f;
            frame.size.width = (percent*2.7)+extra;
        }
        if(votedFor!=NULL)
        {
            [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationCurveEaseIn animations:^{
                optionBar.frame = frame;
            } completion:nil];
        }
        else if(response!=NULL)
        {
            optionBar.frame = frame;
        }
        UILabel *votePercent = (UILabel*)[percentObj objectAtIndex:i];
        votePercent.text = [NSString stringWithFormat:@"%d", percent];
    }
}
#pragma mark - - submiting vote to server

-(void) submitVote:(int)voteId
{
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:quesObj.objectId, @"quesId", [quesObj objectForKey:@"shareId"], @"shareId",@"",@"oldVoteOption",voteId, @"voteOption", nil];
    
    [PFCloud callFunctionInBackground:@"updateQuestionTable"
                       withParameters:dict
                                block:^(NSString *results, NSError *error) {
                                    if (!error) {
                                        // this is where you handle the results and change the UI.
                                        NSLog(@"response::: %@",results);
                                        
                                    }
                                }];
//   PFObject *obj = [PFObject objectWithoutDataWithClassName:kASQParseQuestionClassKey objectId:quesObj.objectId];
//    
//    int pollType    = [[quesObj objectForKey:kASQParseQuestionPollTypeKey] intValue];
//    
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionAllowUnknownKey] forKey:kASQParseQuestionAllowUnknownKey];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionAskedByKey]      forKey:kASQParseQuestionAskedByKey];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionAskedToKey]      forKey:kASQParseQuestionAskedToKey];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionAuthorNameKey]   forKey:kASQParseQuestionAuthorNameKey];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionContentKey]      forKey:kASQParseQuestionContentKey];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionFreezeKey]       forKey:kASQParseQuestionFreezeKey];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionOpt0Key]         forKey:kASQParseQuestionOpt0Key];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionOpt1Key]         forKey:kASQParseQuestionOpt1Key];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionOpt2Key]         forKey:kASQParseQuestionOpt2Key];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionOpt3Key]         forKey:kASQParseQuestionOpt3Key];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionPollTypeKey]     forKey:kASQParseQuestionPollTypeKey];
//    [obj setObject:[quesObj objectForKey:kASQParseQuestionownerFbIdKey]     forKey:kASQParseQuestionownerFbIdKey];
//    NSLog(@"quesObj.ACL::: %@",quesObj.ACL);
//    //obj.ACL = quesObj.ACL;
//    PFACL *defaultACL = [PFACL ACL];
//    // Optionally enable public read access while disabling public write access.
//    [defaultACL setPublicReadAccess:YES];
//    [defaultACL setPublicWriteAccess:YES];
//    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
//    obj.ACL = defaultACL;
//
//    if([quesObj objectForKey:kASQParseQuestionChoicesKey]!=NULL)
//    {
//        [obj setObject:[quesObj objectForKey:kASQParseQuestionChoicesKey] forKey:kASQParseQuestionChoicesKey];
//    }
//    if([quesObj objectForKey:kASQParseQuestionImageKey]!=NULL)
//    {
//        [obj setObject:[quesObj objectForKey:kASQParseQuestionImageKey] forKey:kASQParseQuestionImageKey];
//    }
//
//    incColumn = @"opt1";
//    if([[quesObj objectForKey:kASQParseQuestionPollTypeKey] intValue]==0)
//    {
//        incColumn = (NSString*)[NSString stringWithFormat:@"opt%d", voteId];
//    }
//    if(pollType!=0)
//    {
//        if(voteId>=1)
//        {
//            [obj incrementKey:kASQParseQuestionOpt0Key byAmount:[NSNumber numberWithInt:1]];
//        }
//        else
//        {
//            [obj incrementKey:kASQParseQuestionOpt1Key byAmount:[NSNumber numberWithInt:1]];
//        }
//        [obj incrementKey:kASQParseQuestionAnsCountKey byAmount:[NSNumber numberWithInt:1]];
//        [self setSmileyVoteGraph:[NSNumber numberWithInt:voteId]];
//    }
//    else
//    {
//        [obj incrementKey:incColumn byAmount:[NSNumber numberWithInt:1]];
//        [obj incrementKey:kASQParseQuestionAnsCountKey byAmount:[NSNumber numberWithInt:1]];
//        [self setOptionVoteGraph:[NSNumber numberWithInt:voteId]];
//    }
//
//   
//    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        
//        NSLog(@"save obj updated::::%@",obj);
//        if(!error)
//        {
//            [quesObj setObject:[NSNumber numberWithInt:voteId] forKey:kASQParseShareDetailsResponseKey];
//            [quesObj setObject:[obj objectForKey:kASQParseQuestionOpt0Key] forKey:kASQParseQuestionOpt0Key];
//            [quesObj setObject:[obj objectForKey:kASQParseQuestionOpt1Key] forKey:kASQParseQuestionOpt1Key];
//            [quesObj setObject:[obj objectForKey:kASQParseQuestionOpt2Key] forKey:kASQParseQuestionOpt2Key];
//            [quesObj setObject:[obj objectForKey:kASQParseQuestionOpt3Key] forKey:kASQParseQuestionOpt3Key];
//            
//            [quesObj setObject:[obj objectForKey:kASQParseQuestionAnsCountKey] forKey:kASQParseQuestionAnsCountKey];
//            NSLog(@"detailview::: %d",globalIsDetail);
//            if(globalIsDetail)
//            {
//                [homeVc refreshCellData:quesObj];
//            }
//            [self updateShareTable:voteId];
//        }
//    }];
}

#pragma mark - # sending push notification to whoever participated and to the owner
-(void) sendPushNotification: (int) voteId
{
    NSLog(@"push...voteid::: %d",voteId);
    PFObject *ques = [PFObject objectWithClassName:kASQParseQuestionClassKey];
    ques.objectId = quesObj.objectId;
    
    PFQuery *query = [PFQuery queryWithClassName:kASQParseShareDetailsClassKey];
    [query includeKey:kASQParseShareDetailsQuestionIdKey];
    
    [query whereKey:kASQParseShareDetailsQuestionIdKey equalTo:ques];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         for (PFObject *object in objects) {
             PFObject *ques  = [object objectForKey:kASQParseShareDetailsQuestionIdKey];
             NSString *sharedTo  = [object objectForKey:kASQParseShareDetailsSharedToKey];
             int response  = [(NSNumber*)[object objectForKey:kASQParseShareDetailsResponseKey] intValue];
             PFUser *sharedUser  = (PFUser *)[object objectForKey:kASQParseShareDetailsSharedUserKey];
             NSString *owner = [ques objectForKey:kASQParseQuestionownerFbIdKey];
             PFUser *ownerUser = (PFUser *)[ques objectForKey:kASQParseQuestionAskedByKey];
             if(sharedTo!=owner)
             {
                 [ASQUtility sendAnswerPushNotification:ques forUser:ownerUser];
             }
             if(sharedTo!=owner && response<=-6)
             {
                 [ASQUtility sendAnswerPushNotification:ques forUser:sharedUser];
             }
         }
     }
    ];
}


#pragma mark - # updating shareDetails table with response data

-(void) updateShareTable:(int)voteId
{
   
//    [self sendPushNotification:voteId];
//    PFACL *defaultACL = [PFACL ACL];
//    [defaultACL setPublicWriteAccess:YES];
//    [defaultACL setPublicReadAccess:YES];
//    
//    PFObject *ques = [PFObject objectWithClassName:kASQParseQuestionClassKey];
//    ques.objectId = quesObj.objectId;
//    
//    PFQuery *query = [PFQuery queryWithClassName:kASQParseShareDetailsClassKey];
//    [query whereKey:kASQParseShareDetailsQuestionIdKey equalTo:ques];
//    [query whereKey:kASQParseShareDetailsSharedUserKey equalTo:[PFUser currentUser]];
//    
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *shareObj, NSError *error) {
//        if (shareObj) {
//            [shareObj setObject:[shareObj objectForKey:kASQParseShareDetailscreatedTimeKey] forKey:kASQParseShareDetailscreatedTimeKey];
//            [shareObj setObject:ques forKey:kASQParseShareDetailsQuestionIdKey];
//            [shareObj setObject:[shareObj objectForKey:kASQParseShareDetailsOwnerIdKey] forKey:kASQParseShareDetailsOwnerIdKey];
//            
//            [shareObj setObject:[shareObj objectForKey:kASQParseShareDetailsPersonNameKey] forKey:kASQParseShareDetailsPersonNameKey];
//            [shareObj setObject:[shareObj objectForKey:kASQParseShareDetailsSharedUserKey] forKey:kASQParseShareDetailsSharedUserKey];
//            
//            [shareObj setObject:[shareObj objectForKey:kASQParseShareDetailsSharedToKey] forKey:kASQParseShareDetailsSharedToKey];
//            [shareObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                
//                // will get send to the cloud.
//                [shareObj setObject:[NSNumber numberWithInt:voteId] forKey:kASQParseShareDetailsResponseKey];
//                shareObj.ACL = defaultACL;
//                [shareObj saveInBackground];
//            }];
//            
//        } else {
//            // The find didn't succeeded.
//            NSLog(@"The getFirstObject request failed.%@",shareObj);
//        }
//    }];
}

//-(void) detailView : (id) sender
//{
//    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
//    detailView.backgroundColor = [UIColor purpleColor];
//    [self.superview addSubview:detailView];
//    self.superview.userInteractionEnabled = NO;
//}
-(void) voteTapped : (id) sender
{
    int responsetag = (int)[sender tag];
    unsigned int response   = responsetag;
    NSString *smileyVoted   = [NSString stringWithFormat:@"%dblue",response];
    NSString *frownyVoted   = [NSString stringWithFormat:@"other%dblue.png",response];
    NSString *selectedVote  = [[NSString alloc] init];
    if(responsetag>0)
    {
        selectedVote = smileyVoted;
        [frownyVote setImage:[UIImage imageNamed:[NSString stringWithFormat:@"other%d.png",response*-1]] forState:UIControlStateNormal];
    }
    else
    {
        selectedVote = frownyVoted;
        
        [smileyVote setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",response*-1]] forState:UIControlStateNormal];
    }
[quesObj addObject:[NSNumber numberWithInteger: response] forKey:kASQParseShareDetailsResponseKey];
    smileyVote.userInteractionEnabled = NO;
    frownyVote.userInteractionEnabled = NO;
    [sender setImage:[UIImage imageNamed:selectedVote] forState:UIControlStateNormal];
    CGRect frame = ((UIButton *)sender).frame;
    frame.origin.x = 250.0f;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         frownyVote.frame = frame;
                     }
                     completion:^(BOOL finished){
                         [self submitVote:[sender tag]];
                     }];
}

-(void) insertOrUpdateIntoFolders : (PFObject*) quesObj{
    
    NSArray  *choices;
    NSString *quesId        = @"nGokMLEJmm";
    NSString *shareId       = @"nGokMLEJmm";
    NSString *askedBy       = @"Revathy";
    NSString *userId        = @"kwMEVW6hv7";
    int      questionType   = 1;
    NSString *question      = @"hi heerwer";
    int      freeze         = 0;
    NSString *imagedata     = @"";
    int      opt0           = 0;
    int      opt1           = 0;
    int      opt2           = 0;
    int      opt3           = 0;
    int      answerCount    = 0;
    int      response       = 1;
    NSString *askedTo       = @"Sreerevathy";
    int      allowUnknown   = 0;
    NSDate   *createdAt       = [NSDate dateWithTimeIntervalSinceReferenceDate:118800];
    
    NSString *insertSQL=[NSString stringWithFormat:@"INSERT OR REPLACE INTO userQuestions (quesId, shareId, userId, askedBy, questionType, question, choices, freeze, imagedata, opt0, opt1, opt2, opt3, ansCount, response, askedTo, allowUnknown, createdAt) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%@\",\"%@\",\"%d\",\"%@\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%d\",\"%@\")", quesId, shareId, userId, askedBy, questionType, question, choices,freeze, imagedata, opt0, opt1, opt2, opt3, answerCount, response, askedTo, allowUnknown, createdAt];
    
    sqlite3_stmt *addStatement;
    
    const char *insert_stmt=[insertSQL UTF8String];
    sqlite3_prepare_v2(contactDB,insert_stmt,-1,&addStatement,NULL);
    
    if (sqlite3_step(addStatement)==SQLITE_DONE) {
        
        //        NSLog(@"KEYWORDS Data saved");
        
    }
}
@end
