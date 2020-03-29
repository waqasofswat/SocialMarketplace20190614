//
//  SortViewController.h
//  Real Estate
//
//  Created by Hicom on 3/24/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SortViewDelegate <NSObject>
-(void)sortViewDidSelectedItemAtIndex:(int)rowSelected;
@end

@interface SortViewController : UIViewController
@property (strong, nonatomic) NSArray *arrDataSource;
@property (nonatomic, weak) id<SortViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTbViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTbViewTrailling;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainTbViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTbViewWidth;


- (void)presentInParentViewController:(UIViewController *)parentViewController;
- (void)dismissFromParentViewController;

@end
