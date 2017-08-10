//
//  FMFlowView.h
//  Fanmei
//
//  Created by 祝小夏 on 16/11/10.
//  Copyright © 2016年 Fanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FMFlowViewType) {
    FMFlowViewSubviewsEqualHeightType = 0,   //子视图等高不定宽排列
    FMFlowViewSubviewsEqualWidthType = 1, //子视图等宽不定高排列
    
};

@interface FMFlowView : UIScrollView

/**
 所有子视图
 */
@property (nonatomic, strong, readonly) NSArray<__kindof UIView *> *views;

/**
 子视图之间的间距
 */
@property (nonatomic, assign) CGFloat layoutSpace;

/**
 content padding
 */
@property (nonatomic, assign) UIEdgeInsets layoutInset;


/**
 初始化FMFlowViewSubviewsEqualWidthType类型的瀑布流
 
 @param frame frame
 @param columns 多少列
 @return 容器视图
 */
- (instancetype)initSubviewsEquelWidthTypeWithFrame:(CGRect)frame column:(NSInteger)columns;

/**
 初始化FMFlowViewSubviewsEqualHeightType类型的瀑布流
 
 @param frame frame
 @return 容器视图
 */
- (instancetype)initSubviewsEqualHeightTypeWithFrame:(CGRect)frame;

/**
 添加子视图
 
 @param views 子视图数组
 */
- (void)addViews:(NSArray *)views;

/**
 添加子视图
 
 @param view 子视图
 */
- (void)addView:(UIView *)view;

/**
 移除一个子视图
 
 @param view 子视图
 */
- (void)removeView:(UIView *)view;

/**
 移除所有的子视图
 */
- (void)removeAllViews;

@end
