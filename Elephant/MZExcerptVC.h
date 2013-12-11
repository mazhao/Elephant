//
//  MZExcerptVC.h
//  Elephant
//
//  Created by mazhao on 13-12-4.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, MZExcerptOperationMode) {
    MZExcerptOperationModeAdd,
    MZExcerptOperationModeEdit,
    MZExcerptOperationModeDelete
};

@interface MZExcerptVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) NSString * isbn10;
@property (nonatomic, retain) NSString * isbn13;
@property (nonatomic, retain) NSString * excerpt;
@property (nonatomic, retain) NSManagedObjectID * objectID;
@property (nonatomic) MZExcerptOperationMode opMode;

@property (nonatomic, retain) IBOutlet UITextView * excerptText;

@property (nonatomic, retain) IBOutlet UIImageView * addImageView;
@property (nonatomic, retain) IBOutlet UIImageView * takePhotoView;

@property (nonatomic, retain) IBOutlet UIImageView * targetImageView;


-(IBAction) saveExcerpt:(id) sender;

@end
