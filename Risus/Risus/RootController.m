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
@property (nonatomic,assign) BOOL  isUpdate;
@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createNavi];
    [self createTableView];
    self.myTableView.backgroundColor = [UIColor grayColor];
    self.myTableView.separatorStyle = 0;
    
    //设置返回的按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.myTableView addLegendHeaderWithRefreshingBlock:^{
        if (!self.isUpdate) {
            self.page = 0;
            self.isUpdate =!self.isUpdate;
            //下拉刷新   清空以前的元素
            [self.dataArray removeAllObjects];
            [self loadData];
            
        }
    }];
    [self.myTableView addLegendFooterWithRefreshingBlock:^{
        if (!self.isUpdate) {
            self.page ++;
            self.isUpdate =!self.isUpdate;
            [self loadData];
        }
    }];
    
    
}

-(void)createNavi{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 27, 27);
    [leftBtn setImage:[UIImage imageNamed:@"tabbarSetup"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
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
    //    [self presentViewController:vc animated:YES completion:nil];
    
    
    
    
}
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(void)loadData{
    //
    self.manager = [AFHTTPRequestOperationManager manager];
    if (self.data ==nil) {//一次加载视频
        
        SKLog(@"视频:%@",[NSString stringWithFormat:self.urlStr,self.page]);
        [self.manager POST:[NSString stringWithFormat:self.urlStr,self.page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * array = responseObject[@"list"];
            //            [self.dataArray removeAllObjects];
            for (NSDictionary * dict  in  array) {
                NewModel * model = [NewModel modelWithDict:dict];
                
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
            self.isUpdate = NO;
            //停止刷新
            [self.myTableView.header endRefreshing];
            [self.myTableView.footer endRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络有问题,请检查您的网络" delegate: self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
            [self.myTableView.header endRefreshing];
            [self.myTableView.footer endRefreshing];
            
        }];
        
        
    }else{
        SKLog(@"图片,文字,声音 :%@",[NSString stringWithFormat:self.urlStr,self.data,self.page,self.type]);
        [self.manager POST:[NSString stringWithFormat:self.urlStr,self.data,self.page,self.type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * array = responseObject[@"list"];
            for (NSDictionary * dict  in  array) {
                NewModel * model = [NewModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
            self.isUpdate = NO;
            //停止刷新
            [self.myTableView.header endRefreshing];
            [self.myTableView.footer endRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络有问题,请检查您的网络" delegate: self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
            [self.myTableView.header endRefreshing];
            [self.myTableView.footer endRefreshing];
        }];
    }
    
    
}

#pragma mark  创建TableView
-(void)createTableView{
    
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource =self;
    [self.view addSubview:self.myTableView];
    
    
    
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
    NewModel * model = self.dataArray[indexPath.row];
    
    [cell configWithModel:model];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewModel * model = self.dataArray[indexPath.row];
    return  model.cellHeight + SPACE;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SKLog(@"%ld",(long)indexPath.row);
    NewModel * model = self.dataArray [indexPath.row];
    
    ShowPictureController * showPictureVC = [[ShowPictureController alloc]init];
    showPictureVC.hidesBottomBarWhenPushed = YES;
    showPictureVC.pictureName = model.image0;
    showPictureVC.pictureHeight = model.height;
    showPictureVC.pictureWidth = model.width;
    [self presentViewController:showPictureVC animated:YES completion:nil];
    
    

}
@end
