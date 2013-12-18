//
//  MZBookStoreAPI.h
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>


// !!! question 1:  !!!
//#import "MZBook.h"
//#import "MZBookSummary.h"

@class MZBookModel;
@class MZBookExcerptModel;

@class NSManagedObjectID;

// ------------------------------------------------------------------------------------------ //
// Sample:
//
// #import "MZBookStoreAPI.h"
//
// id<MZBookStore> bookStore = [MZBookStoreFactory initBookStoreWithBookShelfRefreshDelegate:self
//                                                                                    ofType:kBookStoreDefault];
// if( [bookStore bookExist:resultString] ) {
//    ...
// } else {
//    if( [bookStore fetchBook:resultString] ) {
//        ...
//    } else {
//        ...
//    }
//    
//}
// ------------------------------------------------------------------------------------------ //


// ------------------------------------------------------------------------------------------ //
/**
 *  delegate to refresh book shelf
 */

/**
@protocol BookShelfRefreshDelegate <NSObject>

// no need for the following method, because View Controller is always the delegate who alreay have the collection view.
// @property (nonatomic weak) NSCollectionView * collectionView;

-(void) refreshViewforNewBook: (MZBookModel *) nb;

@end
*/

// ------------------------------------------------------------------------------------------ //
/**
 *  book store protocol
 */
@protocol MZBookStore <NSObject>

@required // {


// static NSString* kModelName = @"MZBookModel";
// static NSString* kModelExtension = @"momd";
// static NSString* kModelSqliteName = @"MZBookModel.sqlite";


- (NSString*)modelName;
- (NSString*)modelExtension;
- (NSString*)modelSqliteName;


// @property (nonatomic, weak) id<BookShelfRefreshDelegate>  delegate;

// == single book methods ==

// to check if book alread saved
- (BOOL) bookExist:(NSString *) isbn;

// add book to database.
// 1. fetch book from book.douban.com
// 2. save to book database
// 3. invoke delegate's refreshViewforNewBook
- (BOOL) fetchBook: (NSString*) isbn;
- (MZBookModel *) getBookSummary: (NSString *) isbn;
- (MZBookModel *) getBookDetail: (NSString *) isbn;
- (BOOL) deleteBook:(NSString*) isbn;
- (NSArray *) getAllBooksSummary;


- (BOOL) saveExpert:(NSString *) excerpt withImageData:(NSData*) imgData ofBoook:(NSString*) isbn13 ;
- (BOOL) updateExpert:(NSString *) excerpt withImageData:(NSData *) imgData withExcerptId:(NSManagedObjectID *)objectID ofBoook:(NSString*) isbn13;
- (BOOL) deleteExpert:(NSManagedObjectID *) objectID forBook:(NSString*) isbn13 ;
- (BOOL) deleteAllExpert:(NSString*) isbn ;

- (NSManagedObjectModel *)managedObjectModel;

    // }

@end

// ------------------------------------------------------------------------------------------ //
/**
 *  Book Store Type
 */

// question 2: k vs MZ
typedef enum {
    kBookStoreDefault,
    kBookStoreCoreData,
    kBookStoreSQLite,
    kBookStoreRemoteDateSource
} BookStoreType;


// ------------------------------------------------------------------------------------------ //
/**
 *  Book Store Creator
 */
@interface MZBookStoreFactory : NSObject

//+( id<MZBookStore> ) initBookStoreWithBookShelfRefreshDelegate:(id<BookShelfRefreshDelegate>) delegate
//                                                        ofType: (BookStoreType) t;


+( id<MZBookStore> ) initBookStoreOfType: (BookStoreType) t;



@end
