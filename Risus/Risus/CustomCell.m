//
//  CustomCell.m
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#define BTNFONTSIZE 10
#import "CustomCell.h"
#import <MediaPlayer/MediaPlayer.h>
@interface CustomCell (){
    NSString * _url;             //视频音频的 URL
    NSString * _dingCaiUrlId;      //顶踩的 URL 的 id
    AFHTTPRequestOperationManager * manager;
    NSString * num;
}


@property (nonatomic)   UIView *headView;//head
@property (nonatomic)   UIImageView *iconImageView;//头像
@property (nonatomic)   UILabel *nameLabel;//昵称
@property (nonatomic)   UILabel *dateLabel;//时间
@property (nonatomic)   UIButton *jubaoButton;//举报



@property (nonatomic)   UILabel * myTextLabel;//文字
@property (nonatomic)   UIImageView * pictureImageview;//配图
@property (nonatomic)   UIImageView * diverH; //竖线


@property (nonatomic)   UIView * footView;//脚
@property (nonatomic)   UIButton * dingButton;//顶
@property (nonatomic)   UIButton * caiButton;//踩
@property (nonatomic)   UIButton * shareButton;//分享
@property (nonatomic)   UIButton * commentButton;//评论
@property (nonatomic)   UIButton * repeatVideoButton;



@property (nonatomic)   UILabel *playCountLabel;//播放次数

@property (nonatomic)   UIButton * voiceButton;//声音播放按钮
@property (nonatomic)   UIButton * videoButton;//视频播放按钮

@end

@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCustomCell];
         manager = [AFHTTPRequestOperationManager manager];
        
    }
    
    return self;
}

-(void)createCustomCell{
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, SPACE, WIDTH, HEADHEIGHT)];
    [self.contentView addSubview:self.headView];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    self.iconImageView.layer.cornerRadius = 15;
    self.iconImageView.layer.masksToBounds = YES;
    [self.headView addSubview:self.iconImageView];
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 10)];
    [self.headView addSubview:self.nameLabel];
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 18, 100, 10)];
    [self.headView addSubview:self.dateLabel];
    self.jubaoButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, 10, 20, 20)];
    [self.headView addSubview:self.jubaoButton];
    
    
    self.myTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.myTextLabel];
    
    
    self.pictureImageview = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.pictureImageview];
    //音频播放键
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = CGRectZero;
    [self.contentView addSubview:self.voiceButton];
    [self.voiceButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    self.voiceButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"playButtonClick"]];
    [self.voiceButton addTarget:self action:@selector(voiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //视频播放键
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.frame = CGRectZero;
    [self.contentView addSubview:self.videoButton];
    [self.videoButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    self.videoButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"playButtonClick"]];
    [self.videoButton addTarget:self action:@selector(videoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.footView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.footView];
    
    self.dingButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, (WIDTH-20)*0.25, 15)];
    self.dingButton.titleLabel.font = [UIFont systemFontOfSize:BTNFONTSIZE];
    [self.dingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    [self.footView addSubview:self.dingButton];
    [self.dingButton setImage:[UIImage imageNamed:@"mainCellDing"] forState:UIControlStateNormal];
    [self.dingButton addTarget:self action:@selector(dingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.caiButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + (WIDTH-20)*0.25, 5, (WIDTH-20)*0.25, 15)];
    [self.footView addSubview:self.caiButton];
    [self.caiButton setImage:[UIImage imageNamed:@"mainCellCai"] forState:UIControlStateNormal];
    self.caiButton.titleLabel.font = [UIFont systemFontOfSize:BTNFONTSIZE];
    [self.caiButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    
    
    self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(10 +2*(WIDTH-20)*0.25 , 5, (WIDTH-20)*0.25, 15)];
    [self.footView addSubview:self.shareButton];
    [self.shareButton setImage:[UIImage imageNamed:@"mainCellShare"] forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:BTNFONTSIZE];
    self.shareButton.titleLabel.textColor = [UIColor grayColor];
    [self.shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    
    
    self.commentButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + 3*(WIDTH-20)*0.25 , 5, (WIDTH-20)*0.25, 15)];
    [self.footView addSubview:self.commentButton];
    [self.commentButton setImage:[UIImage imageNamed:@"mainCellComment"] forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:BTNFONTSIZE];
    self.commentButton.titleLabel.textColor = [UIColor grayColor];
    [self.commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    
}


