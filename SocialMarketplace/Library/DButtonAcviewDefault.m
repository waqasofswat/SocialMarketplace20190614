//
//  DButtonAcviewDefault.m
//  SmartAdsEmerson
//
//  Created by Hicom on 8/3/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

#import "DButtonAcviewDefault.h"

@implementation DButtonAcviewDefault

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self customInit];
 
}
- (void)drawRect:(CGRect)rect {
    [self customInit];
}

- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit {
    if (!_colorText) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self setTitleColor:_colorText forState:UIControlStateNormal];
    }
    
    [self setTitle:self.titleLabel.text.uppercaseString forState:UIControlStateNormal];
    if (_fontSize) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:_fontSize]];
        NSLog(@"font size: %f", _fontSize);
    }else{
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    if (!_colorBg) {
        _colorBg = COLOR_BTN_SMALL;
    }
    [self setBackgroundImage:[self imageWithColor:_colorBg] forState:UIControlStateNormal];
    [self setBackgroundColor:_colorBg];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
