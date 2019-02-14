//
//  FMScrollableLinearLayout.m
//  PinkuMall
//
//  Created by 李传格 on 16/10/9.
//  Copyright © 2016年 PinkuMall. All rights reserved.
//

#import "FMScrollableLinearLayout.h"

@interface FMScrollableLinearLayout ()

@property (nonatomic, strong) FMLinearLayout *layout;

@end

@implementation FMScrollableLinearLayout

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layout.frame = self.bounds;
    }
    return self;
}

- (FMLinearLayout *)layout {
    if (!_layout) {
        _layout = [[FMLinearLayout alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [self addSubview:_layout];
    }
    return _layout;
}

- (void)setFrame:(CGRect)frame {
    BOOL isFrameChanged = !CGRectEqualToRect(self.frame, frame);
    [super setFrame:frame];
    
    if (isFrameChanged) {
        self.layout.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [self.layout reLayout];
        self.contentSize = self.layout.frame.size;
    }
}

- (void)setFmLayout_axis:(FMLayoutAxis)fmLayout_axis {
    self.layout.fmLayout_axis = fmLayout_axis;
}

- (FMLayoutAxis)fmLayout_axis {
    return self.layout.fmLayout_axis;
}

- (void)setFmLayout_alignment:(FMLayoutAlignment)fmLayout_alignment {
    self.layout.fmLayout_alignment = fmLayout_alignment;
}

- (FMLayoutAlignment)fmLayout_alignment {
    return self.layout.fmLayout_alignment;
}

- (void)setFmLayout_spacing:(CGFloat)fmLayout_spacing {
    self.layout.fmLayout_spacing = fmLayout_spacing;
}

- (CGFloat)fmLayout_spacing {
    return self.layout.fmLayout_spacing;
}

- (void)setFmLayout_leadingSpacing:(CGFloat)fmLayout_leadingSpacing {
    self.layout.fmLayout_leadingSpacing = fmLayout_leadingSpacing;
}

- (CGFloat)fmLayout_leadingSpacing {
    return self.layout.fmLayout_leadingSpacing;
}

- (void)setFmLayout_trailingSpacing:(CGFloat)fmLayout_trailingSpacing {
    self.layout.fmLayout_trailingSpacing = fmLayout_trailingSpacing;
}

- (CGFloat)fmLayout_trailingSpacing {
    return self.layout.fmLayout_trailingSpacing;
}

- (void)addArrangedSubview:(UIView *)view {
    [self.layout addArrangedSubview:view];
    self.contentSize = self.layout.frame.size;
}

- (void)addArrangedSubview:(UIView *)view subviewSpacing:(CGFloat)spacing {
    [self.layout addArrangedSubview:view subviewSpacing:spacing];
    self.contentSize = self.layout.frame.size;
}

- (void)removeArrangedSubview:(UIView *)view {
    [self.layout removeArrangedSubview:view];
    self.contentSize = self.layout.frame.size;
}

- (void)addArrangedSubviews:(NSArray *)subviews {
    if (subviews) {
        [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addArrangedSubview:obj];
        }];
    }
}

- (void)removeAllArrangedSubviews {
    [self.layout removeAllArrangedSubviews];
    self.contentSize = self.layout.frame.size;
}

- (void)setArrangeSubviews:(NSArray<UIView *> *)subviews {
    CGPoint offset = self.contentOffset;
    CGSize oldContentSize = self.contentSize;
    [self removeAllArrangedSubviews];
    [self addArrangedSubviews:subviews];
    
    // adjust content offset
    self.contentOffset = offset;
}

- (NSArray<__kindof UIView *> *)fetchArrangedSubviews {
    return [self.layout fetchArrangedSubviews];
}

- (void)reLayout {
    [self.layout reLayout];
    self.contentSize = self.layout.frame.size;
}

@end