-(void)configWithModel:(NewModel *)model{
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image]];
    self.nameLabel.text = model.name;
    self.nameLabel.textColor = [UIColor grayColor];
    self.nameLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.text = model.create_time;
    self.dateLabel.textColor = [UIColor grayColor];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    [self.jubaoButton setImage:[UIImage imageNamed:@"Profile_reportIcon"] forState:UIControlStateNormal];
    
    self.myTextLabel.text = model.text;
    self.myTextLabel.numberOfLines = 0;
    self.myTextLabel.font =[UIFont systemFontOfSize:FONTSIZE];
    CGFloat  textHeight =[model.text boundingRectWithSize:CGSizeMake(WIDTH -20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:FONTSIZE]} context:nil].size.height;
    self.myTextLabel.frame = CGRectMake(5, HEADHEIGHT+SPACE, WIDTH-20, textHeight);
    //图片的填充方式
    self.pictureImageview.contentMode = 1;
    
    //生成 loading 图的二进制数据
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"Loading.gif" ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    //加载动图
    [self.pictureImageview sd_setImageWithURL:[NSURL URLWithString:model.image0] placeholderImage:[UIImage sd_animatedGIFWithData:imageData]];
    CGFloat pictureHeight = [model.height floatValue] > 400.0 ? 400.0 : model.height.floatValue;
    self.pictureImageview.frame = CGRectMake(5, HEADHEIGHT+textHeight +SPACE, WIDTH -10, pictureHeight);
    
    //播放声音
    if (![@"" isEqualToString:model.voiceuri]) {
        SKLog(@"------    %@    ======",model.voiceuri);
        self.voiceButton.frame = (CGRect){(WIDTH -10-63)*0.5,HEADHEIGHT + textHeight + pictureHeight*0.8 +SPACE,63,63};
        _url = model.voiceuri;
    }
    //播放视频
    if (![@"" isEqualToString:model.videouri]) {
        SKLog(@"------   %@    ------",model.videouri);
        self.videoButton.frame = (CGRect){(WIDTH -10-63)*0.5,HEADHEIGHT + textHeight + pictureHeight*0.8 +SPACE,63,63};
        _url = model.videouri;
    }
    //cell的脚
    self.footView.frame = CGRectMake(5, HEADHEIGHT + textHeight + pictureHeight +SPACE, WIDTH-20, FOOTHEIGHT);
    _dingCaiUrlId = model._id;
    [self.dingButton setTitle:model.love forState:UIControlStateNormal];
    [self.caiButton setTitle:model.hate forState:UIControlStateNormal];
    [self.shareButton setTitle:model.repost forState:UIControlStateNormal];
    [self.commentButton setTitle:model.comment forState:UIControlStateNormal];
    
}

//顶按钮点击
-(void)dingButtonClick:(UIButton *)button{
    
    
    NSString * dingURL = [NSString stringWithFormat:DING,_dingCaiUrlId];
    SKLog(@"%@",dingURL);
   
    [self DingData:dingURL];
    
     SKLog(@"===00000000000===");
}

-(void)DingData:(NSString *)url{
    
    [manager GET:@"http://api.budejie.com/api/api_open.php?a=love&appname=baisishequ&asid=5684E21E-F2C0-49D5-85CC-EA62CEA46A0B&c=post&client=iphone&device=iPhone%204&id=15268424&jbk=0&mac=&market=&openudid=c312254df2a5167ddcfcd5280e1559fe2906c040&tj_from=voice&udid=&ver=3.6.1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        num = responseObject;
        [self.dingButton setTitle:num forState:UIControlStateNormal];
        SKLog(@"===singgegege===");
        [MBProgressHUD showSuccess:@"点赞成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"点赞失败"];
    }];

    
}
//点击声音播放按钮
-(void)voiceButtonClick{
    SKLog(@"songjinwei");
    
    self.myBlock(_url);
    
}
//点击视频播放按钮
-(void)videoButtonClick{
    
    self.myBlock(_url);
    
}
@end
