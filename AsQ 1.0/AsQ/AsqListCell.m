//
//  AsqListCell.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 10/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "AsqListCell.h"


@implementation AsqListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initialSetup
{
    // initial setup
}


-(void) setupPollValues:(PFObject*) object
{
    for(UIView *view in [self.contentView subviews]){
        [view removeFromSuperview];
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 300.0, 30.0)];
    [nameLabel setTag:1];
    [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
     nameLabel.text =  [object objectForKey:@"content"];
    
    PFFile *imageFile = [object objectForKey:@"image"];
    PFImageView *quesImage = [[PFImageView alloc] init];
    quesImage.image = [UIImage imageNamed:@"vote-1-0.png"]; // placeholder image
    quesImage.file = (PFFile *)imageFile;
    [quesImage loadInBackground];

// custom views should be added as subviews of the cell's contentView:
// self.textLabel.text =   [object objectForKey:@"content"];
    
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:quesImage];
}

@end
