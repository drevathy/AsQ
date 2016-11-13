//
//  ASQUtility.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 07/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

@class AppDelegate;
@interface ASQUtility : NSObject

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData;

+ (BOOL)userHasValidFacebookData:(PFUser *)user;
+ (BOOL)userHasProfilePictures:(PFUser *)user;

+ (NSString *)firstNameForDisplayName:(NSString *)displayName;

+ (void)sendAsqPushNotification:(PFUser *)user;
+ (void)sendAnswerPushNotification:(PFObject *)asq forUser: (PFUser *) user;
+ (void)sendAsqPushNotification:(PFObject *)asq forUser: (PFUser *) user;
+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;  
+ (void)addBottomDropShadowToNavigationBarForNavigationController:(UINavigationController *)navigationController;
+(UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache;
+(void)downloadImageInImageView:(UIImageView *)imageView withURL:(NSURL *)imageUrl;
+(void)downloadImage:(NSDictionary *)dict;
+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy;
@property (nonatomic,strong) AppDelegate *appDelegate;

@end
