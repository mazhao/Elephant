//
//  MZCollectionShelfVC.h
//  Elephant
//
//  Created by mazhao on 13-11-27.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

// project header file
#import "MZCollectionShelfCell.h"

// book store api
#import "MZBookStoreAPI.h"
#import "MZBookModel.h"

// zxing library
// << IMPORTANT !!! not .m but .mm to import c++ header >>
#import <ZXingWidgetController.h>
#import <QRCodeReader.h>
#import <MultiFormatReader.h>

// std library
#include <stdlib.h>

// progress alert view
#import "MBProgressHUD.h"


@interface MZCollectionShelfVC : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate, ZXingDelegate, BookShelfRefreshDelegate>

//@property (strong, nonatomic) NSMutableArray * bookImgs;

@property (strong, nonatomic) NSArray * books;

@property (strong, nonatomic) IBOutlet UIButton * findButton;
@property (strong, nonatomic) IBOutlet UINavigationItem * scanBtn;



@end