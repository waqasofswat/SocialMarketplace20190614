//
//  RevealViewController.m
//  JStyle2
//
//  Created by Hicom on 11/3/14.
//  Copyright (c) 2014 HiCom. All rights reserved.
//

#import "RevealViewController.h"
#import "RevealCell.h"
#import "SWRevealViewController.h"
#import "SocialMarketplace-Swift.h"
#import "UIImageView+WebCache.h"

@interface RevealViewController ()
{
    NSIndexPath *selectedRow;
    NSString *strSafety;

    NSString *strFeedBack;

}
@end

@implementation RevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self text];
    self.view.backgroundColor = [UIColor whiteColor];
    selectedRow = [NSIndexPath indexPathForRow:0 inSection:0];
    self.menuArr = [[NSMutableArray alloc]init];
    self.menuArr2 = [[NSMutableArray alloc]init];
    [self getData];
    [self getData2];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _currentFrontView = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([login_already isEqualToString:@"1"]) {
        [_dropImage setImage:[UIImage imageNamed:@"login_down"]];
        _agentLabel.text = gUser.usName;
        self.tblView2.hidden = YES;
        self.tblView.hidden = NO;
        [self.Avartar setImageWithURL:[NSURL URLWithString:gUser.usImage] placeholderImage:[UIImage imageNamed:@"avatar_default-1.png"]];
    } else if ([login_already isEqualToString:@"2"])
    {
        self.tblView2.hidden = NO;
        self.tblView.hidden = YES;
        [_dropImage setImage:[UIImage imageNamed:@"login_up"]];
        _agentLabel.text = gUser.usName;
      [self.Avartar setImageWithURL:[NSURL URLWithString:gUser.usImage] placeholderImage:[UIImage imageNamed:@"avatar_default-1.png"]];
    } else
    {
        _agentLabel.text = [Util localized:@"rv_lbl_login"];
        [_dropImage setImage:[UIImage imageNamed:@"ic_login1"]];
        self.Avartar.image = [UIImage imageNamed:@"avatar_default-1.png"];
    }
    
    self.Avartar.layer.cornerRadius = self.Avartar.frame.size.width / 2;
    [self.Avartar setContentMode:UIViewContentModeScaleAspectFill];
    _Avartar.clipsToBounds = YES;
    //_Avartar.layer.cornerRadius = _Avartar.frame.size.width/2;
}
-(void)getData{
    
    [self.menuArr removeAllObjects];
    for (int i=0; i<9; i++) {
        Menu *m = [[Menu alloc]init];
        switch (i) {
            case 0:
                m.name = [Util localized:@"rv_menu_home"];
                m.image = @"ic_home.png";
                m.image2 = @"ic_home.png";
                break;
            case 1:
                m.name = [Util localized:@"rv_menu_category"];
                m.image =@"ic-menu-category";
                m.image2 =@"ic-menu-category";
                break;
            case 2:
                m.name = [Util localized:@"rv_menu_search"];
                m.image = @"ic-menu-search";
                m.image2 = @"ic-menu-search";
                break;
            case 3:
                m.name = [Util localized:@"rv_menu_news"];
                m.image = @"ic-menu-news";
                m.image2 = @"ic-menu-news";
                break;
            case 4:
                m.name = [Util localized:@"rv_menu_sellers"];
                m.image = @"ic-menu-seller";
                m.image2 = @"ic-menu-seller";
                break;
            case 5:
                m.name =[Util localized:@"rv_menu_recent_chat"];
                m.image = @"ic_chat";
                m.image2 = @"ic_chat";
                break;
//            case 6:
//                m.name = @"FAQ";
//                m.image = @"ic-menu-faq";
//                m.image2 =@"ic-menu-faq";
//                break;
            case 6:
                m.name = [Util localized:@"rv_menu_contact_us"];
                m.image =@"ic-menu-contact";
                m.image2 =@"ic-menu-contact";
                break;
                
            case 7:
                m.name = [Util localized:@"rv_menu_about"];
                m.image = @"ic-menu-information";
                m.image2 = @"ic-menu-information";
                
                break;
                
            default:
                break;
        }
        [self.menuArr addObject:m];
    }
    
    
    [self.tblView2 reloadData];
}

