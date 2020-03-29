//
//  LoadMoreTableViewCell.m
//  Real Ads
//
//  Created by De Papier on 4/14/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import "LoadMoreTableViewCell.h"

@implementation LoadMoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIColor *shadow2 = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    _loadMoreBtn.layer.shadowColor = shadow2.CGColor;
    _loadMoreBtn.layer.shadowOffset = CGSizeMake(0, 1);
    _loadMoreBtn.layer.shadowOpacity = 1.0;
    _loadMoreBtn.layer.shadowRadius = 0.0;
    _loadMoreBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
