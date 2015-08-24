//
//  RootController.h
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController


@property (nonatomic,strong)UITableView * myTableView;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)int type;
@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,copy)NSString *data;

@end
