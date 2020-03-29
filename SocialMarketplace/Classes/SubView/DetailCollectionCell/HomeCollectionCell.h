//
//  HomeCollectionCell.h
//  PhotoAlbum
//
//  Created by Hicom on 10/13/14.
//  Copyright (c) 2014 HiComSOLUTION. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HomeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *smallImg;

@property int index;
-(void)updateCell;
@end
