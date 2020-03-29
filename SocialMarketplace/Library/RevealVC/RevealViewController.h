//
//  RevealViewController.h
//  JStyle2
//
//  Created by Hicom on 11/3/14.
//  Copyright (c) 2014 HiCom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "SWRevealViewController.h"

@interface RevealViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,SWRevealViewControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UITableView *tblView2;
@property (strong, nonatomic) IBOutlet UIImageView *Avartar;
@property BOOL isExpand;
@property int currentFrontView;
@property (nonatomic, strong) NSMutableArray *menuArr;
@property (nonatomic, strong) NSMutableArray *menuArr2;
- (IBAction)onLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *dropImage;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
    @property (weak, nonatomic) IBOutlet UIButton *btn_login;
    

@end
