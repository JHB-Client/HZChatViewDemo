//
//  HZKeyBoardInputView.m
//  HZChatViewDemo
//
//  Created by 季怀斌 on 2018/6/5.
//  Copyright © 2018年 huazhuo. All rights reserved.

//
#define HZScreenW [UIScreen mainScreen].bounds.size.width
#define HZScreenH [UIScreen mainScreen].bounds.size.height
#import "HZKeyBoardInputView.h"
#import "UIView+Extension.h"
NS_ASSUME_NONNULL_BEGIN
@interface HZKeyBoardInputView () <UITextViewDelegate>
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIButton *sendBtn;
@property (nonatomic, copy) NSString *oldText;
@end
NS_ASSUME_NONNULL_END
@implementation HZKeyBoardInputView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviews];
        [self setLayoutSubviews];
        [self operateKeyboardHeight];
    }
    return self;
}

- (void)setUpSubviews {
    UITextView *textView = [UITextView new];
    textView.font = [UIFont systemFontOfSize:18];
    textView.backgroundColor = [UIColor redColor];
    textView.delegate = self;
    textView.scrollEnabled = false;
    [self addSubview:textView];
    self.textView = textView;
    //
    UIButton *sendBtn = [UIButton new];
    sendBtn.backgroundColor = [UIColor greenColor];
    [sendBtn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    self.sendBtn = sendBtn;
}

- (void)setLayoutSubviews {
    self.textView.x = 5;
    self.textView.width = self.width * 0.8;
    self.textView.y = 5;
    self.textView.height = self.height - 2 * self.textView.y;
    //
    self.sendBtn.x = self.textView.right + 5;
    self.sendBtn.width = self.width - self.sendBtn.x - self.textView.x;
    self.sendBtn.height = 30;
    self.sendBtn.y = self.height - self.sendBtn.height - 5;
}

- (void)operateKeyboardHeight {
    //监听键盘，键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWill:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark ----------------- keyboardwill ------------------
- (void)keyboardWill:(NSNotification *)notification {
    NSDictionary *keyboardInforDict= [notification userInfo];
    NSValue *value = [keyboardInforDict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat duration = [keyboardInforDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger option = [keyboardInforDict[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    //
    if (keyboardHeight != 0) {
        [UIView animateWithDuration:duration delay:0.f options:option animations:^{
            self.y = HZScreenH - self.height - keyboardHeight;
        } completion:nil];
    }
   
    self.keyboardHeight = keyboardHeight;
}

#pragma mark ----------------- keybaordHide ------------------
- (void)keybaordHide:(NSNotification *)notification {
    NSDictionary *keyboardInforDict = [notification userInfo];
    CGFloat duration = [keyboardInforDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger option = [keyboardInforDict[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //
    [UIView animateWithDuration:duration delay:0.f options:option animations:^{
        self.y = HZScreenH - self.height;
    } completion:nil];
    self.keyboardHeight = 0;
}


#pragma mark ----------------- send ------------------
- (void)send:(UIButton *)sendBtn {
//    [self.textView resignFirstResponder];
    if (self.textView.text.length == 0) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(senMsg:)]) {
        [self.delegate senMsg:self.textView.text];
    }
    
    self.textView.text = @"";
    self.textView.scrollEnabled = false;
    self.textView.height =  [self heightForString:self.textView andWidth:self.textView.width];
    self.height = self.textView.height + 10;
    self.y = HZScreenH - self.keyboardHeight - self.height;
    self.sendBtn.y = self.height - self.sendBtn.height - 5;
}

#pragma mark ----------------- removeNoti ------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ----------------- textViewDelegate ------------------
- (void)textViewDidChange:(UITextView *)textView {
    
    
    if ([self.oldText isEqualToString:textView.text]) return;
    
    CGFloat textViewCurrentHeight = [self heightForString:textView andWidth:textView.width];
    
    //
    NSLog(@"----hhhhhh-----=====================:%d", (int)(textViewCurrentHeight / 18 - 1));
    int lineNumber = (int)(textViewCurrentHeight / 18 - 1);
    if (lineNumber <= 3) {
        textView.scrollEnabled = false;
        textView.height = textViewCurrentHeight;
        self.height = self.textView.height + 10;
        self.y = HZScreenH - self.keyboardHeight - self.height;
        self.sendBtn.y = self.height - self.sendBtn.height - 5;
    } else {
        textView.scrollEnabled = true;
    }
    
    self.oldText = textView.text;
}

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

#pragma mark ----------------- resignMyFirstResponder ------------------
- (void)resignMyFirstResponder {
    if (self.keyboardHeight == 0) return;
    [self.textView resignFirstResponder];
}
@end
