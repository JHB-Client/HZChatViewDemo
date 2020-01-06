//
//  HZKeyBoardMoreView.h
//  HZChatViewDemo
//
//  Created by admin on 2020/1/6.
//  Copyright © 2020 huazhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HZKeyBoardMoreViewDelegate <NSObject>
- (void)upKeyboardView:(CGFloat)keyboardViewHeight;
- (void)downKeyboardView;
- (void)popKeyboardView:(CGFloat)keyboardHeight;
- (void)senMsg:(NSString *)text;
@end
NS_ASSUME_NONNULL_BEGIN
@interface HZKeyBoardMoreView : UIView
@property (nonatomic, weak) id<HZKeyBoardMoreViewDelegate>delegate;
@property (nonatomic, assign) CGFloat keyboardHeight;
@end

NS_ASSUME_NONNULL_END
