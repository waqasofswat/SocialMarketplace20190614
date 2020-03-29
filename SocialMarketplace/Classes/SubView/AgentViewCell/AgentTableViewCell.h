//
//  AgentTableViewCell.h
//  Real Ads
//
//  Created by De Papier on 4/10/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"
@interface AgentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *Avatar;
@property (strong, nonatomic) IBOutlet UIImageView *company;
@property (strong, nonatomic) IBOutlet UIButton *properBtn;
@property (strong, nonatomic) IBOutlet UIButton *contactBtn;

@property (strong, nonatomic) IBOutlet CBAutoScrollLabel *nameViewText;
@property (strong, nonatomic) IBOutlet CBAutoScrollLabel *addressViewText;
@property (strong, nonatomic) IBOutlet CBAutoScrollLabel *emailViewText;
@property (strong, nonatomic) IBOutlet CBAutoScrollLabel *phoneViewText;
@property (strong, nonatomic) IBOutlet CBAutoScrollLabel *skypeViewText;
@property (strong, nonatomic) IBOutlet UIView *ViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgVerified;


@end
