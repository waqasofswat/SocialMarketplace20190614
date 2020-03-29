//
//  RevealCell.h
//  JStyle2
//
//  Created by Hicom on 11/3/14.
//  Copyright (c) 2014 HiCom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevealCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *edgeImg;
@property (strong, nonatomic) IBOutlet UIImageView *backGround;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;

@end
