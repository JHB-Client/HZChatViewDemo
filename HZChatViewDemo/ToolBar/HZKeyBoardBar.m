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
#import "HZKeyBoardMoreView.h"
NS_ASSUME_NONNULL_BEGIN
@interface HZKeyBoardBar () <UITextViewDelegate>
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, weak) UIButton *voiceBtn;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIButton *faceBtn;
@property (nonatomic, weak) UIButton *moreBtn;
@property (nonatomic, weak) HZKeyBoardMoreView *keyMoreView;
@property (nonatomic, copy) NSString *oldText;
@property (nonatomic, assign) CGFloat defaultH;
@property (nonatomic, assign) CGFloat btnBottmH;
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
    UIView *toolBar = [UIView new];
    toolBar.backgroundColor = [UIColor blueColor];
    [self addSubview:toolBar];
    self.toolBar = toolBar;
    
    //
    UIButton *voiceBtn = [UIButton new];
    voiceBtn.backgroundColor = [UIColor greenColor];
    [voiceBtn setTitle:@"🔊" forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(voice:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:voiceBtn];
    self.voiceBtn = voiceBtn;
    
    //
    UITextView *textView = [UITextView new];
    textView.font = [UIFont systemFontOfSize:textViewFontSize];
    textView.backgroundColor = [UIColor redColor];
    textView.delegate = self;
    textView.scrollEnabled = false;
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = true;
    [self.toolBar addSubview:textView];
    self.textView = textView;
    //
    UIButton *faceBtn = [UIButton new];
    faceBtn.backgroundColor = [UIColor greenColor];
    [faceBtn setTitle:@"😊" forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(face:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:faceBtn];
    self.faceBtn = faceBtn;
    //
    UIButton *moreBtn = [UIButton new];
    moreBtn.backgroundColor = [UIColor greenColor];
    [moreBtn setTitle:@"➕" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:moreBtn];
    self.moreBtn = moreBtn;
    
    //
   HZKeyBoardMoreView *keyMoreView = [HZKeyBoardMoreView new];
//   keyMoreView.delegate = self;
   keyMoreView.backgroundColor = [UIColor yellowColor];
   [self addSubview:keyMoreView];
   self.keyMoreView = keyMoreView;
}

- (void)setLayoutSubviews {
    self.toolBar.x = kP(0);
    self.toolBar.width = self.width;
    self.toolBar.y = kP(0);
    self.toolBar.height = kP(100);
    
    //
    CGFloat btnHeight = self.toolBar.height * 0.8;
    CGFloat marginX = (self.width * 0.5 - 3 * btnHeight) / 5.0;
    //
    self.voiceBtn.width = self.voiceBtn.height = btnHeight;
    self.voiceBtn.x = marginX;
    self.voiceBtn.y = self.toolBar.height - self.voiceBtn.height * 1.1;
    
    //
    self.textView.x = self.voiceBtn.right + marginX;
    self.textView.width = self.width * 0.5;
    self.textView.y = kP(10);
    self.textView.height = self.toolBar.height - 2 * self.textView.y;
    if (self.defaultH == 0) {
        self.defaultH = self.textView.height;
    }
    
    //
    self.faceBtn.width = self.faceBtn.height = btnHeight;
    self.faceBtn.x = self.textView.right + marginX;
    self.faceBtn.y = self.toolBar.height - self.faceBtn.height * 1.1;
    
    if (self.btnBottmH == 0) {
        self.btnBottmH = self.faceBtn.y;
    }
    //
    self.moreBtn.width = self.moreBtn.height = btnHeight;
    self.moreBtn.x = self.faceBtn.right + marginX;
    self.moreBtn.y = self.toolBar.height - self.moreBtn.height * 1.1;
    
    //
    self.keyMoreView.x = kP(0);
    self.keyMoreView.width = self.width;
    self.keyMoreView.y = self.toolBar.bottom;
    self.keyMoreView.height = kP(500);
}

- (void)operateKeyboardHeight {
    //监听键盘，键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
            self.y = HZScreenH - self.toolBar.height - keyboardHeight;
            if (self.delegate && [self.delegate respondsToSelector:@selector(popKeyboardView:)]) {
                [self.delegate popKeyboardView:keyboardHeight];
            }
        } completion:nil];
    }
    self.keyboardHeight = keyboardHeight;
}


#pragma mark ----------------- keybaordHide ------------------
- (void)keyboardWillHide:(NSNotification *)notification {
   
    if (self.moreBtnSelected == true) return;
    NSDictionary *keyboardInforDict = [notification userInfo];
    CGFloat duration = [keyboardInforDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger option = [keyboardInforDict[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //
    [UIView animateWithDuration:duration delay:0.f options:option animations:^{
        self.y = HZScreenH - self.toolBar.height;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(downKeyboardView)]) {
            [self.delegate downKeyboardView];
        }

    } completion:nil];
    self.keyboardHeight = 0;
}


#pragma mark ----------------- more ------------------
- (void)more:(UIButton *)sendBtn {
    [self toolBtnClick];
}


- (void)face:(UIButton *)faceBtn {
    [self toolBtnClick];
}


- (void)voice:(UIButton *)voiceBtn {
    [self toolBtnClick];
}


- (void)toolBtnClick {
    self.moreBtnSelected = true;
    if (self.textView.isFirstResponder == true) { // 聚焦
        [self.textView resignFirstResponder];
        //down
        [UIView animateWithDuration:0.25 delay:0.f options:7 animations:^{
            self.y = HZScreenH - self.toolBar.height - kP(500);
            //2.
            if (self.delegate && [self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
                [self.delegate moreBtnClick:self.height];
            }
        } completion:nil];
        self.moreBtnSelected = false;
    } else { // 失焦
        
        if (self.y != HZScreenH - self.toolBar.height - kP(500)) {
            //1. up
           [UIView animateWithDuration:0.25 delay:0.f options:7 animations:^{
               self.y = HZScreenH - self.toolBar.height - kP(500);
               //2.
               if (self.delegate && [self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
                   [self.delegate moreBtnClick:self.height];
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
        
        //
       self.toolBar.height = textView.height + 2 * textView.y;
       self.height = kP(500) + self.toolBar.height;
       self.y = HZScreenH - self.toolBar.height - self.keyboardHeight;
       self.keyMoreView.y = self.toolBar.bottom;
       self.voiceBtn.y = self.toolBar.height - self.voiceBtn.height - self.btnBottmH;
       self.faceBtn.y = self.toolBar.height - self.faceBtn.height - self.btnBottmH;
       self.moreBtn.y = self.toolBar.height - self.moreBtn.height - self.btnBottmH;
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
            self.voiceBtn.y = self.height - self.voiceBtn.height - self.btnBottmH;
            self.faceBtn.y = self.height - self.faceBtn.height - self.btnBottmH;
            self.moreBtn.y = self.height - self.moreBtn.height - self.btnBottmH;
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
        //
        if (self.textView.text.length == 0) {
            self.toolBar.height = kP(100);
            self.height = kP(600);
            self.y = HZScreenH - self.toolBar.height;
            self.keyMoreView.y = self.toolBar.bottom;
        }
        
    } else {
        //
        [UIView animateWithDuration:0.25 delay:0.f options:7 animations:^{
            self.y = HZScreenH - self.toolBar.height;
            if (self.delegate && [self.delegate respondsToSelector:@selector(downKeyboardView)]) {
                [self.delegate downKeyboardView];
            }
        } completion:nil];
        self.keyboardHeight = 0;
    }
    
}
@end
