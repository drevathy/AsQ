//
//  ASQUtility.m
//  AsQ
//
//  Created by Revathy Durai Rajan on 07/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import "ASQUtility.h"
#import "UIImage+ResizeAdditions.h"
#import "AppDelegate.h"

@implementation ASQUtility

@synthesize appDelegate;

#pragma mark - ASQUtility

#pragma mark Facebook

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
    if (newProfilePictureData.length == 0) {
        NSLog(@"Profile picture did not download successfully.");
        return;
    }
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data matches the incoming profile picture. If it does, avoid uploading this data to Parse.

    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory

    NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:@"FacebookProfilePicture.jpg"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]]) {
        // We have a cached Facebook profile picture
        
        NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:[profilePictureCacheURL path]];

        if ([oldProfilePictureData isEqualToData:newProfilePictureData]) {
            NSLog(@"Cached profile picture matches incoming profile picture. Will not update.");
            return;
        }
    }

    BOOL cachedToDisk = [[NSFileManager defaultManager] createFileAtPath:[profilePictureCacheURL path] contents:newProfilePictureData attributes:nil];
    NSLog(@"Wrote profile picture to disk cache: %d", cachedToDisk);

    UIImage *image = [UIImage imageWithData:newProfilePictureData];

    UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];

    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);

    if (mediumImageData.length > 0) {
        NSLog(@"Uploading Medium Profile Picture");
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Uploaded Medium Profile Picture");
                [[PFUser currentUser] setObject:fileMediumImage forKey:kASQParseUserProfilePicMediumKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0) {
        NSLog(@"Uploading Profile Picture Thumbnail");
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Uploaded Profile Picture Thumbnail");
                [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kASQParseUserProfilePicSmallKey];    
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
}

+(UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIImage* retImage = [appDelegate.imageCache objectForKey:imageNamed];
    if (retImage == nil)
    {
        retImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNamed]]];
        if (cache)
        {
            if (appDelegate.imageCache == nil)
                appDelegate.imageCache = [NSMutableDictionary new];
                if(retImage!=Nil)
                {
                    [appDelegate.imageCache setObject:retImage forKey:imageNamed];
                }
        }
    }
    return retImage;
}

+(void)downloadImageInImageView:(PFImageView *)imageView withURL:(NSURL *)imageUrl {
    NSLog(@"imageView:::%@",imageView.image);
    if(!imageView || !imageUrl)
        return;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          imageView,@"imageView",
                          imageUrl,@"imageUrl", nil];
    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:dict];
}

+(void)downloadImage:(NSDictionary *)dict {
    PFImageView *imageView = [dict valueForKey:@"imageView"];
    NSURL *imageUrl = [dict valueForKey:@"imageUrl"];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];

    NSString *tmp = [NSString stringWithFormat:@"%@", [dict valueForKey:@"imageUrl"]];
    UIImage *ret = [self imageNamed:tmp cache:YES];
    [imageView setImage:ret];

    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.1];
    [imageView setAlpha:1];
    [UIView commitAnimations];
    //[av stopAnimating];
}


+ (BOOL)userHasValidFacebookData:(PFUser *)user {
    NSString *facebookId = [user objectForKey:kASQParseUserFacebookIDKey];
    return (facebookId && facebookId.length > 0);
}

+ (BOOL)userHasProfilePictures:(PFUser *)user {
    PFFile *profilePictureMedium = [user objectForKey:kASQParseUserProfilePicMediumKey];
    PFFile *profilePictureSmall = [user objectForKey:kASQParseUserProfilePicSmallKey];
    
    return (profilePictureMedium && profilePictureSmall);
}


#pragma mark Display Name

