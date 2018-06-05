//
//  UIView+Extension.h
//  SLFDA
//
//  Created by 季怀斌 on 2017/12/5.
//  Copyright © 2017年 huazhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
- (void)cornerSideType:(UIRectCorner)rectCorner withCornerRadius:(CGFloat)cornerRadius;
//
/**
 *  起点x坐标
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  起点y坐标
 */
@property (nonatomic, assign) CGFloat y;
/**
 *  中心点x坐标
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 *  中心点y坐标
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 *  宽度
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  高度
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  顶部
 */
@property (nonatomic, assign) CGFloat top;
/**
 *  底部
 */
@property (nonatomic, assign) CGFloat bottom;
/**
 *  左边
 */
@property (nonatomic, assign) CGFloat left;
/**
 *  右边
 */
@property (nonatomic, assign) CGFloat right;
/**
 *  size
 */
@property (nonatomic, assign) CGSize size;
/**
 *  起点坐标
 */
@property (nonatomic, assign) CGPoint origin;
@end
