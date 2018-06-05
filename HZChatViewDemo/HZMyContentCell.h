//
//  HZMyContentCell.h
//  HZChatViewDemo
//
//  Created by 季怀斌 on 2018/6/5.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZMyContentCell : UITableViewCell
@property (nonatomic, copy) NSString *contentText;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