-(void)getData2{
    
    [self.menuArr2 removeAllObjects];
    for (int i=0; i<8; i++) {
        Menu *m = [[Menu alloc]init];
        switch (i) {
            case 0:
                m.name = [Util localized:@"rv_menu_my_account"];
                m.image = @"ic-menu-account";
                m.image2 = @"ic-menu-account";
                break;
            case 1:
                m.name = [Util localized:@"rv_menu_new_ad"];
                m.image = @"ic-menu-add-ads";
                m.image2 = @"ic-menu-add-ads";
                break;
            case 2:
                m.name = [Util localized:@"rv_menu_my_ads"];
                m.image = @"ic-menu-manage-ads";
                m.image2 = @"ic-menu-manage-ads";
                break;
            case 3:
                m.name = [Util localized:@"rv_menu_my_message"];
                m.image = @"ic-menu-messages";
                m.image2 = @"ic-menu-messages";
                break;
                
            case 4:
                m.name = [Util localized:@"rv_menu_mysubcription"];
                m.image = @"ic-menu-subscription";
                m.image2 = @"ic-menu-subscription";
                break;
            case 5:
                m.name = [Util localized:@"rv_menu_favorite"];
                m.image = @"ic-menu-favorite";
                m.image2 = @"ic-menu-favorite";
                break;
        
            case 6:
                m.name = [Util localized:@"rv_menu_change_password"];
                m.image = @"ic-menu-change-password";
                m.image2 = @"ic-menu-change-password";
                break;
        /*    case 6:
                m.name = @"Feedback";
                m.image =@"ic-menu-contact";
                m.image2 =@"ic-menu-contact";
                break; */

            case 7:
                m.name = [Util localized:@"rv_menu_logout"];
                m.image = @"ic-menu-logout";
                m.image2 = @"ic-menu-logout";
                
                break;
            default:
                break;
        }
        [self.menuArr2 addObject:m];
    }
    
    
    [self.tblView reloadData];
}

