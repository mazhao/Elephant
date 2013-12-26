//
//  MZViewController.m
//  Elephant
//
//  Created by mazhao on 13-11-26.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZViewController.h"
#import "Config.h"


@interface MZViewController ()

@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    self.buttonGo.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:20.0f];
    self.labelFirst.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:16.0f];
    self.labelFirst.text = @"畅游在知识的海洋~";
    self.labelSecond.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:16.0f];
    self.labelSecond.text = @"您还记得当年的摘要吗？";
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    //[self performSelector:@selector(gotoCollectionView) withObject:nil afterDelay:2.0f];
}


- (void) gotoCollectionView {
    [self performSegueWithIdentifier:@"gotoCollection" sender:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
