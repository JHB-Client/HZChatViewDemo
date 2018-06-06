//
//  HZKeyBoardInputView.h
//  HZChatViewDemo
//
//  Created by 季怀斌 on 2018/6/5.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kP(px) (CGFloat)(px * CGRectGetWidth([[UIScreen mainScreen] bounds]) / ((UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) ? 1024 : 750))
@protocol HZKeyBoardInputViewDelegate <NSObject>
- (void)upKeyboardView:(CGFloat)keyboardViewHeight;
- (void)downKeyboardView;
- (void)popKeyboardView:(CGFloat)keyboardHeight;
- (void)senMsg:(NSString *)text;
@end

@interface HZKeyBoardInputView : UIView
@property (nonatomic, weak) id<HZKeyBoardInputViewDelegate>delegate;
@property (nonatomic, assign) CGFloat keyboardHeight;
- (void)resignMyFirstResponder;
@end
