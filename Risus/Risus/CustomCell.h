//
//  CustomCell.h
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewModel.h"
@interface CustomCell : UITableViewCell
@property (nonatomic,copy)void (^myBlock)(NSString *);
@property (nonatomic,copy)void (^btuClick)(NSString *);


-(void)configWithModel:(NewModel *)model;

@end
