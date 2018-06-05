//
//  HZKeyBoardInputView.h
//  HZChatViewDemo
//
//  Created by 季怀斌 on 2018/6/5.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HZKeyBoardInputViewDelegate <NSObject>
- (void)senMsg:(NSString *)text;
@end

@interface HZKeyBoardInputView : UIView
@property (nonatomic, weak) id<HZKeyBoardInputViewDelegate>delegate;
@property (nonatomic, assign) CGFloat keyboardHeight;
- (void)resignMyFirstResponder;
@end
