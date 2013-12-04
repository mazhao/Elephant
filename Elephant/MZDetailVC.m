//
//  MZDetailVC.m
//  Elephant
//
//  Created by mazhao on 13-12-3.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZDetailVC.h"

#import "MZDetailCell.h"
#import "MZDetailFooterCell.h"
#import "MZDetailHeaderCell.h"

#import "MZAppDelegate.h"

#import "MZExcerptVC.h"
#import "MZBookExcerptModel.h"

@interface MZDetailVC ()

@end

@implementation MZDetailVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"input isbn10:%@ isbn13:%@", self.isbn10, self.isbn13);
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"mzdetail vc will appear");
    // books init
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.bookModel = [delegate.bookStore getBookDetail:self.isbn13];
    if(self.bookModel == nil) {
        self.bookModel = [delegate.bookStore getBookDetail:self.isbn10];
    }
 
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.bookModel.excerpts count] + 2; // 1 for header, 1 for footer
}

/**
 *  detail cell
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if( [self isHeaderCell:indexPath] ) {
        static NSString *headerCellId = @"detailCellHeader";
        MZDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellId];
        
        if( cell == nil ) {
            cell = [[MZDetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellId];
        }
        
        
        [cell.coverImage setImageWithURL:[NSURL URLWithString: self.bookModel.imagePath ]
                           placeholderImage:[UIImage imageNamed:@"images/placeholder.png"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      NSLog(@"load image success");
                                  }];
        
        
        cell.titleLabel.text = self.bookModel.title;
        cell.subtitleLabel.text = self.bookModel.subTitle;
        
        
        NSMutableString * tagMutable = [[NSMutableString alloc] init];
        int i = 0;
        for (MZBookTagModel * tag in self.bookModel.tags) {
            if (i > 0) {
                [tagMutable appendString:@"/"];
            }
            [tagMutable appendString: tag.name ];
            i++;
        }
        
        cell.catelogLabel.text = [NSString stringWithFormat:@"类别：%@",  tagMutable ];
        cell.publishLabel.text = [NSString stringWithFormat:@"出版：%@/%@", self.bookModel.publisher, self.bookModel.pubdate ];
        cell.excerptLabel.text = [NSString stringWithFormat:@"摘要：%d个", [self.bookModel.excerpts count]];
        cell.ratingLabel.text  = [NSString stringWithFormat:@"评分：%@分（共%@人评价）", self.bookModel.ratingAvg, self.bookModel.ratingCount ];
        
        
        // set author
        NSMutableString * authorMutable = [[NSMutableString alloc] init];
        NSSet * authorSet = self.bookModel.authors;
        int index = 0;
        for (MZBookWriterModel * writer in authorSet) {
            if(index > 0) {
                [authorMutable appendString:@"/"];
            }
            [authorMutable appendString:writer.name];
            index ++;
        }
        
        cell.authorLabel.text = [NSString stringWithFormat:@"作者：%@",   authorMutable];
        
        
        
        return cell;
    } else if (  [self isFooterCell:indexPath] ) {
        static NSString *footerCellId = @"detailFooterCell";
        MZDetailFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCellId];
        
        if( cell == nil ) {
            cell = [[MZDetailFooterCell alloc] init] ;
        }
        
        return cell;
        
    } else {
        static NSString *cellId = @"detailCell";
        MZDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        if( cell == nil ) {
            cell = [[MZDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        // Configure the cell...
        
        MZBookExcerptModel * excerptModel =(MZBookExcerptModel *)  [[self.bookModel.excerpts allObjects] objectAtIndex: ([indexPath row] - 1 ) ];
        
        cell.excerptLabel.text = excerptModel.text;
        cell.dateTimeLabel.text = excerptModel.datetime;
        
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( [self isHeaderCell:indexPath] ) { // header
        return 170.0f;
    } else if(  [self isFooterCell:indexPath] ) {
        return 44.0f; // footer
    } else {
        return 80.0f; // body cell
    }
}


#pragma mark - utility method in this class


- (BOOL) isHeaderCell: (NSIndexPath *) path  {
    return [path row] == 0;
}

- (BOOL) isFooterCell: (NSIndexPath *) path  {
    return [path row] == [self.bookModel.excerpts count] + 1;
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    id controller = [segue destinationViewController];
    
    // if go to book detail
    if ( [controller class] == [MZExcerptVC class]  ) {
        
        
        MZExcerptVC * excerptVC = (MZExcerptVC *) [segue destinationViewController];
        excerptVC.isbn10 = self.isbn10;
        excerptVC.isbn13 = self.isbn13;
    }
    
    // other case such as go to setting
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
