//
//  MineController.m
//  Risus
//
//  Created by JinWei on 15/8/21.
//  Copyright (c) 2015年 SongJinWei. All rights reserved.
//

#import "MineController.h"
#import "AboutUsController.h"
#import "HelpController.h"
#import "PrivacyController.h"
#import "FMDBManager.h"
#import "CollectionController.h"
#import "ThanksController.h"
@interface MineController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _myTableView;
}
@property (nonatomic,strong)NSArray * dataArray;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    UIBarButtonItem * item = [[UIBarButtonItem alloc]init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    [self createTableView];
    
}
-(NSArray *)dataArray{
    
    if (!_dataArray) {
        NSString * version =  [NSString stringWithFormat:@"当前版本:%@",VERSION];
        _dataArray = @[version ,@"本地收藏",@"清除缓存",@"隐私政策",@"帮助支持",@"关于我们",@"特别鸣谢"];
        
    }
    return _dataArray;
    
}
#pragma mark  创建TableView
-(void)createTableView{
    
    _myTableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource =self;
    [self.view addSubview:_myTableView];
    
    
    
}
#pragma mark  tabelView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return   self.dataArray.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID =@"MineCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row ==0) {
        cell.accessoryType =0 ;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:{
            
        }
            break;
        case 1:{//我的收藏
            
            CollectionController * collectionVC = [[CollectionController alloc]init];
            collectionVC.dataArray =  [[FMDBManager sharedFMDBManager] selectData];;
            [self.navigationController pushViewController:collectionVC animated:YES];
            
            
        }
            break;
        case 2:{//清除缓存
            [MBProgressHUD showMessage:@"正在努力为您清除垃圾..."];
            //SDWebImage 的单例,清除缓存
            [[SDImageCache sharedImageCache] cleanDisk];
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"已为您成功扫除垃圾!"];
            });
            
            
        }
            break;
            
        case 3:{//隐私政策
            
            PrivacyController * privacyVC = [[PrivacyController alloc]init];
            [self.navigationController pushViewController:privacyVC animated:YES];
            
        }
            break;
            
        case 4:{//帮助
            
            HelpController * helpVC = [[HelpController alloc]init];
            [self.navigationController pushViewController:helpVC animated:YES];
            
        }
            break;
        case 5:{//关于我们
            
            AboutUsController * aboutVC = [[AboutUsController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
            break;
            
        case 6:{//特别鸣谢
             ThanksController * thanksVC = [[ThanksController alloc]init];
            [self.navigationController pushViewController:thanksVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
