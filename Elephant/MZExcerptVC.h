//
//  MZExcerptVC.h
//  Elephant
//
//  Created by mazhao on 13-12-4.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "MWPhotoBrowser.h"

typedef NS_ENUM(NSInteger, MZExcerptOperationMode) {
    MZExcerptOperationModeAdd,
    MZExcerptOperationModeEdit,
    MZExcerptOperationModeDelete
};

@interface MZExcerptVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MWPhotoBrowserDelegate, UITextViewDelegate, UIAlertViewDelegate>
@property (nonatomic, retain) NSString * isbn10;
@property (nonatomic, retain) NSString * isbn13;
@property (nonatomic, retain) NSString * excerpt;
@property (nonatomic, retain) NSManagedObjectID * objectID;
@property (nonatomic) MZExcerptOperationMode opMode;

@end
