//
//  MZBookTagModel.h
//  Elephant
//
//  Created by mazhao on 13-12-2.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MZBookModel;

@interface MZBookTagModel : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *books;
@end

@interface MZBookTagModel (CoreDataGeneratedAccessors)

- (void)addBooksObject:(MZBookModel *)value;
- (void)removeBooksObject:(MZBookModel *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

@end
