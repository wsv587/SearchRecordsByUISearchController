//
//  WSSearchController.m
//  UISearchDisplayController
//
//  Created by sw on 16/3/20.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "WSSearchController.h"

@interface WSSearchController ()

@end

@implementation WSSearchController

- (void)viewDidLoad {
    [super viewDidLoad];

    //    [self.searchBar setShowsSearchResultsButton:YES];// 是否显示搜索结果按钮
    // searchBar的样式
//    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
//    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    
//    UITextField *textfield = [self.searchBar valueForKey:@"_searchField"]; // 拿到textField
//    [textfield setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"]; // 修改占位文字颜色
//    [textfield setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"]; // 修改占位文字大小
    
    //    for (UIView *subView in [self.searchBar.subviews[0] subviews]) {
//        if ([subView isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)subView;
//            [button setTitle:@"取消" forState:UIControlStateNormal];
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        
        UITextField *textfield = [self.searchBar valueForKey:@"_searchField"];
        [textfield setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        //        [searchField setValue：[UIColorblueColor]forKeyPath:@"_placeholderLabel.textColor"];
        //        [textfield setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        
        
        // 把"cancel"改为“取消”
        // 注意：必须要：self.searchBar.showsCancelButton = YES;否则无效！
        // 在这里设置默认未获得焦点时候也显示“取消”，所以不在设置设置，把代码移植到searchBar的代理方法：searchBarTextDidBeginEditing中
        
        //        self.searchBar.showsCancelButton = YES;
        //        for (id subView in [self.searchBar.subviews[0] subviews]) {
        //            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
        //                UIButton *cancelButton = (UIButton *)subView;
        //                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        //                NSLog(@"...");
        //            }
        //        }
        
    }
    return self;
}




@end
