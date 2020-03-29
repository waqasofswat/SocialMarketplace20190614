//
//  AllAdsCell.h
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllAdsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumnails;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *availbleLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePostedLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnReadDetail;

@end
