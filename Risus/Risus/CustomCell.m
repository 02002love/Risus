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
#import "FMDBManager.h"
#import "UMengShareController.h"

@interface CustomCell ()<UIActionSheetDelegate>
{
    NSString * _url;             //视频音频的 URL
    NSString * itemId;      //顶踩的 URL 的 id
    AFHTTPRequestOperationManager * manager;
    NewModel * tempModel;
    UIImageView * tempImage;//为分享使用
    
}


@property (nonatomic)   UIView *headView;//head
@property (nonatomic)   UIImageView *iconImageView;//头像
@property (nonatomic)   UILabel *nameLabel;//昵称
@property (nonatomic)   UILabel *dateLabel;//时间
@property (nonatomic)   UIButton *exposerButton;//举报



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
    self.exposerButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 40, 10, 20, 20)];
    [self.exposerButton addTarget:self action:@selector(exposerBtnCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.exposerButton];
    
    
    self.myTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.myTextLabel];
    
    //配图
    self.pictureImageview = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.pictureImageview];
    
    
    //音频播放键
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = CGRectZero;
    [self.contentView addSubview:self.voiceButton];
    [self.voiceButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    self.voiceButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"playButtonClick"]];
    [self.voiceButton addTarget:self action:@selector(voiceAndVideoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //视频播放键
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.frame = CGRectZero;
    [self.contentView addSubview:self.videoButton];
    [self.videoButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    self.videoButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"playButtonClick"]];
    [self.videoButton addTarget:self action:@selector(voiceAndVideoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.footView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.footView];
    
    self.dingButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, (WIDTH-20)*0.25, 15)];
    self.dingButton.titleLabel.font = [UIFont systemFontOfSize:BTNFONTSIZE];
    [self.dingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    [self.footView addSubview:self.dingButton];
    [self.dingButton setImage:[UIImage imageNamed:@"mainCellDing"] forState:UIControlStateNormal];
    [self.dingButton addTarget:self action:@selector(dingAndCaiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.dingButton.tag = 1;
    
    self.caiButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + (WIDTH-20)*0.25, 5, (WIDTH-20)*0.25, 15)];
    [self.footView addSubview:self.caiButton];
    [self.caiButton setImage:[UIImage imageNamed:@"mainCellCai"] forState:UIControlStateNormal];
    self.caiButton.titleLabel.font = [UIFont systemFontOfSize:BTNFONTSIZE];
    [self.caiButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    [self.caiButton addTarget:self action:@selector(dingAndCaiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.caiButton.tag = 0;
    
    self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(10 +2*(WIDTH-20)*0.25 , 5, (WIDTH-20)*0.25, 15)];
    [self.footView addSubview:self.shareButton];
    [self.shareButton setImage:[UIImage imageNamed:@"mainCellShare"] forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:BTNFONTSIZE];
    self.shareButton.titleLabel.textColor = [UIColor grayColor];
    [self.shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    [self.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
#warning 待完成
    
    //    self.commentButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + 3*(WIDTH-20)*0.25 , 5, (WIDTH-20)*0.25, 15)];
    //    [self.footView addSubview:self.commentButton];
    //    [self.commentButton setImage:[UIImage imageNamed:@"mainCellComment"] forState:UIControlStateNormal];
    //    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:BTNFONTSIZE];
    //    self.commentButton.titleLabel.textColor = [UIColor grayColor];
    //    [self.commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    
}



-(void)configWithModel:(NewModel *)model{
    
    tempModel = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image]];
    self.nameLabel.text = model.name;
    self.nameLabel.textColor = [UIColor grayColor];
    self.nameLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.text = model.create_time;
    self.dateLabel.textColor = [UIColor grayColor];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    [self.exposerButton setImage:[UIImage imageNamed:@"Profile_reportIcon"] forState:UIControlStateNormal];
    
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
        self.voiceButton.frame = (CGRect){(WIDTH -10-63)*0.5,HEADHEIGHT + textHeight + pictureHeight*0.5 +SPACE,63,63};
        _url = model.voiceuri;
    }
    //播放视频
    if (![@"" isEqualToString:model.videouri]) {
        SKLog(@"------   %@    ------",model.videouri);
        self.videoButton.frame = (CGRect){(WIDTH -10-63)*0.5,HEADHEIGHT + textHeight + pictureHeight*0.5 +SPACE,63,63};
        _url = model.videouri;
    }
    //cell的脚
    self.footView.frame = CGRectMake(5, HEADHEIGHT + textHeight + pictureHeight +SPACE, WIDTH-20, FOOTHEIGHT);
    itemId = model._id;
    [self.dingButton setTitle:model.love forState:UIControlStateNormal];
    [self.caiButton setTitle:model.hate forState:UIControlStateNormal];
    
    [self.shareButton setTitle:model.repost forState:UIControlStateNormal];
    
#warning 待完成
    //    [self.commentButton setTitle:model.comment forState:UIControlStateNormal];
    
}

//顶,踩 按钮点击
-(void)dingAndCaiButtonClick:(UIButton *)button{
    
    if (button.tag == 1)
    {
        NSString * dingURL = [NSString stringWithFormat:DING,itemId];
        SKLog(@"--------%@",itemId);
        SKLog(@"~~~~%@",DING);
        [self dingAndCaiData:dingURL withFlag:button.tag];
    }
    else if(button.tag == 0)
    {
        NSString * caiURL = [NSString stringWithFormat:CAI,itemId];
        SKLog(@"--------%@",itemId);
        SKLog(@"~~~~%@",CAI);
        [self dingAndCaiData:caiURL withFlag:button.tag];
    }
    
}
//顶踩初始化数据
-(void)dingAndCaiData:(NSString *)url withFlag:(NSInteger)flag{
    //取消解析格式  只返回 NSData 类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    SKLog(@"~~~~%@",url);
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData * data = responseObject;
        NSString * countNum = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        SKLog(@"==========%@",countNum);
        if (flag ==1) {
            [self.dingButton setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateNormal];
            [self.dingButton setTitle:countNum forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"点赞成功"];
        }else if(flag ==0)
        {
            NSInteger tempNum = ([countNum integerValue] +2)/2;
            NSString * str = [NSString stringWithFormat:@"%ld",(long)tempNum];
            [self.caiButton setImage:[UIImage imageNamed:@"mainCellCaiClick"] forState:UIControlStateNormal];
            [self.caiButton setTitle:str  forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"点踩成功"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (flag==1) {
            [MBProgressHUD showError:@"点赞失败"];
            
        }else if(flag ==0){
            
            [MBProgressHUD showError:@"点踩失败"];
            
        }
    }];
    
    
}

//点击视频,声音播放按钮
-(void)voiceAndVideoButtonClick{
    
    SKLog(@"songjinwei");
    self.myBlock(_url);
    
}

//收藏,举报按钮
-(void)exposerBtnCilck:(UIButton *)btn{
    
    if ([self.isCollected isEqualToString:@"0"]) {
        
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate: self cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@"收藏",@"举报", nil];
        sheet.tag = 1;
        sheet.delegate = self;
        [sheet showInView:self];
        
    }else if ([self.isCollected isEqualToString:@"1"]){
        
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate: self cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@"取消收藏",@"举报", nil];
        sheet.tag = 0;
        sheet.delegate = self;
        [sheet showInView:self];
        
    }
    
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0){//收藏
        if (actionSheet.tag ==1) {//点击收藏
            
            if ([[FMDBManager sharedFMDBManager] addData:tempModel])
            {
                [MBProgressHUD showSuccess:@"收藏成功"];
            }else{
                [MBProgressHUD showError:@"收藏失败"];
                
            }
        } else if (actionSheet.tag ==0){//点击取消收藏
            
            if ([[FMDBManager sharedFMDBManager] deleteData:tempModel])
            {
                [MBProgressHUD showSuccess:@"取消收藏成功"];
                if ([self.delegate respondsToSelector:@selector(refreshData:)]) {
                    [self.delegate refreshData:self.index];
                }
                
            }else{
                [MBProgressHUD showError:@"取消收藏失败"];
                
            }
            
            
        }
    }
    else if(buttonIndex ==1){//举报
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:JUBAO,itemId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD showSuccess:@"举报成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"举报失败"];
        }];
        
        
    }
    
    
}
//分享按钮
-(void)shareButtonClicked:(UIButton *)btn{
    
    self.btnClick(tempModel);
    
}


@end
