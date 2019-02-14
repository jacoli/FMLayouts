//
//  FMLinearLayout.m
//  PinkuMall
//
//  Created by 李传格 on 16/10/9.
//  Copyright © 2016年 PinkuMall. All rights reserved.
//

#import "FMLinearLayout.h"
#import <objc/runtime.h>
#import "UIView+FMLayoutsUtils.h"

@interface FMLinearLayout ()

@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *arrangedSubviews;

@end

@implementation FMLinearLayout

- (NSMutableArray *)arrangedSubviews {
    if (!_arrangedSubviews) {
        _arrangedSubviews = [[NSMutableArray alloc] init];
    }
    return _arrangedSubviews;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero axis:kFMLayoutAxisVertical mainAxisDistribution:FMLayoutDistributionWrapContent crossAxisAlignment:FMLayoutAlignmentCenter];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame axis:kFMLayoutAxisVertical mainAxisDistribution:FMLayoutDistributionWrapContent crossAxisAlignment:FMLayoutAlignmentCenter];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithFrame:CGRectZero axis:kFMLayoutAxisVertical mainAxisDistribution:FMLayoutDistributionWrapContent crossAxisAlignment:FMLayoutAlignmentCenter];
}

- (instancetype)initWithFrame:(CGRect)frame axis:(FMLayoutAxis)axis mainAxisDistribution:(FMLayoutDistribution)mainAxisDistribution crossAxisAlignment:(FMLayoutAlignment)crossAxisAlignment {
    if (self = [super initWithFrame:frame]) {
        self.fmLayout_axis = axis;
        self.fmLayout_distribution = mainAxisDistribution;
        self.fmLayout_alignment = crossAxisAlignment;
        self.fmLayout_spacingAroundWeight = 0.5;
    }
    return self;
}

- (instancetype)initWithVerticalAxisAndWidth:(CGFloat)width {
    return [self initWithFrame:CGRectMake(0, 0, width, 0) axis:kFMLayoutAxisVertical mainAxisDistribution:FMLayoutDistributionWrapContent crossAxisAlignment:FMLayoutAlignmentCenter];
}

- (instancetype)initWithHorizonalAxisAndHeight:(CGFloat)height {
    return [self initWithFrame:CGRectMake(0, 0, 0, height) axis:kFMLayoutAxisHorizonal mainAxisDistribution:FMLayoutDistributionWrapContent crossAxisAlignment:FMLayoutAlignmentCenter];
}

- (instancetype)initWithAxis:(FMLayoutAxis)axis contentMode:(FMLayoutDistribution)contentMode size:(CGSize)size {
    return [self initWithFrame:CGRectMake(0, 0, size.width, size.height) axis:axis mainAxisDistribution:contentMode crossAxisAlignment:FMLayoutAlignmentCenter];
}

- (void)setFrame:(CGRect)frame {
    BOOL isFrameChanged = !CGRectEqualToRect(self.frame, frame);
    [super setFrame:frame];
    
    if (isFrameChanged && self.fmLayout_distribution == FMLayoutDistributionFill) {
        [self distributeSubviewsInAxis];
    }
}

#pragma mark - resize

- (void)alignSubview:(UIView *)subview {
    if (subview) {
        CGFloat leadingSpacing = self.fmLayout_crossAxisLeadingSpacing;
        CGFloat trailingSpacing = self.fmLayout_crossAxisTrailingSpacing;
        
        if (self.fmLayout_axis == kFMLayoutAxisVertical) {
            if (self.fmLayout_alignment == FMLayoutAlignmentCenter) {
                subview.fm_centerX = (self.fm_width + leadingSpacing - trailingSpacing) / 2;
            } else if (self.fmLayout_alignment == FMLayoutAlignmentLeading) {
                subview.fm_x = leadingSpacing;
            } else if (self.fmLayout_alignment == FMLayoutAlignmentTrailing) {
                subview.fm_right = self.fm_width - trailingSpacing;
            } else if (self.fmLayout_alignment == FMLayoutAlignmentFill) {
                subview.fm_x = trailingSpacing;
                subview.fm_width = self.fm_width - leadingSpacing - trailingSpacing;
            }
        } else {
            if (self.fmLayout_alignment == FMLayoutAlignmentCenter) {
                subview.fm_centerY = (self.fm_height + leadingSpacing - trailingSpacing) / 2;
            } else if (self.fmLayout_alignment == FMLayoutAlignmentLeading) {
                subview.fm_y = leadingSpacing;
            } else if (self.fmLayout_alignment == FMLayoutAlignmentTrailing) {
                subview.fm_bottom = self.fm_height - trailingSpacing;
            } else if (self.fmLayout_alignment == FMLayoutAlignmentFill) {
                subview.fm_y = trailingSpacing;
                subview.fm_height = self.fm_height - leadingSpacing - trailingSpacing;
            }
        }
    }
}

