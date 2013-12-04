//
//  MZExcerptVC.h
//  Elephant
//
//  Created by mazhao on 13-12-4.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZExcerptVC : UIViewController

@property (nonatomic, retain) NSString * isbn10;
@property (nonatomic, retain) NSString * isbn13;


@property (nonatomic, retain) IBOutlet UITextView * excerptText;
@property (nonatomic, retain) IBOutlet UISegmentedControl * typeSegment;

-(IBAction) saveExcerpt:(id) sender;

@end
