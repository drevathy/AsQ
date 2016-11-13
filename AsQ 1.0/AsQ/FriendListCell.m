//
//  FriendListCell.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 22/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

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
    self.backgroundColor = [UIColor clearColor];
//    // Configure the view for the selected state
//    UIView *bgColorView = [[UIView alloc] init];
//    [bgColorView setBackgroundColor:[UIColor clearColor]];
//    [self setSelectedBackgroundView:bgColorView];
}

-(void) initialSetup
{
    // initial setup
}
- (void) setNameAndPhoto: (PFObject*) profileData
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(36.0, 4.0f, 320.0f,30.0f)];
    [nameLabel setTag:1];
    
    [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    nameLabel.text =  [ASQUtility firstNameForDisplayName:[profileData objectForKey:@"displayName"]];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    nameLabel.lineBreakMode=UILineBreakModeWordWrap;
    nameLabel.numberOfLines=0;
    [self addSubview:nameLabel];
    
    NSString *path  = @"http://graph.facebook.com/";
    path = [path stringByAppendingFormat:@"%@/picture", [profileData objectForKey:kASQParseUserFacebookIDKey]];
    NSURL *url = [NSURL URLWithString:path];
    
    UIImageView*  avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6.0f, 6.0f, 25.0f, 25.0f)];
    avatarImageView.image = [UIImage imageNamed:@"profile.png"];
    avatarImageView.backgroundColor = [UIColor darkGrayColor];
    [ASQUtility downloadImageInImageView:avatarImageView withURL:url];
    [avatarImageView.layer setMasksToBounds:YES];
    [avatarImageView.layer setCornerRadius:6.0f];
    [self addSubview:avatarImageView];
}
-(void) setupFriendsView:(PFObject*) object
{

    //self.textLabel.text =   [object objectForKey:@"displayName"];
    [self setNameAndPhoto:object];
}

@end
