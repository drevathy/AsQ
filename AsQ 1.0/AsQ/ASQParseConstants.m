//
//  ASQParseConstants.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/25/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "ASQParseConstants.h"

NSString *const kASQParseUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.parse.AsQ.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kASQParseUserDefaultsCacheFacebookFriendsKey                     = @"com.parse.AsQ.userDefaults.cache.facebookFriends";


#pragma mark - Launch URLs

NSString *const kASQParseLaunchURLHostTakePicture = @"camera";


#pragma mark - NSNotification

NSString *const ASQParseAppDelegateApplicationDidReceiveRemoteNotification           = @"com.parse.AsQ.appDelegate.applicationDidReceiveRemoteNotification";
NSString *const ASQParseUtilityUserFollowingChangedNotification                      = @"com.parse.AsQ.utility.userFollowingChanged";
NSString *const ASQParseUtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = @"com.parse.AsQ.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const ASQParseUtilityDidFinishProcessingProfilePictureNotification         = @"com.parse.AsQ.utility.didFinishProcessingProfilePictureNotification";
NSString *const ASQParseTabBarControllerDidFinishEditingPhotoNotification            = @"com.parse.AsQ.tabBarController.didFinishEditingPhoto";
NSString *const ASQParseTabBarControllerDidFinishImageFileUploadNotification         = @"com.parse.AsQ.tabBarController.didFinishImageFileUploadNotification";
NSString *const ASQParsePhotoDetailsViewControllerUserDeletedPhotoNotification       = @"com.parse.AsQ.photoDetailsViewController.userDeletedPhoto";
NSString *const ASQParsePhotoDetailsViewControllerUserLikedUnlikedPhotoNotification  = @"com.parse.AsQ.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification";
NSString *const ASQParsePhotoDetailsViewControllerUserCommentedOnPhotoNotification   = @"com.parse.AsQ.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";


#pragma mark - User Info Keys
NSString *const ASQParsePhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey = @"liked";
NSString *const kASQParseEditPhotoViewControllerUserInfoCommentKey = @"comment";

#pragma mark - Installation Class

// Field keys
NSString *const kASQParseInstallationUserKey = @"user";
NSString *const kASQParseInstallationChannelsKey = @"channels";

#pragma mark - Activity Class
// Class key
NSString *const kASQParseActivityClassKey = @"Activity";

// Field keys
NSString *const kASQParseActivityTypeKey        = @"type";
NSString *const kASQParseActivityFromUserKey    = @"fromUser";
NSString *const kASQParseActivityToUserKey      = @"toUser";
NSString *const kASQParseActivityContentKey     = @"content";
NSString *const kASQParseActivityPhotoKey       = @"photo";

// Type values
NSString *const kASQParseActivityTypeLike       = @"like";
NSString *const kASQParseActivityTypeFollow     = @"follow";
NSString *const kASQParseActivityTypeComment    = @"comment";
NSString *const kASQParseActivityTypeJoined     = @"joined";

#pragma mark - User Class
// Field keys
NSString *const kASQParseUserNameKey                                 = @"username";
NSString *const kASQParseUserDisplayNameKey                          = @"displayName";
NSString *const kASQParseUserEmailKey                                = @"email";
NSString *const kASQParseUserFacebookIDKey                           = @"facebookId";
NSString *const kASQParseUserPhotoIDKey                              = @"photoId";
NSString *const kASQParseUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kASQParseUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kASQParseUserFacebookFriendsKey                      = @"facebookFriends";
NSString *const kASQParseUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";
NSString *const kASQParseUserPrivateChannelKey                       = @"channel";


#pragma mark - Question Class
//Class key
NSString *const kASQParseQuestionClassKey = @"questions";

// Field keys
NSString *const kASQParseQuestionAllowUnknownKey            = @"allowUnknown";
NSString *const kASQParseQuestionAnsCountKey                = @"ansCount";
NSString *const kASQParseQuestionAskedToKey                 = @"askedTo";
NSString *const kASQParseQuestionAskedByKey                 = @"askedBy";
NSString *const kASQParseQuestionPollTypeKey                = @"pollType";
NSString *const kASQParseQuestionAuthorNameKey              = @"authorName";
NSString *const kASQParseQuestionChoicesKey                 = @"choices";
NSString *const kASQParseQuestionFreezeKey                  = @"freeze";
NSString *const kASQParseQuestionOpt0Key                    = @"opt0";
NSString *const kASQParseQuestionOpt1Key                    = @"opt1";
NSString *const kASQParseQuestionOpt2Key                    = @"opt2";
NSString *const kASQParseQuestionOpt3Key                    = @"opt3";
NSString *const kASQParseQuestionContentKey                 = @"content";
NSString *const kASQParseQuestionImageKey                   = @"image";
NSString *const kASQParseQuestionownerFbIdKey               = @"ownerFbId";
NSString *const kASQParseQuestionCreatedAt                  = @"createdAt";


#pragma mark - shareDetails Class
//Class key
NSString *const kASQParseShareDetailsClassKey = @"shareDetails";

// Field keys
NSString *const kASQParseShareDetailsOwnerIdKey         = @"ownerId";
NSString *const kASQParseShareDetailsQuestionIdKey      = @"parentQuestion";
NSString *const kASQParseShareDetailsPersonNameKey      = @"personName";
NSString *const kASQParseShareDetailsResponseKey        = @"response";
NSString *const kASQParseShareDetailsSharedToKey        = @"sharedTo";
NSString *const kASQParseShareDetailsSharedUserKey      = @"sharedUser";
NSString *const kASQParseShareDetailscreatedTimeKey     = @"createdTime";


#pragma mark - Photo Class
// Class key
NSString *const kASQParsePhotoClassKey = @"Photo";

// Field keys
NSString *const kASQParsePhotoPictureKey         = @"image";
NSString *const kASQParsePhotoThumbnailKey       = @"thumbnail";
NSString *const kASQParsePhotoUserKey            = @"user";
NSString *const kASQParsePhotoOpenGraphIDKey     = @"fbOpenGraphID";


#pragma mark - Cached Photo Attributes
// keys
NSString *const kASQParsePhotoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kASQParsePhotoAttributesLikeCountKey            = @"likeCount";
NSString *const kASQParsePhotoAttributesLikersKey               = @"likers";
NSString *const kASQParsePhotoAttributesCommentCountKey         = @"commentCount";
NSString *const kASQParsePhotoAttributesCommentersKey           = @"commenters";


#pragma mark - Cached User Attributes
// keys
NSString *const kASQParseUserAttributesPhotoCountKey                 = @"photoCount";
NSString *const kASQParseUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";


#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey = @"alert";
NSString *const kAPNSBadgeKey = @"badge";
NSString *const kAPNSSoundKey = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kASQParsePushPayloadPayloadTypeKey          = @"p";
NSString *const kASQParsePushPayloadPayloadTypeActivityKey  = @"a";

NSString *const kASQParsePushPayloadActivityAsqKey      = @"a";
NSString *const kASQParsePushPayloadActivityResponseKey = @"r";
NSString *const kASQParsePushPayloadActivityCommentKey  = @"c";
NSString *const kASQParsePushPayloadActivityFollowKey   = @"f";

NSString *const kASQParsePushPayloadFromUserObjectIdKey = @"fu";
NSString *const kASQParsePushPayloadToUserObjectIdKey   = @"tu";
NSString *const kASQParsePushPayloadAsQObjectIdKey      = @"aid";