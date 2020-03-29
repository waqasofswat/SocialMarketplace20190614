//
//  AllAdsViewController.h
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface AllAdsViewController : UIViewController
@property (weak, nonatomic) IBOutlet MarqueeLabel *lblTitle;
@property (nonatomic, strong) UIRefreshControl *topRefreshTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *revealBtn;
@property (strong, nonatomic) NSString *sellerId;
@property (weak, nonatomic) IBOutlet UIView *viewTblView;

@end
