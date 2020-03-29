//
//  SortViewController.m
//  Real Estate
//
//  Created by Hicom on 3/24/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import "SortViewController.h"

@interface SortViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDetail)];
    tap.numberOfTapsRequired =2;
    [self.view addGestureRecognizer:tap];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = view;
    self.tableView.bounces = NO;
}
-(void)viewWillAppear:(BOOL)animated{

}
-(void)viewDidAppear:(BOOL)animated{
    if (_arrDataSource.count >5) {
        _constrainTbViewHeight.constant = 44*5;
    }else{
        _constrainTbViewHeight.constant = 44*_arrDataSource.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrDataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *item = self.arrDataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", item] ;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSString *item = self.arrayItems[indexPath.row];
    [self closeDetail];
    [self.delegate sortViewDidSelectedItemAtIndex:(int)indexPath.row];
}

-(void)presentInParentViewController:(UIViewController *)parentViewController{
    
    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    
}

-(void)dismissFromParentViewController{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self didMoveToParentViewController:self.parentViewController];
}

-(void)closeDetail{
    [self dismissFromParentViewController];
}
@end
