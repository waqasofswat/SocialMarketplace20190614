//
//  AllAdsViewController.m
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import "AllAdsViewController.h"
#import "UITableView+DragLoad.h"
#import "AllAdsCell.h"
#import "NothingCell.h"
#import "DetailAdsViewController.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "Validator.h"
#import "SortViewController.h"
#import "MBProgressHUD.h"
#import "HomeViewCell.h"

@interface AllAdsViewController () <UITableViewDragLoadDelegate, UITableViewDataSource, UITableViewDelegate, SortViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topNaviView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation AllAdsViewController{
    NSMutableArray *arrAds;
    NSArray *arrSortType;
    BOOL isLoading;
    int page,start_index;
    NSString *sortType,*sortBy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.view.backgroundColor = COLOR_BACKGROUD_VIEW;
    _topNaviView.backgroundColor = COLOR_DARK_PR_MARY;
    _tableView.layer.masksToBounds =NO;
    _viewTblView.layer.masksToBounds = YES;
    
    page =1;
    start_index =1;
    arrAds = [[NSMutableArray alloc]init];
    [self initSortFunction];
    [self initLoadmoreAndPulltoRefresh];
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:01. target:self selector:@selector(getData) userInfo:nil repeats:NO];
}

-(void)initSortFunction{
    arrSortType = @[@"Sort by Name asc",
                    @"Sort by Name desc",
                    @"Sort by Date asc",
                    @"Sort by Date desc",
                    @"Number of Viewed acs",
                    @"Number of Viewed desc"];
    sortBy = SORT_BY_ALL;
    sortType = SORT_TYPE_NORMAL;
}


-(void)initLoadmoreAndPulltoRefresh{
    isLoading = false;
    _topRefreshTable = [UIRefreshControl new];
    _topRefreshTable.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to reload!" attributes:@{NSForegroundColorAttributeName:COLOR_PRIMARY_DEFAULT }];
    _topRefreshTable.tintColor = COLOR_PRIMARY_DEFAULT;
    [_topRefreshTable addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    [_tableView addSubview:_topRefreshTable];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull up to load more!"attributes:@{NSForegroundColorAttributeName:COLOR_PRIMARY_DEFAULT}];
    // refreshControl.triggerVerticalOffset = 60;
    [refreshControl addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = COLOR_PRIMARY_DEFAULT;
    self.tableView.bottomRefreshControl = refreshControl;
    
}

-(void)refreshData{
    if (isLoading) {
        return;
    }else
        start_index = 1;
    isLoading = true;
    [self performSelectorInBackground:@selector(getData) withObject:nil];
}
-(void)loadMore{
    if (isLoading) {
        return;
    }else{
        isLoading = true;
    }
    if (start_index==page) {
        [self.view makeToast:@"No more products" duration:2.0 position:CSToastPositionCenter];
        [self finishLoading];
        return;
    }
    start_index+=1;
    [self performSelectorInBackground:@selector(getData) withObject:nil];
}

-(void)getData{
    [MBProgressHUD showHUDAddedTo:self.viewTblView animated:YES];
    [ModelManager getAdsByUserId:_sellerId andPage:[NSString stringWithFormat:@"%d",start_index] sortType:sortType sortBy:sortBy withSuccess:^(NSDictionary *dicReturn) {
        if (start_index == 1) {
            [arrAds removeAllObjects];
        }
        if (self) {
            dispatch_async(dispatch_get_main_queue(), ^{
                page = [dicReturn[@"allpage"] intValue];
                [arrAds addObjectsFromArray:dicReturn[@"arrAds"]];
                [self finishLoading];
                [_tableView reloadData];
            });
        }
        
    } failure:^(NSString *error) {
        if (self) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self finishLoading];
                [self.view makeToast:error duration:3.0 position:CSToastPositionCenter];
            });
        }
    }];
    
}
-(void)finishLoading{
    [MBProgressHUD hideAllHUDsForView:self.viewTblView animated:YES];
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    [_topRefreshTable endRefreshing];
    [self.tableView.bottomRefreshControl endRefreshing];
    isLoading = false;
}


#pragma mark UITABALEVIEW DATASOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrAds.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //  if (!((indexPath.row == estateArr.count)&&(estateArr.count == start_index))) {
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    Ads *est = [arrAds objectAtIndex:indexPath.row];
    [cell setupDataWithAds:est];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Ads *est = [arrAds objectAtIndex:indexPath.row];
    DetailAdsViewController *VC = [[DetailAdsViewController alloc]initWithNibName:@"DetailAdsViewController" bundle:nil];
    VC.objAds = est;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)readMore:(UIButton*)button
{
    int index =0;
    if (button.tag) {
        index = (int)button.tag;
    }
    Ads *est = [arrAds objectAtIndex:index];
    DetailAdsViewController *VC = [[DetailAdsViewController alloc]initWithNibName:@"DetailAdsViewController" bundle:nil];
    VC.objAds = est;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSort:(id)sender {
    
    SortViewController *sortVC = [[SortViewController alloc]initWithNibName:@"SortViewController" bundle:nil];
    sortVC.delegate = self;
    sortVC.arrDataSource = arrSortType;
    [sortVC presentInParentViewController:self];
    
    
}

-(void)sortViewDidSelectedItemAtIndex:(int)rowSelected{
    switch (rowSelected) {
        case 0:
            sortBy = SORT_BY_NAME;
            sortType = SORT_TYPE_ASC;
            break;
        case 1:
            sortBy = SORT_BY_NAME;
            sortType = SORT_TYPE_DESC;
            break;
        case 2:
            sortBy = SORT_BY_POSTED_DATE;
            sortType = SORT_TYPE_ASC;
            break;
        case 3:
            sortBy = SORT_BY_POSTED_DATE;
            sortType = SORT_TYPE_DESC;
            break;
        case 4:
            sortBy = SORT_BY_VIEW;
            sortType = SORT_TYPE_ASC;
            break;
        case 5:
            sortBy = SORT_BY_VIEW;
            sortType = SORT_TYPE_DESC;
            break;
            
        default:
            break;
    }
    start_index =1;
    isLoading = YES;
    [self getData];
    [_activityIndicator startAnimating];
    _activityIndicator.hidden =NO;
    
}

@end
