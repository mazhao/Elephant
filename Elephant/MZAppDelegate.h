//
//  MZAppDelegate.h
//  Elephant
//
//  Created by mazhao on 13-11-26.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "MZBookModel.h"
#import "MZBookStoreAPI.h"

#import <SDWebImage/SDImageCache.h>

@interface MZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id<MZBookStore>  bookStore;

@property (strong, nonatomic) SDImageCache *imageCache ;

@end
