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
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    HZKeyBoardInputView *keyView = [[HZKeyBoardInputView alloc] initWithFrame:CGRectMake(0, HZScreenH - 50, HZScreenW, 50)];
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
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark ----------------- keyViewDelegate ------------------
- (void)senMsg:(NSString *)text {
    [self.dataArr addObject:text];
    [self.tableView reloadData];
    
    if (self.dataArr.count * 80 > HZScreenH - self.keyView.keyboardHeight - 50) {
        NSLog(@"--------asdad-------");
        self.tableView.height = HZScreenH - self.keyView.keyboardHeight - 50;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
    }
}

//
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.shouldDownKeyView = false;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.tableView.contentOffset.y == HZScreenH - self.keyView.keyboardHeight - 50) return;
//    [self.keyView resignMyFirstResponder];
//    self.tableView.height = HZScreenH;
//}

#pragma mark ----------------- downKeyView ------------------
- (void)downKeyView:(UITapGestureRecognizer *)tap {
    NSLog(@"---------sdfsdfsd---------");
    [self.keyView resignMyFirstResponder];
    self.tableView.height = HZScreenH;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
