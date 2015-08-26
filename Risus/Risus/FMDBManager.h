//
//  FMDBManager.h
//  Risus
//
//  Created by JinWei on 15/8/25.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewModel.h"

@interface FMDBManager : NSObject

@property (nonatomic,strong)FMDatabase * fm;

+(instancetype)sharedFMDBManager;

-(NSMutableArray *)selectData;

-(BOOL)addData:(NewModel *)model;

-(BOOL)deleteData:(NewModel * )model;

@end
