//
//  FMGridLayout.h
//  pmall4ios
//
//  Created by 李传格 on 2018/10/17.
//  Copyright © 2018年 爆好货. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO
@interface FMGridLayout : UIScrollView

@property (nonatomic, assign) CGFloat fmLayout_spacing;
@property (nonatomic, assign) UIEdgeInsets fmLayout_insets;

- (void)addArrangedSubview:(UIView *)view;
- (void)addArrangedSubviews:(NSArray *)subviews;

- (void)removeArrangedSubview:(UIView *)view;
- (void)removeAllArrangedSubviews;

@end
