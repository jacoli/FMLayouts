//
//  FMFlowView.m
//  Fanmei
//
//  Created by 祝小夏 on 16/11/10.
//  Copyright © 2016年 Fanmei. All rights reserved.
//

#import "FMFlowView.h"
#import "UIView+FMLayoutsUtils.h"

@interface FMFlowView ()
@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *flowSubviews;
@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *flagViews;//记录最下面columns个视图

@property (nonatomic, strong) UIView *frontView;//当flowViewType为FMFlowViewSubviewsEqualWidthType时，标记上一个底部最低的视图
@property (nonatomic, assign) FMFlowViewType flowViewType;

@property (nonatomic, assign) NSInteger columns;
@end

@implementation FMFlowView

- (instancetype)initSubviewsEquelWidthTypeWithFrame:(CGRect)frame column:(NSInteger)columns {
    self = [super initWithFrame:frame];
    self.columns = MAX(columns, 1);
    self.flowViewType = FMFlowViewSubviewsEqualWidthType;
    return self;
}

- (instancetype)initSubviewsEqualHeightTypeWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.flowViewType = FMFlowViewSubviewsEqualHeightType;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initSubviewsEqualHeightTypeWithFrame:frame];
}

- (instancetype)init {
    return [self initSubviewsEqualHeightTypeWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initSubviewsEqualHeightTypeWithFrame:CGRectZero];
}

- (NSMutableArray<UIView *> *)flowSubviews {
    if (nil == _flowSubviews) {
        _flowSubviews = [[NSMutableArray alloc]init];
    }
    return _flowSubviews;
}

- (NSMutableArray<UIView *> *)flagViews {
    if (nil == _flagViews) {
        _flagViews = [[NSMutableArray alloc]init];
    }
    return _flagViews;
}

- (NSArray<UIView *> *)views {
    return self.flowSubviews;
}

- (void)addViews:(NSArray *)views {
    if (views.count > 0) {
        __weak __typeof(self) weakSelf = self;
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf addView:obj];
        }];
    }
    else {
        [self resetContentSize];
    }
}

- (void)removeAllViews {
    [self.flowSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.flowSubviews removeAllObjects];
    [self reloadView];
}

- (void)addView:(UIView *)view {
    if (view) {
        [self resetViewFrame:view];
        [self addSubview:view];
        [self.flowSubviews addObject:view];
        [self resetContentSize];
    }
}

- (void)removeView:(UIView *)view {
    if (view) {
        if ([self.flowSubviews containsObject:view]) {
            [view removeFromSuperview];
            [self.flowSubviews removeObject:view];
            [self reloadView];
        }
    }
}

- (void)reloadView {
    NSArray *views = [NSArray arrayWithArray:self.flowSubviews];
    [self.flowSubviews removeAllObjects];
    [self addViews:views];
}

- (void)resetViewFrame:(UIView *)view {
    if (view) {
        if (self.flowViewType == FMFlowViewSubviewsEqualHeightType) {
            [self setEqualHeightTypeViewFrame:view];
        }
        else if (self.flowViewType == FMFlowViewSubviewsEqualWidthType) {
            [self setEqualWidthTypeViewFrame:view];
        }
    }
}

- (void)setEqualWidthTypeViewFrame:(UIView *)view {
    CGRect rect = view.frame;
    CGFloat viewWidth = (self.fm_width - (self.layoutInset.left + self.layoutInset.right) - (self.columns - 1) * self.layoutSpace) / self.columns;
    CGFloat viewHeight = view.fm_width > 0 ? viewWidth * (view.fm_height / view.fm_width) : 0;
    rect.size.width = viewWidth;
    rect.size.height = viewHeight;
    
    if (self.flowSubviews.count == 0) {
        rect.origin.x = self.layoutInset.left;
        rect.origin.y = self.layoutInset.top;
    }
    else if (self.flowSubviews.count < self.columns) {
        rect.origin.x = self.flowSubviews.lastObject.fm_right + self.layoutSpace;
        rect.origin.y = self.flowSubviews.lastObject.fm_top;
    }
    else {
        UIView *uppermorstView = [self getUppermostView];
        if (uppermorstView) {
            rect.origin.x = uppermorstView.fm_left;
            rect.origin.y = uppermorstView.fm_bottom + self.layoutSpace;
            [self.flagViews removeObject:uppermorstView];
        }
    }
    [self.flagViews addObject:view];
    view.frame = rect;
}

//最上面的视图
- (UIView *)getUppermostView {
    if (self.columns == 1) {
        return self.flowSubviews.lastObject;
    }
    UIView __block *view = nil;
    [self.flagViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (view == nil) {
            view = obj;
        }
        else if (view.fm_bottom > obj.fm_bottom){
            view = obj;
        }
    }];
    return view;
}

- (void)setEqualHeightTypeViewFrame:(UIView *)view {
    CGRect rect = view.frame;
    if (self.flowSubviews.count > 0) {
        if (view.fm_width > (self.fm_width - (self.flowSubviews.lastObject.fm_right + self.layoutInset.right + self.layoutSpace))) {
            rect.origin.x = self.layoutInset.left;
            rect.origin.y = self.flowSubviews.lastObject.fm_bottom + self.layoutSpace;
        }
        else {
            rect.origin.x = self.flowSubviews.lastObject.fm_right + self.layoutSpace;
            rect.origin.y = self.flowSubviews.lastObject.fm_top;
        }
    }
    else {
        rect.origin.x = self.layoutInset.left;
        rect.origin.y = self.layoutInset.top;
    }
    if (view.fm_width > (self.fm_width - self.layoutInset.left - self.layoutInset.right)) {
        rect.size.width = self.fm_width - self.layoutInset.left - self.layoutInset.right;
    }
    view.frame = rect;
}

- (void)resetContentSize {
    if (self.flowSubviews.count > 0) {
        CGFloat bottomY = self.flowSubviews.lastObject.fm_bottom + self.layoutInset.bottom;
        self.contentSize = CGSizeMake(self.fm_width, bottomY);
    }
    else {
        self.contentSize = CGSizeZero;
    }
}

@end
