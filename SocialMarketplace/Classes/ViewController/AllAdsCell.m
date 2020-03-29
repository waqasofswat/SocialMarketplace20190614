//
//  AllAdsCell.m
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import "AllAdsCell.h"

@implementation AllAdsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnReadDetail.layer.cornerRadius =4;
    self.btnReadDetail.clipsToBounds = YES;
    self.btnReadDetail.layer.shadowColor = [UIColor blackColor].CGColor;
    self.btnReadDetail.layer.shadowOffset = CGSizeMake(3 ,3);
    self.btnReadDetail.layer.shadowOpacity = 0.5;
    _btnReadDetail.backgroundColor = COLOR_PRIMARY_DEFAULT;
     _thumnails.contentMode = UIViewContentModeScaleAspectFill;
    _thumnails.clipsToBounds = YES;
}



@end
