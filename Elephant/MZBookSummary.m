//
//  MZBookSummary.m
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZBookSummary.h"

@implementation MZBookSummary

    /**
     *  Description for book summary
     *
     *  @return description for book summary
     */
    - (NSString *)description {
        return [NSString stringWithFormat:@"BookSummary isbn-10:%@, isbn-13:%@, image-path:%@, excerpt-count:%@",
                _isbn10, _isbn13, _imagePath, _excerptCount];
    }


@end
