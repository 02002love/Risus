//
//  FMDBManager.m
//  Risus
//
//  Created by JinWei on 15/8/25.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import "FMDBManager.h"
#import "NewModel.h"

static FMDBManager * manager = nil;
//static NSMutableArray * dataArray;
@interface FMDBManager()
//@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)BOOL  isCollect;

@end

@implementation FMDBManager


+(instancetype)sharedFMDBManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =   [[FMDBManager alloc]init];
        
    });
    
    return manager;
    
}


-(instancetype)init{
    
    if (self = [super init]) {
//        dataArray= [NSMutableArray array];
        self.fm =[[FMDatabase alloc]initWithPath:[NSString stringWithFormat:@"%@/Documents/data.db",NSHomeDirectory()]];
        if ([self.fm open]) {
            BOOL isSucceed = [self.fm executeUpdate:@"create table favouriter (profile_image,name,create_time,desc,image0,height,width,love,hate,repost,comment,id,voiceuri,videouri,cellHeight)"];
            SKLog(@"%@",[NSString stringWithFormat:@"%@/Documents/data.db",NSHomeDirectory()]);
            if (isSucceed) {
                SKLog(@"建表成功");
            }
        }
    }
    return self;
    
}

-(NSMutableArray *)selectData{
    NSMutableArray * dataArray = [NSMutableArray array];
    FMResultSet * result = [self.fm executeQuery:@"select * from favouriter"];
    
    while([result next]) {
        NewModel * model = [[NewModel alloc]init];
        model.create_time =[result stringForColumn:@"create_time"];
        model.height=[result stringForColumn:@"height"];
        model.width=[result stringForColumn:@"width"];
        model.love=[result stringForColumn:@"love"];
        model.hate=[result stringForColumn:@"hate"];
        model.repost=[result stringForColumn:@"repost"];
        model.comment=[result stringForColumn:@"comment"];
        model.voiceuri=[result stringForColumn:@"voiceuri"];
        model.videouri=[result stringForColumn:@"videouri"];
        model.cellHeight=[[result stringForColumn:@"cellHeight"] floatValue];
        model._id = [result stringForColumn:@"id"];
        model.name = [result stringForColumn:@"name"];
        model.text = [result stringForColumn:@"desc"];
        model.profile_image = [result stringForColumn:@"profile_image"];
        model.image0 = [result stringForColumn:@"image0"];
        [dataArray addObject:model];
    }
    SKLog(@"长度:   %ld",dataArray.count);
    return dataArray;
}

-(BOOL)addData:(NewModel * )model{
    
    FMResultSet * result = [self.fm executeQuery:@"select id from favouriter"];
    while ([result next]) {
        if ([model._id isEqualToString:[result stringForColumn:@"id"]]) {
            self.isCollect = YES;
        }
        
    }
    if (self.isCollect) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"您已收藏过" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        self.isCollect = NO;
        return NO;
    }
    BOOL isSucceed = [self.fm executeUpdate:@"insert into favouriter values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.profile_image,model.name,model.create_time,model.text, model.image0,model.height,model.width,model.love,model.hate,model.repost,model.comment,model._id,model.voiceuri,model.videouri,[NSString stringWithFormat:@"%f",model.cellHeight]];
    if (isSucceed) {
        SKLog(@"插入成功");
        
    }else{
        SKLog(@"插入失败");
        
    }
    return YES;
    
}

-(BOOL)deleteData:(NewModel * )model{
    
    BOOL isSucceed = [self.fm executeUpdate:@"delete from favouriter where id = ?",model._id];
    if (isSucceed) {
        SKLog(@"删除成功");
    }else{
        SKLog(@"删除失败");
    }
    return isSucceed;
}

@end
