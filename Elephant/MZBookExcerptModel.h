//
//  MZBookExcerptModel.h
//  Elephant
//
//  Created by mazhao on 13-12-4.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MZBookModel;

@interface MZBookExcerptModel : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * datetime;
@property (nonatomic, retain) MZBookModel *book;

@end
