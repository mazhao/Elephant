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

#import "Config.h"

@interface MZExcerptVC ()

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) IBOutlet UITextView * excerptText;
@property (nonatomic, retain) IBOutlet UIImageView * addImageView;
@property (nonatomic, retain) IBOutlet UIImageView * takePhotoView;
@property (nonatomic, retain) IBOutlet UIImageView * targetImageView;

-(IBAction) saveExcerpt:(id) sender;

@property (atomic) BOOL shouldSave;

@end

@implementation MZExcerptVC

static int kTargetImageHeight = DEFAULT_EXCERPT_IMAGE_HEIGHT;


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
    
    
    
    // 初始化内容变更标记
    self.shouldSave = NO;
    
    // 第一次进入，默认为编辑模式；第二次进入，默认为查看模式
    if (self.excerpt == nil  || [self.excerpt length] == 0) {
        // 编辑模式
        [self.excerptText becomeFirstResponder];
        self.addImageView.hidden = NO;
        self.takePhotoView.hidden = NO;
    } else {
        // 查看模式
        [self.excerptText setText: self.excerpt];
        self.addImageView.hidden = YES;
        self.takePhotoView.hidden = YES;
    }
    
    // 内容变更检查代理
    self.excerptText.delegate = self;
    
    NSLog(@"enter excerpt vc with op:%d OID:%@", self.opMode, self.objectID);
    
    // 加载图片数据，由于内容比较大，所以不在列表中保存，仅仅在进入次页面时加载。
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
    
    // 选择照片和拍照事件绑定
    UITapGestureRecognizer *addImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage:)];
    [self.addImageView addGestureRecognizer:addImgTap];
    [self.addImageView setMultipleTouchEnabled:YES];
    [self.addImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *takePhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    [self.takePhotoView addGestureRecognizer:takePhotoTap];
    [self.takePhotoView setMultipleTouchEnabled:YES];
    [self.takePhotoView setUserInteractionEnabled:YES];
	
    // 点击查看图片事件绑定
    UITapGestureRecognizer *targetPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetImgTap:)];
    [self.targetImageView addGestureRecognizer:targetPhotoTap];
    [self.targetImageView setMultipleTouchEnabled:YES];
    [self.targetImageView setUserInteractionEnabled:YES];

    
    

}

- (void)viewDidLayoutSubviews {
    if (self.targetImageView.image != nil) {
        
        self.targetImageView.frame = CGRectMake(self.targetImageView.frame.origin.x,
                                                self.targetImageView.frame.origin.y,
                                                self.targetImageView.frame.size.width,
                                                kTargetImageHeight);
        [self.targetImageView setNeedsLayout];
        
        self.excerptText.frame =CGRectMake(self.excerptText.frame.origin.x,
                                           self.excerptText.frame.origin.y + kTargetImageHeight,
                                           self.excerptText.frame.size.width,
                                           self.excerptText.frame.size.height);
        
        
        self.addImageView.frame = CGRectMake(self.addImageView.frame.origin.x,
                                             self.addImageView.frame.origin.y + kTargetImageHeight,
                                             self.addImageView.frame.size.width,
                                             self.addImageView.frame.size.height);
        
        self.takePhotoView.frame = CGRectMake(self.takePhotoView.frame.origin.x,
                                              self.takePhotoView.frame.origin.y + kTargetImageHeight,
                                              self.takePhotoView.frame.size.width,
                                              self.takePhotoView.frame.size.height );
        
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
}



-(void) viewWillDisappear:(BOOL)animated {
    
    NSLog(@"will disappear");
    
    // 内容变更或者第一次添加内容后，退出需要保存。
    if(self.shouldSave  &&
       ([self.excerptText.text length ] > 0 || self.targetImageView.image != nil)) {
        
        NSLog(@"find update to be saved");
        
        MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if(self.opMode == MZExcerptOperationModeAdd) {
            NSData * imageData = UIImageJPEGRepresentation(self.targetImageView.image, 0.75f);
            [delegate.bookStore saveExpert:self.excerptText.text
                             withImageData:imageData
                                   ofBoook:self.isbn13];
        } else if(self.opMode == MZExcerptOperationModeEdit) {
            NSData * imageData = UIImageJPEGRepresentation(self.targetImageView.image, 1.0f);
            [delegate.bookStore updateExpert: self.excerptText.text
                               withImageData: imageData
                               withExcerptId: self.objectID
                                     ofBoook: self.isbn13];
        }
    }
    
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - actions

-(IBAction) saveExcerpt:(id) sender {
    NSLog(@"save clicked");
    
    // 如果不需要修改，直接返回
    if (!self.shouldSave) {
        return ;
    }
    
    self.shouldSave = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(self.opMode == MZExcerptOperationModeAdd) {
        // @TODO: bad smell to be modified later !!!
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSData * imageData = UIImageJPEGRepresentation(self.targetImageView.image, 0.75f);
            [delegate.bookStore saveExpert: self.excerptText.text
                             withImageData: imageData
                                   ofBoook: self.isbn13];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
    } else if(self.opMode == MZExcerptOperationModeEdit) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSData * imageData = UIImageJPEGRepresentation(self.targetImageView.image, 1.0f);
            [delegate.bookStore updateExpert: self.excerptText.text
                               withImageData: imageData
                               withExcerptId: self.objectID
                                     ofBoook: self.isbn13];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];

            });
        });
        
        
    } else {
        NSLog(@"neigther add nor update");
    }
}


- (void) addImage:(UITapGestureRecognizer *)gesture {
    NSLog(@"begin add image");
    
    self.shouldSave = NO; // 这个时候会导致willDisappear被调用，注意屏蔽。

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void) takePhoto:(UITapGestureRecognizer *)gesture {
    NSLog(@"begin take photo");

    self.shouldSave = NO;// 这个时候会导致willDisappear被调用，注意屏蔽。
    
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
        
        // Present
        [self.navigationController pushViewController:browser animated:YES];
        
        // Manipulate!
        [browser showPreviousPhotoAnimated:YES];
        [browser showNextPhotoAnimated:YES];
    } else {
        NSLog(@"no image to show");
    }
}

#pragma mark - MWPhotoBrowserDelegate: Show Image When click

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto * photo = [[MWPhoto alloc]initWithImage: self.targetImageView.image];
    photo.caption = [self.excerptText.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]   ];
    
    return photo;
}



#pragma mark - UIImagePickerControllerDelegate: Choose Image from Album

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    
    [self.targetImageView setImage:image];
    
    
    if(image != nil) {
        self.shouldSave = YES;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextViewDelegate: Show or Hide Image Choose Button

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"text view begin editing");
    self.addImageView.hidden = NO;
    self.takePhotoView.hidden = NO;
    
    if ( [self.excerptText.text isEqualToString:@"点这里添加书摘"] ) {
        self.excerptText.text = @"";
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"text view end editing");
    self.addImageView.hidden = YES;
    self.takePhotoView.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.shouldSave = YES;
}

//#pragma mark - Save excerpt Before Hide
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    
//    NSLog(@"segue id:%@ by sender:%@", identifier, sender);
//    
//    return YES;
//}

@end
