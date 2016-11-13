//
//  ASQParseConstants.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/25/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

typedef enum {
	ASQParseHomeTabBarItemIndex = 0,
	ASQParseEmptyTabBarItemIndex = 1,
	ASQParseActivityTabBarItemIndex = 2
} ASQParseTabBarControllerViewControllerIndex;


#define kASQParseEmployeeAccounts [NSArray array]

#pragma mark - NSUserDefaults
extern NSString *const kASQParseUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kASQParseUserDefaultsCacheFacebookFriendsKey;

#pragma mark - Launch URLs

extern NSString *const kASQParseLaunchURLHostTakePicture;


#pragma mark - NSNotification

extern NSString *const ASQParseAppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const ASQParseUtilityUserFollowingChangedNotification;
extern NSString *const ASQParseUtilityUserLikedUnlikedPhotoCallbackFinishedNotification;
extern NSString *const ASQParseUtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const ASQParseTabBarControllerDidFinishEditingPhotoNotification;
extern NSString *const ASQParseTabBarControllerDidFinishImageFileUploadNotification;
extern NSString *const ASQParsePhotoDetailsViewControllerUserDeletedPhotoNotification;
extern NSString *const ASQParsePhotoDetailsViewControllerUserLikedUnlikedPhotoNotification;
extern NSString *const ASQParsePhotoDetailsViewControllerUserCommentedOnPhotoNotification;


#pragma mark - User Info Keys
extern NSString *const ASQParsePhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey;
extern NSString *const kASQParseEditPhotoViewControllerUserInfoCommentKey;


#pragma mark - Installation Class

// Field keys
extern NSString *const kASQParseInstallationUserKey;
extern NSString *const kASQParseInstallationChannelsKey;


#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kASQParseActivityClassKey;

// Field keys
extern NSString *const kASQParseActivityTypeKey;
extern NSString *const kASQParseActivityFromUserKey;
extern NSString *const kASQParseActivityToUserKey;
extern NSString *const kASQParseActivityContentKey;
extern NSString *const kASQParseActivityPhotoKey;

// Type values
extern NSString *const kASQParseActivityTypeLike;
extern NSString *const kASQParseActivityTypeFollow;
extern NSString *const kASQParseActivityTypeComment;
extern NSString *const kASQParseActivityTypeJoined;


#pragma mark - PFObject User Class
// Field keys
extern NSString *const kASQParseUserNameKey;
extern NSString *const kASQParseUserDisplayNameKey;
extern NSString *const kASQParseUserEmailKey;
extern NSString *const kASQParseUserFacebookIDKey;
extern NSString *const kASQParseUserPhotoIDKey;
extern NSString *const kASQParseUserProfilePicSmallKey;
extern NSString *const kASQParseUserProfilePicMediumKey;
extern NSString *const kASQParseUserFacebookFriendsKey;
extern NSString *const kASQParseUserAlreadyAutoFollowedFacebookFriendsKey;
extern NSString *const kASQParseUserPrivateChannelKey;


#pragma mark - PFObject Photo Class
// Class key
extern NSString *const kASQParsePhotoClassKey;

// Field keys
extern NSString *const kASQParsePhotoPictureKey;
extern NSString *const kASQParsePhotoThumbnailKey;
extern NSString *const kASQParsePhotoUserKey;
extern NSString *const kASQParsePhotoOpenGraphIDKey;

#pragma mark - Question Class
//Class key
extern NSString *const kASQParseQuestionClassKey;

// Field keys
extern NSString *const kASQParseQuestionAllowUnknownKey;
extern NSString *const kASQParseQuestionAnsCountKey;
extern NSString *const kASQParseQuestionAskedToKey;
extern NSString *const kASQParseQuestionAskedByKey;
extern NSString *const kASQParseQuestionAuthorNameKey;
extern NSString *const kASQParseQuestionChoicesKey;
extern NSString *const kASQParseQuestionFreezeKey;
extern NSString *const kASQParseQuestionOpt0Key;
extern NSString *const kASQParseQuestionOpt1Key;
extern NSString *const kASQParseQuestionOpt2Key;
extern NSString *const kASQParseQuestionOpt3Key;
extern NSString *const kASQParseQuestionContentKey;
extern NSString *const kASQParseQuestionPollTypeKey;
extern NSString *const kASQParseQuestionImageKey;
extern NSString *const kASQParseQuestionownerFbIdKey;
extern NSString *const kASQParseQuestionCreatedAt;

#pragma mark - shareDetails Class
//Class key
extern NSString *const kASQParseShareDetailsClassKey;

// Field keys
extern NSString *const kASQParseShareDetailsOwnerIdKey;
extern NSString *const kASQParseShareDetailsQuestionIdKey;
extern NSString *const kASQParseShareDetailsPersonNameKey;
extern NSString *const kASQParseShareDetailsResponseKey;
extern NSString *const kASQParseShareDetailsSharedToKey;
extern NSString *const kASQParseShareDetailsSharedUserKey;
extern NSString *const kASQParseShareDetailscreatedTimeKey;

#pragma mark - Cached Photo Attributes
// keys
extern NSString *const kASQParsePhotoAttributesIsLikedByCurrentUserKey;
extern NSString *const kASQParsePhotoAttributesLikeCountKey;
extern NSString *const kASQParsePhotoAttributesLikersKey;
extern NSString *const kASQParsePhotoAttributesCommentCountKey;
extern NSString *const kASQParsePhotoAttributesCommentersKey;


#pragma mark - Cached User Attributes
// keys
extern NSString *const kASQParseUserAttributesPhotoCountKey;
extern NSString *const kASQParseUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - PFPush Notification Payload Keys

extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kASQParsePushPayloadPayloadTypeKey;
extern NSString *const kASQParsePushPayloadPayloadTypeActivityKey;

extern NSString *const kASQParsePushPayloadActivityAsqKey;
extern NSString *const kASQParsePushPayloadActivityResponseKey;
extern NSString *const kASQParsePushPayloadActivityCommentKey;
extern NSString *const kASQParsePushPayloadActivityFollowKey;

extern NSString *const kASQParsePushPayloadFromUserObjectIdKey;
extern NSString *const kASQParsePushPayloadToUserObjectIdKey;
extern NSString *const kASQParsePushPayloadAsQObjectIdKey;