//
//  CustomCell.h
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewModel.h"

@protocol reloadDataDelegate <NSObject>

@optional

-(void)refreshData:(CGFloat)index;

@end


@interface CustomCell : UITableViewCell
@property (nonatomic,copy)void (^myBlock)(NSString *);
@property (nonatomic,copy)void (^btuClick)(NSString *);
@property (nonatomic,copy)NSString * isCollected;
@property (nonatomic,weak)id<reloadDataDelegate> delegate;
@property (nonatomic,assign)CGFloat index;


-(void)configWithModel:(NewModel *)model;

@end
