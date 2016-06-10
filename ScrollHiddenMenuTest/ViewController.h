//
//  ViewController.h
//  ScrollHiddenMenuTest
//
//  Created by Dennis on 5/6/2016.
//  Copyright © 2016 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *menuView;

@property (strong, nonatomic) UITableView *tableView;

@end

