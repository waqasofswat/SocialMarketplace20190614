//
//  ContactViewController.m
//  Real Ads
//
//  Created by De Papier on 4/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import "ContactViewController.h"
#import "UIView+Toast.h"
#import "SocialMarketplace-Swift.h"
#import "UIImageView+WebCache.h"
@interface ContactViewController ()
{
    int textViewInt;

}
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UIImageView *imgNaviBg;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initLayout];
    if (!_adsId) {
        _adsId = @"";
    }
    self.questionTextView.delegate = self;
    if (_seller) {
        [self layoutView1];
    }else{
        [self loadContact];
    }

}
-(void)initLayout{
    _imgNaviBg.backgroundColor = COLOR_DARK_PR_MARY;

    [self.Avatar setContentMode:UIViewContentModeScaleAspectFill];
    self.Avatar.clipsToBounds = YES;
}



-(void)layoutView1
{
    _lblEmail.text = _seller.usEmail;
    _lblPhone.text = _seller.usPhone;
    [self.Avatar setImageWithURL:[NSURL URLWithString:_seller.usImage] placeholderImage:IMAGE_HODER];
    self.nameLabel.text = _seller.usName;

    if ([_seller.usIsverified isEqualToString:@"0"]) {
        self.imgVerified.hidden = true;

    }else{
        self.imgVerified.hidden = false;

    }
}

- (IBAction)onReport:(id)sender {
    ContactUsVC *contacVC = [[ContactUsVC alloc]initWithNibName:@"ContactUsVC" bundle:nil];
    contacVC.strTitle = CONTACT_REPORT_SELLER;
    contacVC.strContent = [NSString stringWithFormat:@"%@%@%@%@",@"Seller ID : ",self.seller.usId,@", name: ",self.seller.usName];
    [self.navigationController pushViewController:contacVC animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCallNow:(id)sender {
    if (_seller.usPhone.length >0) {
        [Util callPhoneNumber:_seller.usPhone];
    }else{
        [self.view makeToast:[Util localized:@"mess_cant_call"] duration:1.5 position:CSToastPositionCenter ];
    }
}

-(void)loadContact
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager getSellerDetailWithId:_sellerId withSuccess:^(id successObj) {
        _seller = successObj;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self layoutView1];
    } failure:^(NSString *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:err duration:2.0 position:CSToastPositionCenter];
        
    }];
}
- (IBAction)onSend:(id)sender {
    [self.view endEditing:YES];
    if (_namTextField.text.length == 0 || _phoneTextField.text.length==0 || _emailTextField.text.length ==0 || _titleTextField.text.length ==0) {
        [self.view makeToast:[Util localized:@"mess_okease_fill"] duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager sendMessageWithAdsId:_adsId accountId:_seller.usId name:_namTextField.text phone:_phoneTextField.text email:_emailTextField.text title:_titleTextField.text content:_questionTextView.text withSuccess:^(NSString *successStr) {
        if (self) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:successStr duration:2.0 position:CSToastPositionCenter];
        }
        
    } failure:^(NSString *err) {
        if (self) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:err duration:2.0 position:CSToastPositionCenter];
        }
    }];
}
- (IBAction)onSendEmail:(id)sender {
    NSString *customURL = [NSString stringWithFormat:@"Mailto://%@",_seller.usEmail];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:[Util localized:@"alert"]]
                                                       delegate:self cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)text {
    _lbl_contact.text = [Util localized:@"lbl_top_contact"];
    [_callnowBtn setTitle:[Util localized:@"btn_contact_call"] forState:UIControlStateNormal];
     [_btnReport setTitle:[Util localized:@"btn_contact_report"] forState:UIControlStateNormal];
     [_sendBtn setTitle:[Util localized:@"btn_send_message"] forState:UIControlStateNormal];
}
@end
