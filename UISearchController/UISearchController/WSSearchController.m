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
    // Do any additional setup after loading the view.

    for (UIView *subView in [self.searchBar subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            [button setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
