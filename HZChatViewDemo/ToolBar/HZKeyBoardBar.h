//
//  HZKeyBoardBar.h
//  HZChatViewDemo
//
//  Created by 季怀斌 on 2018/6/5.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kP(px) (CGFloat)(px * CGRectGetWidth([[UIScreen mainScreen] bounds]) / ((UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) ? 1024 : 750))
@protocol HZKeyBoardBarDelegate <NSObject>
- (void)upKeyboardView:(CGFloat)keyboardViewHeight;
- (void)downKeyboardView:(CGFloat)keyboardHeight;
- (void)popKeyboardView:(CGFloat)keyboardHeight;
- (void)senMsg:(NSString *)text;
- (void)moreBtnClick:(CGFloat)keyboardHeight;
@end

@interface HZKeyBoardBar : UIView
@property (nonatomic, weak) id<HZKeyBoardBarDelegate>delegate;
@property (nonatomic, assign) CGFloat keyboardHeight;
- (void)resignMyFirstResponder;
@end
