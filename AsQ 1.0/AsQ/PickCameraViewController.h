//
//  PickCameraViewController.h
//  AsQ
//
//  Created by Revathy Durai Rajan on 05/03/13.
//  Copyright (c) 2013 Revathy Durai Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{
	
    UIImageView *imgPicture;
	NSData *dataImage;
    UIActionSheet*  actionSheet;
}

@end