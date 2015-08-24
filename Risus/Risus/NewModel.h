//
//  NewModel.h
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewModel : NSObject

@property (nonatomic,copy)NSString *profile_image;//头像
@property (nonatomic,copy)NSString *name;//姓名
@property (nonatomic,copy)NSString *create_time;//创建日期
@property (nonatomic,copy)NSString *text;//标题
@property (nonatomic,copy)NSString *image0; //图片
@property (nonatomic,copy)NSString *image1;
@property (nonatomic,copy)NSString *cdn_img;
@property (nonatomic,copy)NSString *height;//图片高度
@property (nonatomic,copy)NSString *is_gif;
@property (nonatomic,copy)NSString *gifFistFrame;

@property (nonatomic,copy)NSString *love;//顶
@property (nonatomic,copy)NSString *hate;//踩
@property (nonatomic,copy)NSString *repost;//转发
@property (nonatomic,copy)NSString *comment;//评论

@property (nonatomic)NSString *_id;
@property (nonatomic,copy)NSString *voiceuri;//音频地址
@property (nonatomic,copy)NSString *videouri;//视频地址

@property (nonatomic,copy)NSString *playCount;

@property (nonatomic,getter = isClicked) BOOL click;
@property (nonatomic,getter = isClicked1) BOOL click1;


@property (nonatomic,assign)CGFloat cellHeight;//cell 的高度


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
