//
//  MZDetailHeaderCell.h
//  Elephant
//
//  Created by mazhao on 13-12-3.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZDetailHeaderCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * coverImage;
@property (retain, nonatomic) IBOutlet UILabel * titleLabel;
@property (retain, nonatomic) IBOutlet UILabel * subtitleLabel;
@property (retain, nonatomic) IBOutlet UILabel * authorLabel;
@property (retain, nonatomic) IBOutlet UILabel * catelogLabel;
@property (retain, nonatomic) IBOutlet UILabel * publishLabel;
@property (retain, nonatomic) IBOutlet UILabel * excerptLabel;
@property (retain, nonatomic) IBOutlet UILabel * ratingLabel;

@end
