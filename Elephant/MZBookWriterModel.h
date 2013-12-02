//
//  MZBookWriterModel.h
//  Elephant
//
//  Created by mazhao on 13-12-2.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MZBookModel;

@interface MZBookWriterModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *books;
@property (nonatomic, retain) NSSet *translatedBooks;
@end

@interface MZBookWriterModel (CoreDataGeneratedAccessors)

- (void)addBooksObject:(MZBookModel *)value;
- (void)removeBooksObject:(MZBookModel *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

- (void)addTranslatedBooksObject:(MZBookModel *)value;
- (void)removeTranslatedBooksObject:(MZBookModel *)value;
- (void)addTranslatedBooks:(NSSet *)values;
- (void)removeTranslatedBooks:(NSSet *)values;

@end
