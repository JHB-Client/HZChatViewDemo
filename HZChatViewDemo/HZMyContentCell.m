//
//  HZMyContentCell.m
//  HZChatViewDemo
//
//  Created by 季怀斌 on 2018/6/5.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import "HZMyContentCell.h"
#import "Masonry.h"
#define kP(px) (CGFloat)(px * CGRectGetWidth([[UIScreen mainScreen] bounds]) / ((UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) ? 1024 : 750))
NS_ASSUME_NONNULL_BEGIN
@interface HZMyContentCell ()
@property (nonatomic, weak) UILabel *myTextLabel;
@end
NS_ASSUME_NONNULL_END
@implementation HZMyContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    
    return self;
}

- (void)setUpSubViews {
    UILabel *myTextLabel = [UILabel new];
    myTextLabel.font = [UIFont systemFontOfSize:kP(40)];
    myTextLabel.numberOfLines = 0;
    myTextLabel.backgroundColor = [UIColor greenColor];
    myTextLabel.layer.cornerRadius = kP(10);
    myTextLabel.clipsToBounds = true;
    [self addSubview:myTextLabel];
    self.myTextLabel = myTextLabel;
    
    [self.myTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kP(40));
        make.width.mas_lessThanOrEqualTo(kP(400));
        //
        make.bottom.mas_equalTo(self).offset(-kP(40));
    }];
    
    [self.myTextLabel sizeToFit];
}

- (void)setContentText:(NSString *)contentText {
    self.myTextLabel.text = contentText;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    return cell;
}

@end