#define SubviewSpacing(subview) (subview.layoutConfig.fm_spacing >= 0 ? subview.layoutConfig.fm_spacing : self.fmLayout_spacing)

- (void)distributeLatestAddedSubviewAlongAxis {
    if (self.arrangedSubviews.count <= 0) {
        return;
    }
    
    if (self.fmLayout_distribution != FMLayoutDistributionWrapContent) {
        return;
    }
    
    UIView *prevSubView = self.arrangedSubviews.count >= 2 ? self.arrangedSubviews[self.arrangedSubviews.count - 2] : nil;
    UIView *subview = self.arrangedSubviews.lastObject;
    
    if (subview) {
        if (self.fmLayout_axis == kFMLayoutAxisVertical) {
            if (prevSubView) {
                subview.fm_y = CGRectGetMaxY(prevSubView.frame) + SubviewSpacing(subview);
            } else {
                subview.fm_y = self.fmLayout_leadingSpacing;
            }
        } else {
            if (prevSubView) {
                subview.fm_x = CGRectGetMaxX(prevSubView.frame) + SubviewSpacing(subview);
            } else {
                subview.fm_x = self.fmLayout_leadingSpacing;
            }
        }
        
        [self alignSubview:subview];
    }
}

- (void)distributeSubviewsAlongVertiacalAxisWithLeadingSpacing:(CGFloat)leadingSpacing {
    __block CGFloat yOffset = leadingSpacing;
    [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            yOffset += SubviewSpacing(obj);
        }
        obj.fm_y = yOffset;
        [self alignSubview:obj];
        yOffset = CGRectGetMaxY(obj.frame);
    }];
}

- (void)distributeSubviewsAlongHorizonalAxisWithLeadingSpacing:(CGFloat)leadingSpacing {
    __block CGFloat xOffset = leadingSpacing;
    [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            xOffset += SubviewSpacing(obj);
        }
        obj.fm_x = xOffset;
        [self alignSubview:obj];
        xOffset = CGRectGetMaxX(obj.frame);
    }];
}

- (CGFloat)subviewsTotalWidthOrHeight {
    __block CGFloat totalWidthOrHeight = 0;
    if (self.fmLayout_axis == kFMLayoutAxisVertical) {
        [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            totalWidthOrHeight += obj.fm_height;
        }];
    } else if (self.fmLayout_axis == kFMLayoutAxisHorizonal) {
        [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            totalWidthOrHeight += obj.fm_width;
        }];
    }
    
    return totalWidthOrHeight;
}

