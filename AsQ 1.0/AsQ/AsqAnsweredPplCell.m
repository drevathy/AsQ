//
//  AsqAnsweredPplCell.m
//  AsQ
//
//  Created by drevathy-0847 on 4/29/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsqAnsweredPplCell.h"

@implementation AsqAnsweredPplCell
@synthesize timeIntervalFormatter;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    //    // Configure the view for the selected state
    //    UIView *bgColorView = [[UIView alloc] init];
        self.BackgroundColor = [UIColor clearColor];
    //    [self setSelectedBackgroundView:bgColorView];
}

-(void) initialSetup
{
    // initial setup
}

-(void) setupVotedPeople:(PFObject*) profileData thisPersonvote :(NSNumber*)thisPersonVote
{
    friendObj = profileData;
    NSNumber *response = [profileData objectForKey:@"response"];
    NSArray *poll = [profileData objectForKey:@"pollType"];
    NSNumber *pollType = [poll objectAtIndex:0];
    NSLog(@"pollType::: %@",pollType);
    
    nameAndPicView = [[UIView alloc] initWithFrame:CGRectMake(12.0f, 0, 296.0f, 40.0f)];
    nameAndPicView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    [self addSubview:nameAndPicView];
    //self.textLabel.text =   [object objectForKey:@"displayName"];
//    [self setNameAndPhoto:object];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(52.0, 4.0f, 320.0f,30.0f)];
    [nameLabel setTag:1];
    [nameLabel setBackgroundColor:[UIColor clearColor]]; //transparent label background
    nameLabel.text =  [ASQUtility firstNameForDisplayName:[profileData objectForKey:@"personName"]];
    //[profileData objectForKey:@"personName"];
    
    [nameLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:14.0f ]];
    nameLabel.lineBreakMode=UILineBreakModeWordWrap;
    nameLabel.numberOfLines=0;
    
    [nameAndPicView addSubview:nameLabel];
    
    NSString *path  = @"http://graph.facebook.com/";
    path = [path stringByAppendingFormat:@"%@/picture", [profileData objectForKey:@"sharedTo"]];
    NSURL *url = [NSURL URLWithString:path];
    
    UIImageView*  avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0f, 8.0f, 25.0f, 25.0f)];
    avatarImageView.image = [UIImage imageNamed:@"profile.png"];
    avatarImageView.backgroundColor = [UIColor darkGrayColor];
    [ASQUtility downloadImageInImageView:avatarImageView withURL:url];
    [avatarImageView.layer setMasksToBounds:YES];
    [avatarImageView.layer setCornerRadius:6.0f];
    [nameAndPicView addSubview:avatarImageView];
    [self timeStamp];
    bgColorFill = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0f, 6.0f,40.0f)];
    bgColorFill.backgroundColor = [UIColor whiteColor];
    NSLog(@"deataresponse::: %@",profileData);
    if(thisPersonVote && thisPersonVote!=NULL)
    {
        [self votedPersonBg:pollType response:response];
    }
    PFUser* ownerId     = (PFUser*)[profileData objectForKey:kASQParseShareDetailsOwnerIdKey];
    PFUser* currentuser = [PFUser currentUser];
    if([ownerId.objectId isEqualToString:currentuser.objectId])
    {
         NSLog(@"same id:::%@:::%@",ownerId.objectId,currentuser.objectId);
        [self votedPersonBg:pollType response:response];   
    }
     [nameAndPicView addSubview:bgColorFill];
}

#pragma mark - set bg color of voted person
- (void) votedPersonBg : (NSNumber *) pollType response: (NSNumber *) response
{
    UIColor* green          = [UIColor colorWithRed:150.0/255 green:187.0/255 blue:97.0/255 alpha:1.0];
    UIColor* red            = [UIColor colorWithRed:235.0/255 green:138.0/255 blue:135.0/255 alpha:1.0];
    UIColor* violet         = [UIColor colorWithRed:135.0/255 green:95.0/255 blue:129.0/255 alpha:1.0];
    UIColor* orange         = [UIColor colorWithRed:242.0/255 green:179.0/255 blue:104.0/255 alpha:1.0];
    NSArray *colorValueObj  = [[NSArray alloc]initWithObjects:nil];
    colorValueObj           = [NSArray arrayWithObjects:green, red, orange, violet, nil];
    NSLog(@"inseide::: response::: %@",response);
    if(response!=NULL)
    {
    int intpolltype = [pollType intValue];
    int intresponse = [response intValue];
    int index = 0;
    if(intpolltype!=0)
    {
        index = intresponse<0 ? 1 : 0;
    }
    else
    {
        index = intresponse;
    }
    NSLog(@"index to access:: %d",index);
    if(response!=NULL)
    {
        bgColorFill.backgroundColor = [colorValueObj objectAtIndex:index];
    }
    }
}

#pragma mark - - to display time intervalx
-(void) timeStamp
{
    timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    NSTimeInterval timeInterval = [friendObj.updatedAt timeIntervalSinceNow];
    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(196.0, 2.0f, 94.0f,30.0f)];
    [timestampLabel setText:timestamp];
    timestampLabel.backgroundColor = [UIColor clearColor];
    [timestampLabel setFont:[UIFont fontWithName:@"Swis721 Cn BT" size:12.0f ]];
    timestampLabel.textAlignment = NSTextAlignmentRight;
    timestampLabel.textColor = [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0];
    [nameAndPicView addSubview:timestampLabel];
}

@end
