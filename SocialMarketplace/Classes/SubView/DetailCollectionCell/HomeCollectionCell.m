//
//  HomeCollectionCell.m
//  PhotoAlbum
//
//  Created by Hicom on 10/13/14.
//  Copyright (c) 2014 HiComSOLUTION. All rights reserved.
//

#import "HomeCollectionCell.h"

@implementation HomeCollectionCell

- (void)awakeFromNib {
    // Initialization code
     _smallImg.contentMode = UIViewContentModeScaleAspectFill;
    _smallImg.clipsToBounds = YES;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HomeCollectionCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}
-(void)updateCell{


}
@end