+ (NSString *)firstNameForDisplayName:(NSString *)displayName {
    if (!displayName || displayName.length == 0) {
        return @"Someone";
    }
    
    NSArray *displayNameComponents = [displayName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *firstName = [displayNameComponents objectAtIndex:0];
    if (firstName.length > 100) {
        // truncate to 100 so that it fits in a Push payload
        firstName = [firstName substringToIndex:100];
    }
    return firstName;
}


#pragma mark Push
+ (void)sendAnswerPushNotification:(PFObject *)asq forUser: (PFUser *) user {
    NSLog(@"push user::: %@::::: FOR THIS QUES = %@",user , asq.objectId);
    NSString *privateChannelName = [NSString stringWithFormat:@"user_%@",user.objectId];
    NSLog(@"privateChannelName::: %@",privateChannelName);
    if (privateChannelName && privateChannelName.length != 0) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ reponded to your AsQ!",
                               [ASQUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kASQParseUserDisplayNameKey]]],
                              kAPNSAlertKey,kASQParsePushPayloadPayloadTypeActivityKey,kASQParsePushPayloadActivityResponseKey,
                              [[PFUser currentUser] objectId], kASQParsePushPayloadFromUserObjectIdKey,
                              asq.objectId, kASQParsePushPayloadAsQObjectIdKey,
                              @"Increment",kAPNSBadgeKey,
                              nil];
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:privateChannelName];
        [push setData:data];
        [push sendPushInBackground];
    }
}

+ (void)sendAsqPushNotification:(PFObject *)asq forUser: (PFUser *) user {
    NSString *privateChannelName = [user objectForKey:kASQParseUserPrivateChannelKey];
    NSLog(@"privateChannelName::: %@",privateChannelName);
    if (privateChannelName && privateChannelName.length != 0) {
NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%@ needs your suggestion.",
             [ASQUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kASQParseUserDisplayNameKey]]],
              kAPNSAlertKey,kASQParsePushPayloadPayloadTypeActivityKey,kASQParsePushPayloadActivityAsqKey,
            [[PFUser currentUser] objectId], kASQParsePushPayloadFromUserObjectIdKey,
            asq.objectId, kASQParsePushPayloadAsQObjectIdKey,
            @"Increment",kAPNSBadgeKey,
                  nil];
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:privateChannelName];
        [push setData:data];
        [push sendPushInBackground];
    }
}

#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *queryLikes = [PFQuery queryWithClassName:kASQParseActivityClassKey];
    [queryLikes whereKey:kASQParseActivityPhotoKey equalTo:photo];
    [queryLikes whereKey:kASQParseActivityTypeKey equalTo:kASQParseActivityTypeLike];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:kASQParseActivityClassKey];
    [queryComments whereKey:kASQParseActivityPhotoKey equalTo:photo];
    [queryComments whereKey:kASQParseActivityTypeKey equalTo:kASQParseActivityTypeComment];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kASQParseActivityFromUserKey];
    [query includeKey:kASQParseActivityPhotoKey];

    return query;
}


#pragma mark Shadow Rendering

+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {
    // Push the context 
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y, rect.size.width + 20.0f, rect.size.height + 10.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x, 
                                          rect.origin.y - 5.0f, 
                                          rect.size.width, 
                                          rect.size.height + 5.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {    
    // Push the context 
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y - 10.0f, rect.size.width + 20.0f, rect.size.height + 10.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x, 
                                          rect.origin.y, 
                                          rect.size.width, 
                                          rect.size.height + 10.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {    
    // Push the context 
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y, rect.size.width + 20.0f, rect.size.height));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x, 
                                          rect.origin.y - 5.0f, 
                                          rect.size.width, 
                                          rect.size.height + 10.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)addBottomDropShadowToNavigationBarForNavigationController:(UINavigationController *)navigationController {
     initWithFrame:CGRectMake(0.0f, navigationController.navigationBar.frame.size.height, navigationController.navigationBar.frame.size.width, 0.0f);
    //[gradientView setBackgroundColor:[UIColor redColor]];
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = gradientView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
//    [gradientView.layer insertSublayer:gradient atIndex:0];
//    navigationController.navigationBar.clipsToBounds = NO;
//    [navigationController.navigationBar addSubview:gradientView];	    
}

@end
