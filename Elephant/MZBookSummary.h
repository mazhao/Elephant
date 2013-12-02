//
//  MZBookSummary.h
//  Elephant
//
//  Created by mazhao on 13-11-28.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZBookSummary : NSObject

    /**
     *  isbn
     */
    @property NSString * isbn10;
    @property NSString * isbn13;

    /**
     *  cover image local path
     */
    @property NSString * imagePath;


    /**
     *  当前摘要的数量，摘要包含文字，图片+文字，语音、视频等格式。
     */
    @property NSNumber * excerptCount;

@end
