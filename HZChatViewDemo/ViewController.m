//
//  ViewController.m
//  HZChatViewDemo
//
//  Created by 季怀斌 on 2018/3/20.
//  Copyright © 2018年 huazhuo. All rights reserved.
//
#define HZScreenW [UIScreen mainScreen].bounds.size.width
#define HZScreenH [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "HZKeyBoardInputView.h"
#import "UIView+Extension.h"
#import "HZMyContentCell.h"
@interface ViewController () <UITableViewDataSource, UITableViewDelegate, HZKeyBoardInputViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) HZKeyBoardInputView *keyView;
@property (nonatomic, assign) BOOL shouldDownKeyView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    HZKeyBoardInputView *keyView = [[HZKeyBoardInputView alloc] initWithFrame:CGRectMake(0, HZScreenH - kP(100), HZScreenW, kP(100))];
    keyView.delegate = self;
    keyView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:keyView];
    self.keyView = keyView;
    
    self.dataArr = [NSMutableArray array];
    
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downKeyView:)];
    [self.tableView addGestureRecognizer:tap];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HZMyContentCell *cell = [HZMyContentCell cellWithTableView:tableView];
    cell.contentText = self.dataArr[indexPath.row];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kP(100);
}

#pragma mark ----------------- keyViewDelegate ------------------
- (void)senMsg:(NSString *)text {
    [self.dataArr addObject:text];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    self.tableView.height = HZScreenH - self.keyView.keyboardHeight - kP(100);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
}

- (void)popKeyboardView:(CGFloat)keyboardHeight {
    self.tableView.height = HZScreenH - keyboardHeight - kP(100);
    if (self.dataArr.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
}


- (void)upKeyboardView:(CGFloat)keyboardViewHeight {
    self.tableView.height = HZScreenH - keyboardViewHeight - self.keyView.keyboardHeight;
    if (self.dataArr.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
    
}

#pragma mark ----------------- downKeyView ------------------
- (void)downKeyView:(UITapGestureRecognizer *)tap {
    [self.keyView resignMyFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.height = HZScreenH - self.keyView.height;
        if (self.dataArr.count != 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
        }
    }];
    
    
}

- (void)downKeyboardView {
    self.tableView.height = HZScreenH - self.keyView.height;
    if (self.dataArr.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
