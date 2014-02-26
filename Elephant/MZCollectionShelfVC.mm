//
//  MZCollectionShelfVC.m
//  Elephant
//
//  Created by mazhao on 13-11-27.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZCollectionShelfVC.h"
#import "MZAppDelegate.h"

#import "PopoverView.h"

#import "MZCollectionShelfHeader.h"

#import "Config.h"

@interface MZCollectionShelfVC ()


@end

@implementation MZCollectionShelfVC

// 漂浮搜索按钮
static int kFindIconWidth = 22;
static int kFindIconHeight = 32;

// 单元格选中的背景色
static UIColor * kCellSelectedColor = [UIColor lightTextColor];

// 防止多次加载
static BOOL loaded = NO;

#pragma mark - ViewController Method

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
    NSString * path = [[NSBundle mainBundle] pathForResource:DEFAULT_COLLECTION_BACKGROUND_NAME ofType:DEFAULT_COLLECTION_BACKGROUND_TYPE];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    //self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:image];
    
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0f green:243.0/255.0f  blue:243.0/255.0f  alpha:1];
    
    // collection veiw
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
    [flowLayout setMinimumInteritemSpacing:5.0f];
    
    
    self.collectionView.delegate = self;
    
    
    // floating button 设计
    [_findButton setFrame:CGRectMake( self.view.frame.size.width - 2*kFindIconWidth,
                                     self.view.frame.size.height - kFindIconHeight,
                                     kFindIconWidth, kFindIconHeight)];
    
    
    [_findButton setBackgroundImage:
     [UIImage imageWithContentsOfFile:
      [[NSBundle mainBundle] pathForResource:@"images/bulb" ofType:@"png"]]
                           forState:UIControlStateNormal];
    
    [self.view addSubview:_findButton];
    [self.view bringSubviewToFront:_findButton];
    
//    self.booksOfThisMonth = [[NSMutableArray alloc] init];
//    self.booksOfArchieve = [[NSMutableArray alloc] init];
    
    [self reloadCollectionViewData];
    
    
       
    
    loaded = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
    if (loaded) {
        loaded = NO;
    } else {
        [self reloadCollectionViewData];
    }

}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");

}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reload Collection View Utility Method
- (void)reloadCollectionViewData {
    
    self.booksOfThisMonth = [[NSMutableArray alloc] init];
    self.booksOfArchieve = [[NSMutableArray alloc] init];
    
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray * books = [delegate.bookStore getAllBooksSummary];
    
    for (MZBookModel * book in books) {
        if ([self addInThisMonth:book]) {
            [self.booksOfThisMonth addObject:book];
        } else {
            [self.booksOfArchieve addObject:book];
        }
    }
    
    NSLog(@"books count of     this month:%d", [self.booksOfThisMonth count]);
    NSLog(@"books count before this month:%d", [self.booksOfArchieve count]);
    
    
    
    [self.collectionView reloadData];
}

- (BOOL)addInThisMonth:(MZBookModel *) book {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSDate *addDate = [dateFormat dateFromString:book.addDateTime];;
    
    NSLog(@"to be check date:%@", addDate);
    
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    components.month = -1;
    NSDate *oneMonthBeforeNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    NSLog(@"check date:%@", oneMonthBeforeNow);
    
    if ( [addDate compare:oneMonthBeforeNow] > 0  ) {
        NSLog(@"add book this month:%@", book.title);
        return YES;
    } else {
        NSLog(@"add book before this mongth:%@", book.title);
        return NO;
    }
}

#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = kCellSelectedColor; // highlight selection
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor clearColor]; // Default color
}


#pragma mark - Collection View DataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 2; // this month and before
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.booksOfThisMonth count];
    } else {
        return [self.booksOfArchieve count];
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MZCollectionShelfCell * bookCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCell" forIndexPath:indexPath];
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    
    MZBookModel * book = nil;
    if(section == 0) {
        book = [self.booksOfThisMonth objectAtIndex:row];
    } else {
        book = [self.booksOfArchieve objectAtIndex:row];
    }
    
    // check image exists, reload only not exists
    
    [self setImageFromURL:book.imagePath
                  withKey:book.isbn13
             forImageView:bookCell.imageView];
    
    CALayer * layer = [bookCell.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0f];
    
    bookCell.label.text = [NSString stringWithFormat:@"%d 个摘要", [book.excerpts count]];

    bookCell.label.font = [UIFont fontWithName:kDefaultFontName size:12.0f];
       
    bookCell.isbn13 = book.isbn13;
    bookCell.isbn10 = book.isbn10;
    
    bookCell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"images/cell_bg.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] ];
    
    bookCell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"images/cell_bg_selected.png" ] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] ];
    
    
    [self addMotionEffectToView: bookCell];
    
    return bookCell;
}

- (void) addMotionEffectToView: (UIView *) view {
    
    
    if ([view.motionEffects count] > 0) {
        return ;
    }

    NSLog(@"add motion effect to view");

    UIInterpolatingMotionEffect * xAxis;
    xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = @-15;
    xAxis.maximumRelativeValue = @15;
    
    UIInterpolatingMotionEffect * yAxis;
    yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @-15;
    yAxis.maximumRelativeValue = @15;
    
    UIMotionEffectGroup * group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis, yAxis];
    
    [view addMotionEffect:group];
}


