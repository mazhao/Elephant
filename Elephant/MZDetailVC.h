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


@interface MZDetailVC : UITableViewController

@property (strong, nonatomic) NSString * isbn10;
@property (strong, nonatomic) NSString * isbn13;

@property (retain, nonatomic) MZBookModel * bookModel;

@end
