//
//  MZBookStoreFactory.m
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZBookStoreAPI.h"
#import "MZBookStoreDefault.h"

@implementation MZBookStoreFactory

//    +( id<MZBookStore> ) initBookStoreWithBookShelfRefreshDelegate:(id<BookShelfRefreshDelegate>) delegate
//                                                            ofType:(BookStoreType) t{
//        
//        switch (t) {
//            case kBookStoreDefault:
//                return [MZBookStoreDefault instance:delegate];
//                break;
//                
//            case kBookStoreCoreData:
//                
//            case kBookStoreSQLite:
//            case kBookStoreRemoteDateSource:
//                return[MZBookStoreDefault instance:delegate]; // @todo return specific book store type
//                break;
//                
//            default:
//                return [MZBookStoreDefault instance:delegate];
//                break;
//        }
//        
//        
//        
//    }


+( id<MZBookStore> ) initBookStoreOfType: (BookStoreType) t {
    switch (t) {
        case kBookStoreDefault:
            return [MZBookStoreDefault instance];
            break;
            
        case kBookStoreCoreData:
            
        case kBookStoreSQLite:
        case kBookStoreRemoteDateSource:
            return[MZBookStoreDefault instance]; // @todo return specific book store type
            break;
            
        default:
            return [MZBookStoreDefault instance];
            break;
    }
    
}


@end
