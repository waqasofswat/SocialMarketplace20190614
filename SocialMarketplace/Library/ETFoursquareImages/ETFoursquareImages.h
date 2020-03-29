//
//  ETFoursquareImages.h
//  ETFoursquareImagesDemo
//
//  Created by Eugene Trapeznikov on 11/21/13.
//  Copyright (c) 2013 Eugene Trapeznikov. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ETFoursquareImagesDelegate;
@interface ETFoursquareImages : UIView <UIScrollViewDelegate> {
    NSMutableArray *imagesArray;
    
    UIScrollView *imagesScrollView;
    
    int imagesHeight;
    int imagesScrollStart;
    float scrollingKoef;
    
    BOOL pageControlIsChangingPage;
}

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic) int pageControlHeight;

//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomView;

-(void)setImages:(NSArray*)_imagesArrayURL;

-(void)setImagesHeight:(int)_imagesHeight;

-(int)getCurrentImageIndex;

- (void)changePage:(UIPageControl *)pageControl;


@property (nonatomic, assign) id<ETFoursquareImagesDelegate> delegate;
@end

@protocol ETFoursquareImagesDelegate <NSObject>

-(void)changeToPageIndex:(NSInteger)index;

@end