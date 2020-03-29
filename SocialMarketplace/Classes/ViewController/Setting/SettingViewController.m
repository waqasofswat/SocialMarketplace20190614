//
//  SettingViewController.m
//  Real Ads
//
//  Created by Mac on 5/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgNaviBg;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGROUD_VIEW;
        _imgNaviBg.backgroundColor = COLOR_DARK_PR_MARY;
    // Do any additional setup after loading the view from its nib.
    [self setRevealBtn];
}

-(void)setRevealBtn{
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_btnBack addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
