//
//  MZCollectionShelfVC.m
//  Elephant
//
//  Created by mazhao on 13-11-27.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZCollectionShelfVC.h"
#import "MZAppDelegate.h"

// constants
static int kFindIconWidth = 22;
static int kFindIconHeight = 32;

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
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.bookStore = [MZBookStoreFactory initBookStoreWithBookShelfRefreshDelegate:self
                                            ofType:kBookStoreDefault];
    self.books = [delegate.bookStore getAllBooksSummary];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collection view

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [self.books count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MZCollectionShelfCell * bookCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCell" forIndexPath:indexPath];
    
    
    UIImage *image;
    int row = [indexPath row];
    
    //image = [UIImage imageNamed:_bookImgs[row]];
    
    MZBookModel * book =(MZBookModel *)[self.books objectAtIndex:row];
    
    NSString *url = book.imagePath;
    
    
    NSURL *imageURL = [NSURL URLWithString: url ];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    image = [UIImage imageWithData:imageData];
    
    bookCell.imageView.image = image;
    
    
    [bookCell.imageView setImageWithURL:[NSURL URLWithString: url ]
                      placeholderImage:[UIImage imageNamed:@"images/placeholder.png"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                 NSLog(@"load image success");
                             }];
    
    bookCell.label.text = [NSString stringWithFormat:@"%d 个摘要", [book.excerpts count]]; ;
    bookCell.isbn13 = book.isbn13;
    bookCell.isbn10 = book.isbn10;
    
    return bookCell;
}


#pragma mark - Action handler

- (IBAction)scan:(id)sender {

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

#pragma mark - ZXing barcode scancer handler

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)resultString {

    NSLog(@"zxing scan isbn:%@", resultString);
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"after zxing barcode reader finished");
    }];
    
    // show loading view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // create
    id<MZBookStore> bookStore = [MZBookStoreFactory initBookStoreWithBookShelfRefreshDelegate:self
                                 ofType:kBookStoreDefault];
    
    if( [bookStore bookExist:resultString]) {
        // alert exist
        NSLog(@"book exists");
        
    } else {
        if([bookStore fetchBook:resultString] ) {
            // fetch success
            NSLog(@"fetch success");
            
        } else {
            // fetch error
            NSLog(@"fetch failed");
        }
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];

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
  //  [MBProgressHUD hideHUDForView:self.view animated:YES];

}

// } zxing end

// BookShelfRefreshDelegate
// {
-(void) refreshViewforNewBook: (MZBookModel *) nb {
    NSLog(@"begin refresh view");
    // reload data
    // @TODO: to be comment out
    // [self.collectionView reloadData];
    
    // books init
    id<MZBookStore> bookStore = [MZBookStoreFactory initBookStoreWithBookShelfRefreshDelegate:self
                                                                                       ofType:kBookStoreDefault];
    self.books = [bookStore getAllBooksSummary];

    [self.collectionView reloadData];
 
   // [MBProgressHUD hideHUDForView:self.view animated:YES];

}

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