//
//  FMLinearLayout.h
//  PinkuMall
//
//  Created by 李传格 on 16/10/9.
//  Copyright © 2016年 PinkuMall. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Layout axis.
 */
typedef NS_ENUM(NSInteger, FMLayoutAxis) {
    kFMLayoutAxisVertical = 0,
    kFMLayoutAxisHorizonal
};

/*
 Layout arranged subviews along the main axis.
 */
typedef NS_ENUM(NSInteger, FMLayoutDistribution) {
    /*
     Adjust self size to fit subviews and spacings.
     */
    FMLayoutDistributionWrapContent = 0,
    
    /*
     Adjust arranged subviews size to fill layout size along main axis. 
     Note, if layout size not enough, arranged subviews size will seted to zero.
     */
    FMLayoutDistributionFill,
    
    /*
     Adjust `fmLayout_leadingSpacing` and `fmLayout_trailingSpacing`, arranged subviews alignment center along main axis.
     */
    FMLayoutDistributionCenter,
    
    /*
     Layout items along main axis from leading.
     */
    FMLayoutDistributionLeading,
    
    /*
     Adjust `fmLayout_spacing`, arranged subviews alignment between along main axis.
     
     ------------------------------------------------
     |   item1   |        |item2|        |   item3  |
     ------------------------------------------------
     
     */
    FMLayoutDistributionSpaceBetween,
    
    /*
     Adjust `fmLayout_leadingSpacing` and `fmLayout_trailingSpacing` and `fmLayout_spacing`, arranged subviews alignment between along main axis.
     
     --------------------------------------------------
     |  |    item1   |    |item2|     |    item3   |  |
     --------------------------------------------------
     
     */
    FMLayoutDistributionSpaceAround
};

/*
 Layout arranged subviews along the cross axis.
 */
typedef NS_ENUM(NSInteger, FMLayoutAlignment) {
    /*
     Arranged subviews alignment center along cross axis.
     */
    FMLayoutAlignmentCenter = 0,
    
    /*
     Arranged subviews alignment leading along cross axis.
     */
    FMLayoutAlignmentLeading,
    
    /*
     Arranged subviews alignment trailing along cross axis.
     */
    FMLayoutAlignmentTrailing,
    
    /*
     Arranged subviews alignment fill in cross axis.
     */
    FMLayoutAlignmentFill,
};

/*
 A simple linear layout, similar to UIStackView in iOS and LinearLayout in android.
 */
@interface FMLinearLayout : UIView

#pragma mark - initializers

- (instancetype)initWithFrame:(CGRect)frame axis:(FMLayoutAxis)axis mainAxisDistribution:(FMLayoutDistribution)mainAxisDistribution crossAxisAlignment:(FMLayoutAlignment)crossAxisAlignment;

- (instancetype)initWithVerticalAxisAndWidth:(CGFloat)width;
- (instancetype)initWithHorizonalAxisAndHeight:(CGFloat)height;
- (instancetype)initWithAxis:(FMLayoutAxis)axis contentMode:(FMLayoutDistribution)contentMode size:(CGSize)size;

#pragma mark - configs

@property (nonatomic, assign) FMLayoutAxis fmLayout_axis; // default is kFMLayoutAxisVertical
@property (nonatomic, assign) FMLayoutDistribution fmLayout_distribution; // default is FMLayoutDistributionWrapContent
@property (nonatomic, assign) FMLayoutAlignment fmLayout_alignment; // default is FMLayoutAlignmentCenter
@property (nonatomic, assign) CGFloat fmLayout_spacing; // default is 0

@property (nonatomic, assign) CGFloat fmLayout_spacingAroundWeight; // default is 0.5, 不为负数，fmLayout_distribution==FMLayoutDistributionSpaceAround 有效

#pragma mark - insets

@property (nonatomic, assign) CGFloat fmLayout_leadingSpacing; // default is 0
@property (nonatomic, assign) CGFloat fmLayout_trailingSpacing; // default is 0
@property (nonatomic, assign) CGFloat fmLayout_crossAxisLeadingSpacing;
@property (nonatomic, assign) CGFloat fmLayout_crossAxisTrailingSpacing;

#pragma mark - apis

/* Add a view to the end of the arrangedSubviews list, and call -addSubview: automatically.
 */
- (void)addArrangedSubview:(UIView *)view;
- (void)addArrangedSubview:(UIView *)view subviewSpacing:(CGFloat)spacing;
- (void)addArrangedSubviews:(NSArray *)subviews;

/* Removes a subview from the list of arranged subviews and send it -removeFromSuperview automatically.
 */
- (void)removeArrangedSubview:(UIView *)view;
- (void)removeAllArrangedSubviews;

- (void)replaceArrangedSubview:(UIView *)oldview withView:(UIView *)newView;

- (NSArray<__kindof UIView *> *)fetchArrangedSubviews;

- (void)reLayout;

@end

@interface FMLayoutConfig : NSObject

/* 
 Spacing between self and prev item, if set ignore `fmLayout_spacing` of layout.
 Should seted before `-[addArrangedSubview:]`
 Default is -1.
 Ignored if less than zero.
 */
@property (nonatomic, assign) CGFloat fm_spacing;

@end

@interface UIView (FMLayouts_ItemView)

@property (nonatomic, strong, readonly) FMLayoutConfig *layoutConfig;

@end