- (void)distributeSubviewsInAxis {
    if (self.arrangedSubviews.count <= 0) {
        return;
    }
    
    BOOL verticalAxis = self.fmLayout_axis == kFMLayoutAxisVertical;
    
    if (self.fmLayout_distribution == FMLayoutDistributionWrapContent) {
        if (verticalAxis) {
            [self distributeSubviewsAlongVertiacalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing];
        } else {
            [self distributeSubviewsAlongHorizonalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing];
        }
    } else if (self.fmLayout_distribution == FMLayoutDistributionFill) {
        if (verticalAxis) {
            __block CGFloat subviewsTotalSizeToFill = CGRectGetHeight(self.frame) - self.fmLayout_leadingSpacing - self.fmLayout_trailingSpacing;
            [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > 0) {
                    subviewsTotalSizeToFill -= SubviewSpacing(obj);
                }
            }];
            
            CGFloat avgSizeToFill = subviewsTotalSizeToFill / self.arrangedSubviews.count;
            [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.fm_height = MAX(avgSizeToFill, 0);
            }];
            
            [self distributeSubviewsAlongVertiacalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing];
        } else {
            __block CGFloat subviewsTotalSizeToFill = CGRectGetWidth(self.frame) - self.fmLayout_leadingSpacing - self.fmLayout_trailingSpacing;
            [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > 0) {
                    subviewsTotalSizeToFill -= SubviewSpacing(obj);
                }
            }];
            
            CGFloat avgSizeToFill = subviewsTotalSizeToFill / self.arrangedSubviews.count;
            [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.fm_width = MAX(avgSizeToFill, 0);
            }];
            
            [self distributeSubviewsAlongHorizonalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing];
        }
    } else if (self.fmLayout_distribution == FMLayoutDistributionCenter) {
        if (verticalAxis) {
            __block CGFloat subviewsTotalSizeToFillIncludingSpacing = 0;
            [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > 0) {
                    subviewsTotalSizeToFillIncludingSpacing += SubviewSpacing(obj);
                }
                subviewsTotalSizeToFillIncludingSpacing += obj.fm_height;
            }];
            
            CGFloat margin = (self.fm_height - subviewsTotalSizeToFillIncludingSpacing) / 2;
            [self distributeSubviewsAlongVertiacalAxisWithLeadingSpacing:margin];
        } else {
            __block CGFloat subviewsTotalSizeToFillIncludingSpacing = 0;
            [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > 0) {
                    subviewsTotalSizeToFillIncludingSpacing += SubviewSpacing(obj);
                }
                subviewsTotalSizeToFillIncludingSpacing += obj.fm_width;
            }];
            
            CGFloat margin = (self.fm_width - subviewsTotalSizeToFillIncludingSpacing) / 2;
            [self distributeSubviewsAlongHorizonalAxisWithLeadingSpacing:margin];
        }
    } else if (self.fmLayout_distribution == FMLayoutDistributionLeading) {
        if (verticalAxis) {
            [self distributeSubviewsAlongVertiacalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing];
            
            [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.fm_bottom > self.fm_height) {
                    obj.hidden = YES;
                } else {
                    obj.hidden = NO;
                }
            }];
        } else {
            [self distributeSubviewsAlongHorizonalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing];
            
            [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.fm_right > self.fm_width) {
                    obj.hidden = YES;
                } else {
                    obj.hidden = NO;
                }
            }];
        }
    } else if (self.fmLayout_distribution == FMLayoutDistributionSpaceBetween) {
        if (verticalAxis) {
            CGFloat totalHeight = [self subviewsTotalWidthOrHeight];
            if (self.arrangedSubviews.count > 1) {
                self.fmLayout_spacing = (self.fm_height - totalHeight - self.fmLayout_leadingSpacing - self.fmLayout_trailingSpacing)
                / (self.arrangedSubviews.count - 1);
            }
            [self distributeSubviewsAlongVertiacalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing];
        } else {
            CGFloat totalWidth = [self subviewsTotalWidthOrHeight];
            if (self.arrangedSubviews.count > 1) {
                self.fmLayout_spacing = (self.fm_width - totalWidth - self.fmLayout_leadingSpacing - self.fmLayout_trailingSpacing)
                / (self.arrangedSubviews.count - 1);
            }
            [self distributeSubviewsAlongHorizonalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing];
        }
    } else if (self.fmLayout_distribution == FMLayoutDistributionSpaceAround) {
        if (verticalAxis) {
            CGFloat totalHeight = [self subviewsTotalWidthOrHeight];
            CGFloat count = (self.arrangedSubviews.count - 1) + self.fmLayout_spacingAroundWeight * 2;
            if (count > 0) {
                self.fmLayout_spacing = (self.fm_height - totalHeight - self.fmLayout_leadingSpacing - self.fmLayout_trailingSpacing) / count;
            }
            [self distributeSubviewsAlongVertiacalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing + self.fmLayout_spacing * self.fmLayout_spacingAroundWeight];
        } else {
            CGFloat totalWidth = [self subviewsTotalWidthOrHeight];
            CGFloat count = (self.arrangedSubviews.count - 1) + self.fmLayout_spacingAroundWeight * 2;
            if (count > 0) {
                self.fmLayout_spacing = (self.fm_width - totalWidth - self.fmLayout_leadingSpacing - self.fmLayout_trailingSpacing) / count;
            }
            [self distributeSubviewsAlongHorizonalAxisWithLeadingSpacing:self.fmLayout_leadingSpacing + self.fmLayout_spacing * self.fmLayout_spacingAroundWeight];
        }
    }
}

