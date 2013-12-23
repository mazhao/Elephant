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
    
    // choice 1:
//    UIColor * navColor = [UIColor colorWithRed:28/255.0f green:129/255.0f blue:233/255.0f alpha:0.6f];
//    UIColor * navColor = [UIColor colorWithRed:173/255.0f green:223/255.0f blue:173/255.0f alpha:1.0];
//        UIColor * navColor = [UIColor colorWithRed:254/255.0f green:214/255.0f blue:103/255.0f alpha:1];
    
    
//    self.navigationController.navigationBar.barTintColor = navColor;
    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    self.navigationController.navigationBar.translucent = NO;
    
    
    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"%@", fontName);
        }
    }

    
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
