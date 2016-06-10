//
//  ViewController.m
//  ScrollHiddenMenuTest
//
//  Created by Dennis on 5/6/2016.
//  Copyright © 2016 Dennis. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+BFScroll.h"
#import "objc/runtime.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 21, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 1.5);
    //self.scrollView.delegate = self;
    //[self.view addSubview:self.scrollView];
     */
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 21, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.bounces = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, [UIScreen mainScreen].bounds.size.width, 80)];
    self.menuView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.menuView];
    
    __weak typeof(self) weakSelf = self;
    BFActionBlock stop = ^(BFScrollingDirection lastDirection) {
        NSLog(@"lastDirection = %ld", lastDirection);
        if (lastDirection == BFScrollingDirectionUP) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.menuView.frame = CGRectMake(0, 21, [UIScreen mainScreen].bounds.size.width, 0);
                //NSLog(@"animating hidden...");
            }];
        }
        else if (lastDirection == BFScrollingDirectionDown) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.menuView.frame = CGRectMake(0, 21, [UIScreen mainScreen].bounds.size.width, 80);
                //NSLog(@"animating showing...");
            }];
        }
    };
    
    BFActionBlock scroll = ^(BFScrollingDirection lastDirection) {
        NSLog(@"lastDirection = %ld", lastDirection);
        if (lastDirection == BFScrollingDirectionUP) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.menuView.frame = CGRectMake(0, 21, [UIScreen mainScreen].bounds.size.width, 0);
                //NSLog(@"animating hidden...");
            }];
        }
        else if (lastDirection == BFScrollingDirectionDown) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.menuView.frame = CGRectMake(0, 21, [UIScreen mainScreen].bounds.size.width, 80);
                //NSLog(@"animating showing...");
            }];
        }
    };
    
    [self setUpDelegateClass:[self class] MenuView:self.menuView conditionBlock:nil scrollActionBlock:scroll stopActionBlock:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}


#define MAINLABEL_TAG 1
#define SECONDLABEL_TAG 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCell";
    UILabel *mainLabel, *secondLabel;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 220.0, 15.0)];
        mainLabel.tag = MAINLABEL_TAG;
        mainLabel.font = [UIFont systemFontOfSize:14.0];
        mainLabel.textAlignment = NSTextAlignmentRight;
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:mainLabel];
        
        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, 220.0, 25.0)];
        secondLabel.tag = SECONDLABEL_TAG;
        secondLabel.font = [UIFont systemFontOfSize:12.0];
        secondLabel.textAlignment = NSTextAlignmentRight;
        secondLabel.textColor = [UIColor darkGrayColor];
        
        secondLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:secondLabel];
        
    } else {
        mainLabel = (UILabel *)[cell.contentView viewWithTag:MAINLABEL_TAG];
        secondLabel = (UILabel *)[cell.contentView viewWithTag:SECONDLABEL_TAG];
    }
    
    NSInteger i = indexPath.row;
    
    mainLabel.text = [NSString stringWithFormat:@"Title_%ld", i];
    secondLabel.text = [NSString stringWithFormat:@"Description_%ld", i];
    
    return cell;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"Done!");
}



@end
