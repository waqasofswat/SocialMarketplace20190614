//
//  CustomLabelType1.m
//  SmartAds
//
//  Created by mac on 12/15/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import "CustomLabelType1.h"

@implementation CustomLabelType1

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

        [self customInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
           [self customInit];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self customInit];
}

- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit {
    //self.textColor = [UIColor redColor];
    //self.backgroundColor = [UIColor greenColor];
    
}


@end
