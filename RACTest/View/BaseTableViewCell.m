//
//  BaseTableViewCell.m
//  RACTest
//
//  Created by mzl on 2020/2/13.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (BaseTableViewCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"BaseTableViewCellID";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
