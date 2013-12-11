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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

-(IBAction) saveExcerpt:(id) sender {
    NSLog(@"save clicked");
    
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(self.opMode == MZExcerptOperationModeAdd) {
        [delegate.bookStore saveExpert: self.excerptText.text forBoook:self.isbn13];
        
    } else if(self.opMode == MZExcerptOperationModeEdit) {
        
        [delegate.bookStore updateExpert:self.excerptText.text forExcerptId:self.objectID forBoook:self.isbn13];
        
    } else {
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
