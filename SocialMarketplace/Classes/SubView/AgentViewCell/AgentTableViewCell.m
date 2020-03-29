//
//  AgentTableViewCell.m
//  Real Ads
//
//  Created by De Papier on 4/10/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

#import "AgentTableViewCell.h"

@implementation AgentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _contactBtn.backgroundColor = COLOR_PRIMARY_DEFAULT;
    _properBtn.backgroundColor = COLOR_PRIMARY_DEFAULT;
    [self layoutView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutView
{
    UIColor *color = [UIColor colorWithRed:0/255.00 green:116/255.00 blue:24/255.00 alpha:1.0];
   // [Util borderAndcornerImagewith:_Avatar.frame.size.height/2 andBorder:3.0 andColor:color withImage:_Avatar];
    [Util borderAndcornerImagewith:_company.frame.size.height/2 andBorder:1.0 andColor:color withImage:_company];
    [Util borderAndcornerButtonwith:5.0 andBorder:0.0 andColor:nil withButton:_properBtn];
    [Util borderAndcornerButtonwith:5.0 andBorder:0.0 andColor:nil withButton:_contactBtn];
    UIColor *color1 = [UIColor colorWithRed:114/255.00 green:114/255.00 blue:114/255.00 alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:14];
    self.nameViewText.font = font;
    self.nameViewText.textColor = color1;
    self.phoneViewText.font = font;
    self.phoneViewText.textColor = color1;
    self.addressViewText.font = font;
    self.addressViewText.textColor = color1;
    self.emailViewText.font = font;
    self.emailViewText.textColor = color1;
    self.skypeViewText.font = font;
    self.skypeViewText.textColor = color1;
    
    [[self.ViewCell layer]setCornerRadius:6];
}
@end