- (void)setImageFromURL: (NSString*) url withKey:(NSString* )key  forImageView:(UIImageView *) imageView {
    
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    SDImageCache *imageCache = delegate.imageCache;
    
    UIImage * cacheImg = [imageCache imageFromMemoryCacheForKey:key];
    if(cacheImg == nil) {
        cacheImg = [imageCache imageFromDiskCacheForKey:key];
    }
    
    if(cacheImg != nil) {
        [imageView setImage:cacheImg];
        NSLog(@"load image from disk or memory successfully");
    } else {
        [imageView setImageWithURL:[NSURL URLWithString: url ]
                           placeholderImage:[UIImage imageNamed:@"images/placeholder.png"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      [imageCache storeImage:image forKey:key];
                                      NSLog(@"load & cache image success");
                                  }];
    }
}

- (void)showScanVC {
    NSLog(@"scan clicked " );
    
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    
    MultiFormatReader* qrcodeReader = [[MultiFormatReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    widController.readers = readers;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay = [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    
    [self presentViewController:widController animated:YES completion:^{
        NSLog(@"affter zxing barcode reader view controller present");
    }];
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        MZCollectionShelfHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionSheldHeader" forIndexPath:indexPath];
        if ([indexPath section] == 0) {
            header.label.text = @"最近";
        } else {
            header.label.text = @"一个月前";
        }
        
        header.label.font = [UIFont fontWithName:kDefaultFontName size:16.0f];
        UIColor *ios7BlueColor = [UIColor colorWithRed:31.0/255.0f
                                                 green:117.0/255.0
                                                  blue:254.0/255.0f alpha:1.0];

        header.label.textColor = ios7BlueColor;
        
        
        
        reusableview = header;
    }
    
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"collectionFooter" forIndexPath:indexPath];
//        
//        reusableview = footerview;
//    }
    
    [self addMotionEffectToView:reusableview];
    
    return reusableview;
}

//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(5, 0, 5, 0); // top, left, bottom, right
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    
//    return 0.0;
//}


#pragma mark - PopoverView dismiss

//Delegate receives this call as soon as the item has been selected
//- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"dismiss with selected item index:%d" , index);
//    
//    if(kIndexBookScan == index) {
//        [self showScanVC];
//        
//    } else if(kIndexBookSearch == index) {
//        
//    } else {
//        
//    }
//    
//    
//    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.1f];
//    
//}

//Delegate receives this call once the popover has begun the dismissal animation
//- (void)popoverViewDidDismiss:(PopoverView *)popoverView {
//    NSLog(@"dismiss with nothing");
//}

#pragma mark - nativationg bar menu item handler

- (IBAction)scan:(id)sender {
    //    CGPoint point = CGPointMake(500.0f, 50.0f);
    //    [PopoverView showPopoverAtPoint:point inView:self.view withStringArray:@[@"扫描条码", @"书名搜索"] delegate:self ];
    //
    
    // 检查APP是否运行在模拟器中。
    UIDevice *currentDevice = [UIDevice currentDevice];
    if ([currentDevice.model rangeOfString:@"Simulator"].location == NSNotFound) {
        [self showScanVC];
    } else {
        NSLog(@"running on device~");
        
        // show loading view
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // create
        
        NSString * resultString = @"978-7-208-06164-4";
        
        MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if( [delegate.bookStore bookExist:resultString]) {
            // alert exist
            NSLog(@"book exists");
            
        } else {
            if([delegate.bookStore fetchBook:resultString] ) {
                // fetch success
                NSLog(@"fetch success");
                
            } else {
                // fetch error
                NSLog(@"fetch failed");
            }
            
        }
        
        //self.books = [delegate.bookStore getAllBooksSummary];
        [self.collectionView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }
    
}

#pragma mark - ZXing barcode scancer handler

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)resultString {
    
    NSLog(@"zxing scan isbn:%@", resultString);
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"after zxing barcode reader finished");
    }];
    
    // show loading view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // create
    
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if( [delegate.bookStore bookExist:resultString]) {
        // alert exist
        NSLog(@"book exists");
        
    } else {
        if([delegate.bookStore fetchBook:resultString] ) {
            // fetch success
            NSLog(@"fetch success");
            
        } else {
            // fetch error
            NSLog(@"fetch failed");
        }
        
    }
    
    //self.books = [delegate.bookStore getAllBooksSummary];
    [self.collectionView reloadData];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    NSLog(@"zxing cancel");
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"zxing cancel success");
    }];
}

// } zxing end

// BookShelfRefreshDelegate
// {
//-(void) refreshViewforNewBook: (MZBookModel *) nb {
//    NSLog(@"begin refresh view");
//    // books init
//    id<MZBookStore> bookStore = [MZBookStoreFactory initBookStoreWithBookShelfRefreshDelegate:self
//                                                                                       ofType:kBookStoreDefault];
//    self.books = [bookStore getAllBooksSummary];
//
//    [self.collectionView reloadData];
//
//   // [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    id controller = [segue destinationViewController];
    
    // if go to book detail
    if ( [controller class] == [MZDetailVC class]  ) {
        NSArray * paths = [self.collectionView indexPathsForSelectedItems];
        
        NSString * isbn10;
        NSString * isbn13;
        
        if([paths count] >0) {
            NSIndexPath * path = [paths objectAtIndex:0];
            MZCollectionShelfCell * cell = (MZCollectionShelfCell*)[self.collectionView cellForItemAtIndexPath:path];
            NSLog(@"cell isbn10:%@ isbn13:%@", cell.isbn10, cell.isbn13);
            
            isbn10 = cell.isbn10;
            isbn13 = cell.isbn13;
            
        } else {
            NSLog(@"no cell selected or no isbn selected");
            isbn10 = @"";
            isbn13 = @"";
        }
        
        MZDetailVC * detailVC = (MZDetailVC *) [segue destinationViewController];
        detailVC.isbn10 = isbn10;
        detailVC.isbn13 = isbn13;
    }
    
    // other case such as go to setting
}

// }
@end