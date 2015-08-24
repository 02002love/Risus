//
//  JHModel.m
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import "NewModel.h"

@implementation NewModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self._id = dict[@"id"];
        
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
    
}


+ (instancetype)modelWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

-(CGFloat)cellHeight{
    
    
    if (!_cellHeight) {
        
        CGFloat  textHeight =[self.text boundingRectWithSize:CGSizeMake(WIDTH -20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:FONTSIZE]} context:nil].size.height;
        CGFloat pictureHeight = [self.height floatValue] > 400.0 ? 400.0 : self.height.floatValue;
        _cellHeight = HEADHEIGHT + textHeight +pictureHeight + FOOTHEIGHT ;
    }
    
    return _cellHeight;
    
}


@end
