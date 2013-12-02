//
//  MZCollectionShelfVC.m
//  Elephant
//
//  Created by mazhao on 13-11-27.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZCollectionShelfVC.h"

@interface MZCollectionShelfVC ()

@end

@implementation MZCollectionShelfVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 背景设置
    NSString * path = [[NSBundle mainBundle] pathForResource:@"images/bg-sea" ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:image];
    
    // collection 初始化
    
    _bookImgs = [@[@"images/unix.png", @"images/b2c.png", @"images/chuangzaomeiguo.jpg",
                   @"images/feilixing.jpg", @"images/heian.jpg", @"images/shenghuo.jpg",
                   @"images/jiaolv.jpg",@"images/manmanlai.jpg",@"images/yimin.jpg",
                   @"images/xia.jpg",] mutableCopy];
    
    
    // floating button 设计
    //UIButton *floatingButton = [[UIButton alloc] init];
    [_findButton setFrame:CGRectMake( self.view.frame.size.width - 2*FIND_ICON_WIDTH,
                                        self.view.frame.size.height - FIND_ICON_HEIGHT,
                                        FIND_ICON_WIDTH, FIND_ICON_HEIGHT)];

    
    [_findButton setBackgroundImage:
                [UIImage imageWithContentsOfFile:
         [[NSBundle mainBundle] pathForResource:@"images/bulb" ofType:@"png"]]
                             forState:UIControlStateNormal];
    
    [self.view addSubview:_findButton];
    [self.view bringSubviewToFront:_findButton];
  
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// << collection begin

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return _bookImgs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MZCollectionShelfCell * bookCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCell" forIndexPath:indexPath];
    
    
    UIImage *image;
    int row = [indexPath row];
    
    image = [UIImage imageNamed:_bookImgs[row]];
    
    bookCell.imageView.image = image;
    
    int r = arc4random() % 20;
    bookCell.label.text = [NSString stringWithFormat:@"%d 个摘要", r]; ;
    
    return bookCell;
}


// >> collection end


@end
