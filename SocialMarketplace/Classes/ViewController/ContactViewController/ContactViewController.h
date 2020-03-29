//
//  ContactViewController.h
//  Real Ads
//
//  Created by De Papier on 4/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"
#import "CBAutoScrollLabel.h"
#import "User.h"
#import "MarqueeLabel.h"
#import "JVFloatLabeledTextView.h"
#import "JVFloatLabeledTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface ContactViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;


@property (strong, nonatomic) IBOutlet UIImageView *Avatar;

@property (strong, nonatomic) IBOutlet UIButton *callnowBtn;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextView *questionTextView;

@property (strong, nonatomic) User *seller;
@property (strong, nonatomic) NSString *sellerId;
@property (strong, nonatomic) NSString *adsId;
@property (strong, nonatomic) NSString *fromScreen;
- (IBAction)onBack:(id)sender;
- (IBAction)onCallNow:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)onSend:(id)sender;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *namTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *titleTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imgVerified;

@property (weak, nonatomic) IBOutlet UILabel *lbl_contact;

@end
