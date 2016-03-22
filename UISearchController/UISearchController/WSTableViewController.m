//
//  WSTableViewController.m
//  UISearchDisplayController
//
//  Created by sw on 16/3/20.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "WSTableViewController.h"
#import "WSSearchController.h" // UISearchDisplayController在IOS8已经被废弃！取而代之的是UISearchController

#define SEARCH_RECORDS @"searchRecords"

@interface WSTableViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>
/** 所有数据 */
@property(nonatomic,strong) NSMutableArray *dataArray;
/** 搜索结果集 */
@property(nonatomic,strong) NSMutableArray *searchResults;
/** 搜索记录 */
@property(nonatomic,strong) NSMutableArray *searchRecords;
/** 搜索控制器 */
@property(nonatomic,strong) WSSearchController *searchVC;
/** 清除搜索历史记录的按钮 */
@property(nonatomic,strong) UIButton *deleteSearchRecordsButton;
@end

@implementation WSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 30;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    _searchVC = [[WSSearchController alloc] initWithSearchResultsController:nil]; // nil代表直接在当前控制器显示搜索结果
    _searchVC.searchResultsUpdater = self;
    _searchVC.searchBar.delegate = self;
    _searchVC.definesPresentationContext = YES;
    _searchVC.dimsBackgroundDuringPresentation = NO; // 如果为YES，那么会有蒙版改在搜索结果上面，导致搜索结果无法选中；如果为NO，那么就可以选中搜索结果，可以根据实际需求而设置，默认为YES
    _searchVC.hidesNavigationBarDuringPresentation = YES; // 当搜索时，是否隐藏导航条
    _searchVC.searchBar.placeholder = @"支持网站账号搜索，客户名称，手机号等关键词搜索";
    self.tableView.tableHeaderView = self.searchVC.searchBar;
    self.tableView.sectionFooterHeight = 0; // 默认是10，如果想让“清除搜索历史”和tableview紧挨着，那么需要把这个属性设置为0.
    self.tableView.sectionHeaderHeight = 0; // 默认是10
    // 加载偏好设置中的搜索记录
    [self loadSearchRecords];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchVC.active && _searchVC.searchBar.text.length == 0) {
        return self.searchRecords.count;
    } else if (_searchVC.active && _searchVC.searchBar.text.length){
        return self.searchResults.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (_searchVC.active && self.searchVC.searchBar.text.length == 0) {
        if (self.searchRecords.count == 0) {
            return cell;
        }
        cell.textLabel.text = self.searchRecords[indexPath.row];
        return cell;
    }
    if (_searchVC.active && self.searchVC.searchBar.text.length) {
        cell.textLabel.text = self.searchResults[indexPath.row];
        return cell;
    }
    
//    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_searchVC.active && self.searchRecords.count) {
        return @"搜索历史";
    } else if (_searchVC.active && _searchVC.searchBar.text.length) {
        return nil;
    }
    return nil;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
//    [label sizeToFit];
//    label.text = @"搜索历史";
//    label.backgroundColor = [UIColor redColor];
//    return label;
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //定义过滤条件
    //beginWith endWith like constains
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains %@", searchController.searchBar.text];
    if (self.searchResults) {
        
    }
    //开始过滤
    NSMutableArray *searchResults = [NSMutableArray arrayWithArray:[_searchRecords filteredArrayUsingPredicate:predicate]];
//    NSMutableArray *searchResults = [_dataArray filteredArrayUsingPredicate:predicate];
    
    if (self.searchResults) {
        [self.searchResults removeAllObjects];
    }
    //将过滤的内容显示
    self.searchResults = searchResults;
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
// 点击键盘上的search按钮调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSLog(@"点击了search按钮");
    // 在这里拿到搜索框的关键字
    NSString *searchBarText = searchBar.text;
    // 把关键字存储到偏好设置中
    // 判断关键字是否已经存在
    for (NSString *searchRecord in self.searchRecords) {
        if ([searchBarText isEqualToString:searchRecord]) {
            return;
        }
    }
    // 不存在则存储到偏好设置
    [self.searchRecords addObject:searchBarText];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.searchRecords forKey:SEARCH_RECORDS];
    NSLog(@"%@,%@",self.searchRecords,[self.searchRecords class]);

}

// 点击了searchBar上的cancel按钮调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 点击取消的时候，重写设置tableFooterView
    self.tableView.tableFooterView = [UIView new];
    NSLog(@"点击了取消按钮");
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"rESULTSlISTbUTTONcLICKED");
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"开始编辑了");
    // 也就是UISearchBar聚焦的时候会调用该方法
    // UISearchBar中文本改变的时候不会调用该方法
    // 如果有搜索历史才显示"清除搜索历史"
    if (self.searchRecords.count) {
        self.tableView.tableFooterView = self.deleteSearchRecordsButton;
    } else {
        self.tableView.tableFooterView = [UIView new]; // 写在这会导致点击了取消按钮后，tableView仍然会有那个tableFooterView，所以需要在取消的回调方法中，重新设置
        [self.tableView reloadData];
    }

}

// 点击键盘上的search按钮不会调用下面的方法
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    return YES;
//}

// 加载偏好设置中的搜索记录
- (void)loadSearchRecords
{
    // 清除原来缓存的搜索记录
//    if (self.searchRecords.count) {
//        [self.searchRecords removeAllObjects];
//    }
    
    // 缓存最新的搜索记录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *searchRecords = (NSMutableArray *)[defaults objectForKey:SEARCH_RECORDS];
    [self.searchRecords addObjectsFromArray:searchRecords];

    NSLog(@"%@,%@",self.searchRecords,[[defaults objectForKey:SEARCH_RECORDS] class]);
}

#pragma mark - getter AND setter

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"belive",
                                                        @"live",
                                                        @"love",
                                                        @"i love you",
                                                        @"like",
                                                        @"just",
                                                         nil
                      ];
    }
    
    return _dataArray;
}

- (NSMutableArray *)searchRecords
{
    if (!_searchRecords) {
        _searchRecords = [NSMutableArray array];
    }
    return _searchRecords;
}

- (UIButton *)deleteSearchRecordsButton
{
    if (!_deleteSearchRecordsButton) {
        // 创建一个按钮作为tableView尾部视图
        _deleteSearchRecordsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        [_deleteSearchRecordsButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        [_deleteSearchRecordsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_deleteSearchRecordsButton setBackgroundColor:[UIColor clearColor]];
//        [_deleteSearchRecordsButton setTintColor:[UIColor blackColor]]; // 不能设置button 的 title颜色
    }
    return _deleteSearchRecordsButton;
}
@end
