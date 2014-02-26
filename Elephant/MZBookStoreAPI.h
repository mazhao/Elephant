//
//  MZBookStoreAPI.h
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZBookModel;
@class MZBookExcerptModel;

@class NSManagedObjectID;


#pragma mark - MZBookStore

/**
 *  book store protocol
 */
@protocol MZBookStore <NSObject>

@required
- (NSString*)modelName;
- (NSString*)modelExtension;
- (NSString*)modelSqliteName;


- (BOOL)bookExist:(NSString *)isbn;

- (BOOL)fetchBook:(NSString*)isbn;

- (MZBookModel *)getBookSummary:(NSString *)isbn;
- (MZBookModel *)getBookDetail:(NSString *)isbn;

- (NSArray *)getAllBooksSummary;

- (BOOL)deleteBook:(NSString*)isbn;

- (BOOL)saveExpert:(NSString *)excerpt
     withImageData:(NSData*)imgData
           ofBoook:(NSString *)isbn13 ;

- (BOOL)updateExpert:(NSString *)excerpt
       withImageData:(NSData *)imgData
       withExcerptId:(NSManagedObjectID *)objectID
             ofBoook:(NSString*)isbn13;

- (BOOL)deleteExpert:(NSManagedObjectID *)objectID
             forBook:(NSString*)isbn13 ;

- (BOOL)deleteAllExpert:(NSString*)isbn ;

- (NSManagedObjectModel *)managedObjectModel;

@end

/**
 *  Book Store Type
 */

// question 2: k vs MZ
typedef enum {
    kBookStoreDefault = 0,
    kBookStoreCoreData,
    kBookStoreSQLite,
    kBookStoreRemoteDateSource
} BookStoreType;

/**
 *  Book Store Creator
 */
@interface MZBookStoreFactory : NSObject

+(id <MZBookStore>)initBookStoreOfType:(BookStoreType)t;

@end
