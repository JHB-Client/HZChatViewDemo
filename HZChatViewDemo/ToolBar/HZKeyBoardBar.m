//
//  HZKeyBoardBar.m
//  HZChatViewDemo
//
//  Created by 季怀斌 on 2018/6/5.
//  Copyright © 2018年 huazhuo. All rights reserved.

//
#define HZScreenW [UIScreen mainScreen].bounds.size.width
#define HZScreenH [UIScreen mainScreen].bounds.size.height
#define textViewFontSize kP(40)
#import "HZKeyBoardBar.h"
#import "UIView+Extension.h"
NS_ASSUME_NONNULL_BEGIN
@interface HZKeyBoardBar () <UITextViewDelegate>
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIButton *moreBtn;
@property (nonatomic, copy) NSString *oldText;
@property (nonatomic, assign) CGFloat defaultH;
@property (nonatomic, assign) BOOL moreBtnSelected;
@end
NS_ASSUME_NONNULL_END
@implementation HZKeyBoardBar
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
    textView.font = [UIFont systemFontOfSize:textViewFontSize];
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
    if (self.defaultH == 0) {
        self.defaultH = self.textView.height;
    }
    //
    self.moreBtn.x = self.textView.right + kP(10);
    self.moreBtn.width = self.width - self.moreBtn.x - self.textView.x;
    self.moreBtn.height = kP(60);
    self.moreBtn.y = self.height - self.moreBtn.height - kP(10);
}

- (void)operateKeyboardHeight {
    //监听键盘，键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark ----------------- keyboardwill ------------------
- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (self.moreBtnSelected == true) return;
    
    NSDictionary *keyboardInforDict= [notification userInfo];
    NSValue *value = [keyboardInforDict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat duration = [keyboardInforDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger option = [keyboardInforDict[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    NSLog(@"-----sssssss----:%lu", option);
    
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
   
    if (self.moreBtnSelected == true) return;
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
    
    self.moreBtnSelected = true;
    if (self.textView.isFirstResponder == true) { // 聚焦
        [self.textView resignFirstResponder];
        //down
        [UIView animateWithDuration:0.25 delay:0.f options:7 animations:^{
            self.y = HZScreenH - self.height - kP(400);
            //2.
            if (self.delegate && [self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
                [self.delegate moreBtnClick:self.moreBtn];
            }
        } completion:nil];
        self.moreBtnSelected = false;
    } else { // 失焦
        
        if (self.y != HZScreenH - self.height - kP(400)) {
            //1. up
           [UIView animateWithDuration:0.25 delay:0.f options:7 animations:^{
               self.y = HZScreenH - self.height - kP(400);
               //2.
               if (self.delegate && [self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
                   [self.delegate moreBtnClick:self.moreBtn];
               }
           } completion:nil];
            self.moreBtnSelected = false;
        } else {
            self.moreBtnSelected = false;
            [self.textView becomeFirstResponder];
        }
        
       
    }
    
}

#pragma mark ----------------- removeNoti ------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ----------------- textViewDelegate ------------------
- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self.oldText isEqualToString:textView.text]) return;
    
    NSLog(@"---1---:%lf", textView.height);
    CGFloat textViewCurrentHeight = [self heightForString:textView andWidth:textView.width];
    
    NSLog(@"---1---:%lf", textViewCurrentHeight);
    NSLog(@"----hhhhhh-----=====================:%d", (int)(textViewCurrentHeight / textViewFontSize - 1));
    int lineNumber = (int)(textViewCurrentHeight / textViewFontSize - 1);
    if (lineNumber <= 3) {
        textView.scrollEnabled = false;
       if(lineNumber == 1){
           textView.height = self.defaultH;
       } else {
           textView.height = textViewCurrentHeight;
       }
       self.height = textView.height + kP(20);
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
//    if (self.keyboardHeight == 0) return;
    self.moreBtnSelected = false;
    if (self.textView.isFirstResponder == true) {
        [self.textView resignFirstResponder];
    } else {
        //
        [UIView animateWithDuration:0.25 delay:0.f options:7 animations:^{
            self.y = HZScreenH - self.height;
            if (self.delegate && [self.delegate respondsToSelector:@selector(downKeyboardView)]) {
                [self.delegate downKeyboardView];
            }
        } completion:nil];
        self.keyboardHeight = 0;
    }
    
}
@end
