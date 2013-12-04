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
//    [[self.excerptText layer] setBorderColor:[[UIColor grayColor] CGColor]];
//    [[self.excerptText layer] setBorderWidth:1.0  ];
//    [[self.excerptText layer] setCornerRadius:5 ];
    
    [self.excerptText becomeFirstResponder];
    
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
    
    
    [delegate.bookStore saveExpert: self.excerptText.text forBoook:self.isbn13];
    
    
    [self.navigationController popViewControllerAnimated:YES];

}


@end
