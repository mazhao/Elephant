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

#import "MBProgressHUD.h"

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

- (void)fetchBook {
    // books init
    MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.bookModel = [delegate.bookStore getBookDetail:self.isbn13];
    if(self.bookModel == nil) {
        self.bookModel = [delegate.bookStore getBookDetail:self.isbn10];
    }
    
    // soft bookModel.excerpts
    NSSortDescriptor *datetimeSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:NO];
    NSArray* sortArray = [NSArray arrayWithObject:datetimeSortDesc];
    self.bookExcerpts = [self.bookModel.excerpts sortedArrayUsingDescriptors:sortArray];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"mzdetail vc will appear");
    
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 5, 10, 5);
    
    [self fetchBook];
    
    self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height);
    
    
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
//        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
        
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (  [self isFooterCell:indexPath] ) {
        static NSString *footerCellId = @"detailFooterCell";
        MZDetailFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCellId];

        if( cell == nil ) {
            cell = [[MZDetailFooterCell alloc] init] ;
        }
//        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    } else {
        static NSString *cellId = @"detailCell";
        MZDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        if( cell == nil ) {
            cell = [[MZDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
//        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);

        // Configure the cell...
        
        MZBookExcerptModel* excerptModel = (MZBookExcerptModel*)[self.bookExcerpts objectAtIndex:([indexPath row] -1)];
        
        cell.excerptLabel.text = [excerptModel.text stringByAppendingString:@"\n\n\n"];
        cell.dateTimeLabel.text = excerptModel.datetime;
        cell.objectID = excerptModel.objectID;
        
        if (excerptModel.image != nil ) {
            cell.imageViewId.image = [UIImage imageNamed:@"images/picplus.png"];
            //cell.imageViewId.bounds = CGRectMake(177.0, 60.0, 15.0, 15.0);
        } else {
            cell.imageViewId.image = [UIImage imageNamed:@"images/text.png"];
        }
        
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
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

#pragma mark - StoryBoard Segue method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"segue id:%@ sender:%@", segue.identifier, sender);
    
    id controller = [segue destinationViewController];
    
    // if go to book detail
    if ( [controller class] == [MZExcerptVC class]  ) {
        
        
        MZExcerptVC * excerptVC = (MZExcerptVC *) [segue destinationViewController];
        excerptVC.isbn10 = self.isbn10;
        excerptVC.isbn13 = self.isbn13;
        
        if ( [@"editExcerpt" isEqual:segue.identifier] && ( [sender class] == [MZDetailCell class] ) ) {
            MZDetailCell * detailCell = (MZDetailCell *)sender;
            excerptVC.excerpt = detailCell.excerptLabel.text;
            excerptVC.opMode = MZExcerptOperationModeEdit;
            // @TODO: add excerpt id here
            excerptVC.objectID = detailCell.objectID;
            
        }
    }
    
    // other case such as go to setting
}

#pragma mark - Table View Edit

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self isHeaderCell:indexPath] || [self isFooterCell:indexPath]) {
        return NO;
    } else {
        return YES;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        MZDetailCell* cell = (MZDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"excerpt id:%@, excerpt:%@", cell.objectID, cell.excerptLabel.text);
        
        MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [delegate.bookStore deleteExpert:cell.objectID forBook:self.isbn13];
        
        [self fetchBook]; // reload new data 
        
        [tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark button action
static int deleteType ; // 1 for book, 2 for all excerpts

-(IBAction) deleteBook:(id) sender {
    
    deleteType = 1;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"删除图书确认" message:@"您确认要删除本书和所有的摘要吗？" delegate:self cancelButtonTitle:@"不删除" otherButtonTitles:@"删除", nil];
    [alertView show];
    
}

-(IBAction) deleteAllExcerpt:(id) sender {
    deleteType = 2;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"删除所有摘要确认" message:@"您确认要删除本书的所有摘要吗？" delegate:self cancelButtonTitle:@"不删除" otherButtonTitles:@"删除", nil];
    [alertView show];
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1  ) {
   
        MZAppDelegate * delegate = (MZAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if(deleteType == 1) {
            NSLog(@"delete book %@", self.isbn13);
            [[delegate bookStore] deleteBook:self.isbn13];
            
            [self.navigationController popViewControllerAnimated:YES];

            
        } else if(deleteType == 2) {
            NSLog(@"delete all excerpt %@", self.isbn13);
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[delegate bookStore] deleteAllExpert:self.isbn13];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"delete other"); // should never get in
        }
        
    } else {
        NSLog(@" other action, such as cancel ");//
    }
}




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