- (void)resizeSelfInAxisToFitSubviews {
    if (self.fmLayout_distribution != FMLayoutDistributionWrapContent) {
        return;
    }
    
    if (self.fmLayout_axis == kFMLayoutAxisVertical) {
        CGFloat height = self.arrangedSubviews.count > 0 ? (CGRectGetMaxY(self.arrangedSubviews.lastObject.frame) + self.fmLayout_trailingSpacing) : (self.fmLayout_leadingSpacing + self.fmLayout_trailingSpacing);
        
        if (height != self.fm_height) {
            self.fm_height = height;
        }
    }
    else {
        CGFloat width = self.arrangedSubviews.count > 0 ? (CGRectGetMaxX(self.arrangedSubviews.lastObject.frame) + self.fmLayout_trailingSpacing) : (self.fmLayout_leadingSpacing + self.fmLayout_trailingSpacing);
        
        if (width != self.fm_width) {
            self.fm_width = width;
        }
    }
}

#pragma mark - apis

- (void)addArrangedSubview:(UIView *)view {
    if (view) {
        [self addSubview:view];
        [self.arrangedSubviews addObject:view];
        
        // distribution and alignment
        if (self.fmLayout_distribution == FMLayoutDistributionWrapContent) {
            [self distributeLatestAddedSubviewAlongAxis];
            [self resizeSelfInAxisToFitSubviews];
        }
        else {
            [self distributeSubviewsInAxis];
        }
    }
}

- (void)addArrangedSubview:(UIView *)view subviewSpacing:(CGFloat)spacing {
    view.layoutConfig.fm_spacing = spacing;
    [self addArrangedSubview:view];
}

- (void)addArrangedSubviews:(NSArray *)subviews {
    if (subviews) {
        [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addArrangedSubview:obj];
        }];
    }
}

- (void)removeArrangedSubview:(UIView *)view {
    if (view) {
        [view removeFromSuperview];
        [self.arrangedSubviews removeObject:view];
        [self distributeSubviewsInAxis];
        if (self.fmLayout_distribution == FMLayoutDistributionWrapContent) {
            [self resizeSelfInAxisToFitSubviews];
        }
    }
}

- (void)replaceArrangedSubview:(UIView *)oldview withView:(UIView *)newView {
    if (oldview) {
        [oldview removeFromSuperview];
        [self.arrangedSubviews removeObject:oldview];
    }
    
    if (newView) {
        [self addSubview:newView];
        [self.arrangedSubviews addObject:newView];
    }
    
    // distribution and alignment
    if (self.fmLayout_distribution == FMLayoutDistributionWrapContent) {
        [self distributeSubviewsInAxis];
        [self resizeSelfInAxisToFitSubviews];
    } else {
        [self distributeSubviewsInAxis];
    }
}

- (void)removeAllArrangedSubviews {
    [self.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.arrangedSubviews removeAllObjects];
    [self distributeSubviewsInAxis];
    if (self.fmLayout_distribution == FMLayoutDistributionWrapContent) {
        [self resizeSelfInAxisToFitSubviews];
    }
}

- (NSArray<__kindof UIView *> *)fetchArrangedSubviews {
    return self.arrangedSubviews;
}

- (void)reLayout {
    [self distributeSubviewsInAxis];
    if (self.fmLayout_distribution == FMLayoutDistributionWrapContent) {
        [self resizeSelfInAxisToFitSubviews];
    }
}

@end

@implementation FMLayoutConfig

@end

@implementation UIView (FMLayouts_ItemView)

static int kLayoutConfig;
- (FMLayoutConfig *)layoutConfig {
    FMLayoutConfig *ret = objc_getAssociatedObject(self, &kLayoutConfig);
    if (!ret) {
        ret = [[FMLayoutConfig alloc] init];
        ret.fm_spacing = -1;
        objc_setAssociatedObject(self, &kLayoutConfig, ret, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return ret;
}

@end
