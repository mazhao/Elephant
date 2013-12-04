//
//  MZCollectionShelfCell.h
//  Elephant
//
//  Created by mazhao on 13-11-27.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZCollectionShelfCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView * imageView;
@property (strong, nonatomic) IBOutlet UILabel * label;

@property (strong, nonatomic) NSString * isbn10;
@property (strong, nonatomic) NSString * isbn13;


@end
