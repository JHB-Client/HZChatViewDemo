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
@property (nonatomic, weak) UIButton *moreBtn;
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
    textView.font = [UIFont systemFontOfSize:kP(36)];
    textView.backgroundColor = [UIColor redColor];
    textView.delegate = self;
    textView.scrollEnabled = false;
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = true;
    [self addSubview:textView];
    self.textView = textView;
    //
    UIButton *moreBtn = [UIButton new];
    moreBtn.backgroundColor = [UIColor greenColor];
    [moreBtn setTitle:@"➕" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    self.moreBtn = moreBtn;
}

- (void)setLayoutSubviews {
    self.textView.x = kP(10);
    self.textView.width = self.width * 0.8;
    self.textView.y = kP(10);
    self.textView.height = self.height - 2 * self.textView.y;
    //
    self.moreBtn.x = self.textView.right + kP(10);
    self.moreBtn.width = self.width - self.moreBtn.x - self.textView.x;
    self.moreBtn.height = kP(60);
    self.moreBtn.y = self.height - self.moreBtn.height - kP(10);
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(popKeyboardView:)]) {
                [self.delegate popKeyboardView:keyboardHeight];
            }
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(downKeyboardView)]) {
            [self.delegate downKeyboardView];
        }

    } completion:nil];
    self.keyboardHeight = 0;
}


#pragma mark ----------------- more ------------------
- (void)more:(UIButton *)sendBtn {
//    [self.textView resignFirstResponder];
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
    NSLog(@"----hhhhhh-----=====================:%d", (int)(textViewCurrentHeight / kP(36) - 1));
    int lineNumber = (int)(textViewCurrentHeight / kP(36) - 1);
    if (lineNumber <= 3) {
        textView.scrollEnabled = false;
        textView.height = textViewCurrentHeight;
        self.height = self.textView.height + kP(20);
        self.y = HZScreenH - self.keyboardHeight - self.height;
        self.moreBtn.y = self.height - self.moreBtn.height - kP(10);
    } else {
        textView.scrollEnabled = true;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(upKeyboardView:)]) {
        [self.delegate upKeyboardView:self.height];
    }

    
    self.oldText = textView.text;
}



- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        if (self.textView.text.length != 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(senMsg:)]) {
                [self.delegate senMsg:self.textView.text];
            }
            
            self.textView.text = @"";
            self.textView.scrollEnabled = false;
            self.textView.height =  [self heightForString:self.textView andWidth:self.textView.width];
            self.height = self.textView.height + kP(20);
            self.y = HZScreenH - self.keyboardHeight - self.height;
            self.moreBtn.y = self.height - self.moreBtn.height - kP(10);
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark ----------------- resignMyFirstResponder ------------------
- (void)resignMyFirstResponder {
    if (self.keyboardHeight == 0) return;
    [self.textView resignFirstResponder];
}
@end
