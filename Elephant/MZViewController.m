//
//  MZViewController.m
//  Elephant
//
//  Created by mazhao on 13-11-26.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZViewController.h"

@interface MZViewController ()

@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
