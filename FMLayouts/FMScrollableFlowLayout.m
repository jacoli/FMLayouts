//
//  FMScrollableFlowLayout.m
//  PinkuMall
//
//  Created by 祝小夏 on 16/11/10.
//  Copyright © 2016年 PinkuMall. All rights reserved.
//

#import "FMScrollableFlowLayout.h"
#import "UIView+FMLayoutsUtils.h"

@interface FMScrollableFlowLayout ()

@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *arrangedSubviews;

@end

@implementation FMScrollableFlowLayout

- (NSMutableArray<UIView *> *)arrangedSubviews {
    if (!_arrangedSubviews) {
        _arrangedSubviews = [[NSMutableArray alloc] init];
    }
    return _arrangedSubviews;
}

- (NSArray<UIView *> *)views {
    return [self.arrangedSubviews copy];
}

- (void)addViews:(NSArray *)views {
    for (UIView *v in views) {
        [self addView:v];
    }
}

- (void)removeAllViews {
    [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.arrangedSubviews removeAllObjects];
    [self relayout];
}

- (void)addView:(UIView *)view {
    if (view) {
        [self layoutAddedView:view];
        [self addSubview:view];
        [self.arrangedSubviews addObject:view];
        [self resetContentSize];
    }
}

- (void)removeView:(UIView *)view {
    if (view) {
        if ([self.arrangedSubviews containsObject:view]) {
            [view removeFromSuperview];
            [self.arrangedSubviews removeObject:view];
            [self relayout];
        }
    }
}

- (void)relayout {
    NSArray *oldSubViews = [self.arrangedSubviews copy];
    [self.arrangedSubviews removeAllObjects];
    [self addViews:oldSubViews];
}

- (void)layoutAddedView:(UIView *)view {
    CGRect rect = view.frame;
    if (self.arrangedSubviews.count > 0) {
        if (view.fm_width > (self.fm_width - (self.arrangedSubviews.lastObject.fm_right + self.layoutInset.right + self.layoutSpace))) { // new line
            rect.origin.x = self.layoutInset.left;
            rect.origin.y = self.arrangedSubviews.lastObject.fm_bottom + self.layoutSpace;
        } else { // same line
            rect.origin.x = self.arrangedSubviews.lastObject.fm_right + self.layoutSpace;
            rect.origin.y = self.arrangedSubviews.lastObject.fm_top;
        }
    } else { // first obj
        rect.origin.x = self.layoutInset.left;
        rect.origin.y = self.layoutInset.top;
    }
    
    if (view.fm_width > (self.fm_width - self.layoutInset.left - self.layoutInset.right)) { // restricted in width
        rect.size.width = self.fm_width - self.layoutInset.left - self.layoutInset.right;
    }
    
    view.frame = rect;
}

- (void)resetContentSize {
    if (self.arrangedSubviews.count > 0) {
        CGFloat bottomY = self.arrangedSubviews.lastObject.fm_bottom + self.layoutInset.bottom;
        self.contentSize = CGSizeMake(self.fm_width, bottomY);
    } else {
        self.contentSize = CGSizeZero;
    }
}

@end
