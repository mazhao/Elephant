//
//  MZCollectionShelfVC.m
//  Elephant
//
//  Created by mazhao on 13-11-27.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZCollectionShelfVC.h"

// constants
#define FIND_ICON_WIDTH 22
#define FIND_ICON_HEIGHT 32

// question 2:
NSInteger  kIconWidht = 22;

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

// { collection begin

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


// } collection end


// { zxing begin

- (IBAction)scan:(id)sender {

    NSLog(@"scan clicked " );
    
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    MultiFormatReader* qrcodeReader = [[MultiFormatReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    widController.readers = readers;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay = [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    
    
    [self presentViewController:widController animated:YES completion:^{
        NSLog(@"affter present");
    }];
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)resultString {

    NSLog(@"zxing scan result:%@", resultString);
    
    [self dismissModalViewControllerAnimated:YES ];
    
    // create
    id<MZBookStore> bookStore = [MZBookStoreFactory initBookStoreWithBookShelfRefreshDelegate:self
                                 ofType:kBookStoreDefault];
    
    if( [bookStore bookExist:resultString]) {
        // alert exist
        
        
    } else {
        if([bookStore fetchBook:resultString] ) {
            // fetch success
            
            
        } else {
            // fetch error
        }
        
    }
    
    // 1. query local database to check if the book dos alreay exist.
    // 1.1 if exist then next to 2
    // 1.2 if not exist then query douban book store with isbn
    // 1.2.1 if query success then add to database
    // 1.2.2 if query failed then alert failed
    // 2. query local database use isbn
    // 3. get into the detail view controller
    
}


- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    NSLog(@"zxing cancel");
    [self dismissModalViewControllerAnimated:YES];
}

// } zxing end

// BookShelfRefreshDelegate
// {
-(void) refreshViewforNewBook: (MZBook *) nb {
    // reload data
    // @TODO: to be comment out
    // [self.collectionView reloadData];
    
}

// }
@end