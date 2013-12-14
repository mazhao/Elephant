//
//  MZExcerptVC.m
//  Elephant
//
//  Created by mazhao on 13-12-4.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZExcerptVC.h"
#import "MZAppDelegate.h"
#import "MZBookExcerptModel.h"

#import "MBProgressHUD.h"

#import "MWPhotoBrowser.h"

/**
 *  @TODO:
 *  1. 没有更新的情况下不保存，直接返回；没有更新图片的时候不更新图片，直接返回。
 *  2. 视觉效果调整。
 */

@interface MZExcerptVC ()

@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation MZExcerptVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // text init
    [[self.excerptText layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.excerptText layer] setBorderWidth:0.5  ];
    [self.excerptText becomeFirstResponder];
    [self.excerptText setText: self.excerpt];
    NSLog(@"op:%d OID:%@", self.opMode, self.objectID);
    
    
    // image data is large, so get the data each time get into excerpt edit vc.
    
    UIImage * img = nil;
    
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MZBookModel * book = [delegate.bookStore getBookDetail:self.isbn13];
    NSSet * excerpts = book.excerpts;
    for (MZBookExcerptModel* excerpt in excerpts) {
        if (self.objectID == excerpt.objectID) {
            img = [[UIImage alloc] initWithData: excerpt.image];
            break;
        }
    }
    
    if (img != nil) {
        
        self.targetImageView.image = img;
        
    }
    
    // image & photo button event binding
    
    UITapGestureRecognizer *addImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage:)];
    [self.addImageView addGestureRecognizer:addImgTap];
    [self.addImageView setMultipleTouchEnabled:YES];
    [self.addImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *takePhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    [self.takePhotoView addGestureRecognizer:takePhotoTap];
    [self.takePhotoView setMultipleTouchEnabled:YES];
    [self.takePhotoView setUserInteractionEnabled:YES];
	// Do any additional setup after loading the view.
    
    
    UITapGestureRecognizer *targetPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetImgTap:)];
    [self.targetImageView addGestureRecognizer:targetPhotoTap];
    [self.targetImageView setMultipleTouchEnabled:YES];
    [self.targetImageView setUserInteractionEnabled:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

-(IBAction) saveExcerpt:(id) sender {
    NSLog(@"save clicked");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(self.opMode == MZExcerptOperationModeAdd) {
        // @TODO: bad smell to be modified later !!!
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSData * imageData = UIImageJPEGRepresentation(self.targetImageView.image, 0.75f);
            [delegate.bookStore saveExpert:self.excerptText.text withImageData:imageData  ofBoook:self.isbn13];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];

            });
        });
        
        
    } else if(self.opMode == MZExcerptOperationModeEdit) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSData * imageData = UIImageJPEGRepresentation(self.targetImageView.image, 1.0f);
            
            [delegate.bookStore updateExpert:self.excerptText.text withImageData: imageData withExcerptId:self.objectID ofBoook:self.isbn13];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];

            });
        });
        
        
    } else {
        
    }
}


- (void) addImage:(UITapGestureRecognizer *)gesture {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    NSLog(@"add image tapped");
}

- (void) takePhoto:(UITapGestureRecognizer *)gesture {
    NSLog(@"take photo tapped");
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) targetImgTap:(UITapGestureRecognizer *)gesture {
    NSLog(@"target img tapped");
    
    if( self.targetImageView.image != nil ){
    
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        // Set options
        browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        [browser setCurrentPhotoIndex:0]; // Example: allows second image to be presented first
        browser.wantsFullScreenLayout = YES; // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
        
        // Present
        
        [self.navigationController pushViewController:browser animated:YES];
        
        // Manipulate!
        [browser showPreviousPhotoAnimated:YES];
        [browser showNextPhotoAnimated:YES];
    } else {
        
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto * photo = [[MWPhoto alloc]initWithImage: self.targetImageView.image];
    photo.caption = self.excerptText.text;
    
    return photo;
}



#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.targetImageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
