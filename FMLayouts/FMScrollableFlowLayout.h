//
//  FMScrollableFlowLayout.h
//  PinkuMall
//
//  Created by 祝小夏 on 16/11/10.
//  Copyright © 2016年 PinkuMall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMScrollableFlowLayout : UIScrollView

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
