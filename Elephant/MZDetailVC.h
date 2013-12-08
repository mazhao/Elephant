//
//  MZDetailVC.h
//  Elephant
//
//  Created by mazhao on 13-12-3.
//  Copyright (c) 2013年 mz. All rights reserved.
//


#import <UIKit/UIKit.h>

// book model

#import "MZBookModel.h"
#import "MZBookStoreAPI.h"
#import "MZBookWriterModel.h"
#import "MZBookTagModel.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface MZDetailVC : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSString * isbn10;
@property (strong, nonatomic) NSString * isbn13;

@property (retain, nonatomic) MZBookModel * bookModel;
@property (retain, nonatomic) NSArray * bookExcerpts;


-(IBAction) deleteBook:(id) sender;

-(IBAction) deleteAllExcerpt:(id) sender;



@end