#pragma mark UITABALEVIEW DATASOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tblView) {
        return self.menuArr.count;
    } else
    {return self.menuArr2.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 39;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tblView) {
        RevealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevealCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RevealCell" owner:nil options:nil] objectAtIndex:0];
            
            Menu *m = [self.menuArr objectAtIndex:indexPath.row];
            cell.nameLbl.text = m.name;
            cell.imgView.image = [UIImage imageNamed:m.image];
            cell.edgeImg.hidden = YES;
            
            if(m.image.length==0){
                
                cell.nameLbl.frame = CGRectMake(cell.nameLbl.frame.origin.x+10, cell.nameLbl.frame.origin.y
                                                , cell.nameLbl.frame.size.width+20, cell.nameLbl.frame.size.height);
                cell.nameLbl.font = [UIFont systemFontOfSize:10];
            }
            cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
        }
        if (indexPath.row == 5) {
            cell.bottomView.hidden = NO;
        }
        return cell;
    } else
    {
        RevealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevealCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RevealCell" owner:nil options:nil] objectAtIndex:0];
            
            Menu *m = [self.menuArr2 objectAtIndex:indexPath.row];
            
            cell.nameLbl.text = m.name;
            
            cell.imgView.image = [UIImage imageNamed:m.image];
            cell.edgeImg.hidden = YES;
          //  cell.backGround.backgroundColor = [UIColor whiteColor];
            
            if(m.image.length==0){
                
                cell.nameLbl.frame = CGRectMake(cell.nameLbl.frame.origin.x+10, cell.nameLbl.frame.origin.y
                                                , cell.nameLbl.frame.size.width+20, cell.nameLbl.frame.size.height);
                
                cell.nameLbl.font = [UIFont systemFontOfSize:10];
            }
            
            cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
            
        }
        if (indexPath.row == 4) {
            cell.bottomView.hidden = NO;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tblView) {
        SWRevealViewController *revealController = self.revealViewController;
        selectedRow = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        if (indexPath.row == 0) {
            HomeVC *detail = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
        if (indexPath.row == 1) {
            AllCategoriesViewController *detail = [[AllCategoriesViewController alloc]initWithNibName:@"AllCategoriesViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
        if (indexPath.row == 2) {
           
            SeachViewController *detail = [[SeachViewController alloc]initWithNibName:@"SeachViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
        if (indexPath.row == 3) {
            NewsViewController *detail = [[NewsViewController alloc]initWithNibName:@"NewsViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
            //nghiadanhdau
        }
        if (indexPath.row == 4) {
            AllAgentViewController *detail = [[AllAgentViewController alloc]initWithNibName:@"AllAgentViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
            //nghiadanhdau
        }
        if (indexPath.row == 5) {
            if (!gUser) {
                [self.view makeToast:@"Please login to use this function!" duration:2.0 position:CSToastPositionCenter];
                return;
            }
           ListChatViewController *vc = [[ListChatViewController alloc]initWithNibName:@"ListChatViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
            
        }
        if (indexPath.row == 6) { // Contact Us
            ContactUsVC *vc = [[ContactUsVC alloc]initWithNibName:@"ContactUsVC" bundle:nil];
            vc.strTitle = [Util localized:@"rv_menu_contact_us"];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
    
        if (indexPath.row == 7) {
            AboutViewController *detail = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
    } else
    {
        SWRevealViewController *revealController = self.revealViewController;
        selectedRow = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
        if (indexPath.row == 0) {
            MyAccountVC *detail = [[MyAccountVC alloc]initWithNibName:@"MyAccountVC" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
        if (indexPath.row == 1) {
            AddNewAdsVC *detail = [[AddNewAdsVC alloc]initWithNibName:@"AddNewAdsVC" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
        if (indexPath.row == 2) {
            MyAdsVC *detail = [[MyAdsVC alloc]initWithNibName:@"MyAdsVC" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
        if (indexPath.row == 4) {
            MySubscriptionViewController *detail = [[MySubscriptionViewController alloc]initWithNibName:@"MySubscriptionViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
            //nghiadanhdau ngon
        }
        if (indexPath.row == 3) {
            MessagesViewController *vc = [[MessagesViewController alloc]initWithNibName:@"MessagesViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }
        if (indexPath.row == 5) { //bookmark
            MyBookMarksVC *vc = [[MyBookMarksVC alloc]initWithNibName:@"MyBookMarksVC" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
            //nghiadanhdau
        }
        if (indexPath.row == 6) {
            ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:nil];
            UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [naviVC setNavigationBarHidden:YES animated:NO];
            [revealController pushFrontViewController:naviVC animated:YES];
        }

        if (indexPath.row == 7) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Util localized:@"rv_title_logout"] message:[Util localized:@"rv_msg_logout"] delegate:self cancelButtonTitle:[Util localized:@"btn_yes"] otherButtonTitles:[Util localized:@"btn_no"], nil];
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        login_already = @"0";
        [ModelManager logoutWithSuccess:^(NSString *strStatus) {
            //
        } failure:^(NSString *err) {
            //
        }];
        self.tblView2.hidden = YES;
        self.tblView.hidden = NO;
        selectedRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [Util setObject:login_already forKey:KEY_LOGIN];
        [[[FIRDatabase database].reference  child:[NSString stringWithFormat:@"user/%@", gUser.usId]] updateChildValues:@{@"status" : @"0"}];
        gUser = nil;
        [_tblView reloadData];
        SWRevealViewController *revealController = self.revealViewController;
        HomeVC *detail = [[HomeVC alloc]initWithNibName:@"HomeVC" bundle:nil];
        [revealController pushFrontViewController:detail animated:YES];
        [Util removeObjectForKey:@"email"];
    }
}

- (IBAction)onLogin:(id)sender {
    if ([login_already isEqualToString:@"1"]) {
        self.tblView2.hidden = NO;
        self.tblView.hidden = YES;
        login_already = @"2";
        [_dropImage setImage:[UIImage imageNamed:@"login_up"]];
    } else if ([login_already isEqualToString:@"2"])
    {
        
        self.tblView2.hidden = YES;
        self.tblView.hidden = NO;
        login_already = @"1";
        [_dropImage setImage:[UIImage imageNamed:@"login_down"]];
    } else
    {
        SWRevealViewController *revealController = self.revealViewController;
        LoginViewController *detail = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:detail];
        [naviVC setNavigationBarHidden:YES animated:NO];
        [revealController pushFrontViewController:naviVC animated:YES];
    }
}
    -(void) text {
        _agentLabel.text = [Util localized:@"rv_lbl_login"];
    }
@end
