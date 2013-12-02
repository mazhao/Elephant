//
//  MZBookStoreDefault.m
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZBookStoreDefault.h"



/**
 *  singleton instance - static instance variable
 */
static MZBookStoreDefault *instance = nil;


@implementation MZBookStoreDefault

    // !!! MUST manually synthesize properties defined in protocol !!!
    @synthesize delegate =_delegate ;

    /**
     *  singleton instance - class method implementation
     *
     *  @param delegate MZBookShelfRefreshDelegate
     *
     *  @return single instance of MZBookStoreDefault
     */
    +(MZBookStoreDefault *) instance: (id<BookShelfRefreshDelegate> ) delegate {
        if(!instance) {
            instance = [[MZBookStoreDefault alloc] init];
            [instance setDelegate:delegate];
            
        }
        
        return instance;
    }

// --------------------------------------------------------------- //
// core data context init

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// --------------------------------------------------------------- //


    // to check if book alread saved
    -(BOOL) bookExist:(NSString *) isbn {
        
        
        
        return YES;
    }

    // add book to database.
    // 1. fetch book from book.douban.com
    // 2. save to book database
    // 3. invoke delegate's refreshViewforNewBook
    -(BOOL) fetchBook: (NSString*) isbn {
        
        // get book from douban book api then save it to the core data store
        
        // 1st: fetch
        
        MZBook * book = [[MZBook alloc] init];
        book.isbn10 = @"1234567890";
        book.isbn13 = @"1234567890123";
        book.excerptCount = @10;
        book.imagePath = @"http://www.douban.com/book/123/jpg";
        
        
        // 2nd: save
        
        
        
        
        return YES;
    }

    //
    -(MZBook *) getBookSummary: (NSString *) isbn {
        return nil;
    }

    -(MZBook *) getBookDetail: (NSString *) isbn {
        return nil;
    }


    // multiple books methods
    /**
     *
     *
     *  @return Summary book store
     */
    -(NSArray *) getAllBooksSummary {
        NSArray * array = [[NSArray alloc] initWithObjects: nil];
        return array;
    }
@end
