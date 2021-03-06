//
//  RootController.m
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import "RootController.h"
#import "NewModel.h"
#import "CustomCell.h"
#import "MineController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ShowPictureController.h"

@interface RootController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)AFHTTPRequestOperationManager  * manager;
//@property (nonatomic,assign) BOOL  isUpdate;
@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    [self loadData];
    [self createNavi];
    [self createTableView];
    self.myTableView.backgroundColor = [UIColor grayColor];
    self.myTableView.separatorStyle = 0;
    
    //设置返回的按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
 
    
}

-(void)createNavi{
    
    
    
#warning 待完成
    
    //用户
    //    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    leftBtn.frame = CGRectMake(0, 0, 27, 27);
    //    [leftBtn setImage:[UIImage imageNamed:@"tabbarSetup"] forState:UIControlStateNormal];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    //设置
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, WIDTH - 27, 27, 27);
    [rightBtn setImage:[UIImage imageNamed:@"mine-setting-iconN"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(setUpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
}

-(void)setUpButtonClick:(UIButton *)button{
    
    MineController * vc = [[MineController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)loadData{
    //
    if (self.dataArray==nil) {
        self.dataArray=[NSMutableArray array];
    }else{
        if (page==1) {
            self.dataArray=[NSMutableArray array];
        }
        
    }
    
    self.manager = [AFHTTPRequestOperationManager manager];
//    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    if (self.data ==nil) {//一次加载视频
    
        SKLog(@"视频:%@",[NSString stringWithFormat:self.urlStr,page]);
        [self.manager POST:[NSString stringWithFormat:self.urlStr,page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * array = responseObject[@"list"];
            for (NSDictionary * dict  in  array) {
                NewModel * model = [NewModel modelWithDict:dict];
                
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络有问题,请检查您的网络" delegate: self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
            
        }];
        
    }else{
        
        SKLog(@"图片,文字,声音 :%@",[NSString stringWithFormat:self.urlStr,self.data,page,self.type]);
        [self.manager POST:[NSString stringWithFormat:self.urlStr,self.data,page,self.type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * array = responseObject[@"list"];
            for (NSDictionary * dict  in  array) {
                NewModel * model = [NewModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络有问题,请检查您的网络" delegate: self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }];
        
    }
//    [UIView animateWithDuration:2.5 animations:^{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//    }];
    //停止刷新
    [self.myTableView.header endRefreshing];
    [self.myTableView.footer endRefreshing];
    isUpDate = NO;
    
}

#pragma mark  创建TableView
-(void)createTableView{
    
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource =self;
    [self.view addSubview:self.myTableView];
    
    
    //添加上拉下拉刷新
    [self.myTableView addLegendHeaderWithRefreshingBlock:^{
        if (!isUpDate) {
            isUpDate=!isUpDate;
            page=1;
            [self loadData];
        }
        
    }];
    [self.myTableView addLegendFooterWithRefreshingBlock:^{
        if (!isUpDate) {
            isUpDate=!isUpDate;
            page++;
            [self loadData];
        }
    }];
    
    
    
}
#pragma mark  tabelView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * ID =@"cellId";
    CustomCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.dataArray.count!= 0 ) {
        NewModel * model = self.dataArray[indexPath.row];
        [cell configWithModel:model];
        
    }
    
    
    cell.isCollected = @"0";//未收藏
    cell.myBlock = ^(NSString* url){
        
        MPMoviePlayerViewController * voiceViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
        voiceViewController.hidesBottomBarWhenPushed = YES;
        voiceViewController.title = @"正在播放";
        voiceViewController.view.frame =(CGRect){0,0,WIDTH,HEIGHT*0.5};
        //播放加载
        [voiceViewController.moviePlayer prepareToPlay];
        //播放
        [voiceViewController.moviePlayer play];
        [self.navigationController pushViewController:voiceViewController animated:YES];
        
    };
    
    cell.btnClick = ^(NewModel * model){
        
        UIImageView * temppicture = [[UIImageView alloc]init];
        [temppicture  sd_setImageWithURL:[NSURL URLWithString:model.image0]];
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGKEY shareText:model.text shareImage: temppicture.image shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToEmail] delegate:nil];
        
        
        
        
        
    };
    
    cell.imageClick= ^(NewModel * model){
        
        if (model.image0 ==nil) {
            if ([@"" isEqualToString:model.voiceuri] ||[@"" isEqualToString: model.videouri]) {
                return;
            }
        }
        ShowPictureController * showPictureVC = [[ShowPictureController alloc]init];
        showPictureVC.hidesBottomBarWhenPushed = YES;
        showPictureVC.pictureName = model.image0;
        showPictureVC.pictureHeight = model.height;
        showPictureVC.pictureWidth = model.width;
        [self presentViewController:showPictureVC animated:YES completion:nil];
        
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count != 0) {
        NewModel * model = self.dataArray[indexPath.row];
        return  model.cellHeight + SPACE;
    }
    return 0;
    
}

@end
