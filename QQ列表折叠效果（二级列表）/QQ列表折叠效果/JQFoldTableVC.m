/**
        原理： 由数据控制UI展示。
     1，一级展示的为tableview的headerview(给headerview添加手势)
     2,在手势的点击事件中，更新数据的折叠状态，刷新即可。
*/

#import "JQFoldTableVC.h"
#import "CellModel.h"
#import "FoldModel.h"
#import "JQFoldHeaderFooterView.h"

@interface JQFoldTableVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sectionData;

@property (nonatomic, strong) UITableView *mainTableV;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger tapSection; //记录当前点击的section，用于willDisplayCell方法中cell出现时的动画。

@end

@implementation JQFoldTableVC

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static  NSString* const  UITableViewCellID = @"UITableViewCellID";
static  NSString* const  JQFoldHeaderFooterViewID = @"JQFoldHeaderFooterViewID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册系统cell
    [self.mainTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellID];
    //注册头部view
    [self.mainTableV registerNib:[UINib nibWithNibName:@"JQFoldHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:JQFoldHeaderFooterViewID];
    
}

//自定义一些假数据
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        
        
        for (int i = 0; i < 5; i++) {
            FoldModel *foldModel = [FoldModel new];
            foldModel.jq_title = [NSString stringWithFormat:@"第 i=%d 行",i];
            
            foldModel.isFold = YES;  //默认都是折叠状态
            
            NSMutableArray *cellModelsArray = [NSMutableArray array];
            
            if (i % 2 == 0) {
                //                continue;
                for (int j = 0; j<2; j++) {
                    
                    CellModel *cellModel = [CellModel new];
                    cellModel.jq_title = [NSString stringWithFormat:@"第 j=%d 行",j];
                    
                    [cellModelsArray addObject:cellModel];
                }
                
            }else{
                for (int j = 0; j<5; j++) {
                    
                    CellModel *cellModel = [CellModel new];
                    cellModel.jq_title = [NSString stringWithFormat:@"第 j=%d 行",j];
                    
                    [cellModelsArray addObject:cellModel];
                }
                
            }
            foldModel.modelsArray = cellModelsArray;
            
            [_dataArr addObject:foldModel];
        }
        
    }
    return _dataArr;
}

- (UITableView *)mainTableV
{
    if (!_mainTableV)
    {
        _mainTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
        _mainTableV.delegate = self;
        _mainTableV.dataSource = self;
        
        _mainTableV.showsVerticalScrollIndicator = NO;
        //        _mainTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _mainTableV.estimatedRowHeight = 100;
        _mainTableV.rowHeight = UITableViewAutomaticDimension;
        
        [self.view addSubview:_mainTableV];
    }
    return _mainTableV;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    FoldModel *model = self.dataArr[section];
    
    return model.isFold ? 0 : model.modelsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID];
    
    FoldModel *foldModel = self.dataArr[indexPath.section];
    CellModel *cellModel = foldModel.modelsArray[indexPath.row];
    
    cell.textLabel.text = cellModel.jq_title;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click---section:%zd,row:%zd---",indexPath.section,indexPath.row);

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JQFoldHeaderFooterView *headerView =(JQFoldHeaderFooterView *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:JQFoldHeaderFooterViewID];
    
    headerView.tag = section;
    headerView.contentView.backgroundColor = [UIColor redColor];
    
    
    FoldModel *foldModel = self.dataArr[section];
    headerView.model = foldModel;
    
    //点击头部view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jq_tapHeaderView:)];
    [headerView addGestureRecognizer:tap];
    
    return headerView;
}

-(void)jq_tapHeaderView:(UIGestureRecognizer *)tap
{
    JQFoldHeaderFooterView *headerView = (JQFoldHeaderFooterView *)tap.view;
    NSLog(@"test---%zd",headerView.tag);
    
    NSInteger section = headerView.tag;
    self.tapSection = section;  //记录当前点击的section，用于willDisplayCell方法中cell出现时的动画。
    
    FoldModel *foldModel = self.dataArr[section];
    
    //没有row的时候，不改变折叠状态
    if (foldModel.modelsArray.count==0) {
        return;
    }
    
    foldModel.isFold = !foldModel.isFold;
    
    
    [self.mainTableV reloadData];
    //虽然有折叠效果，但是headerView会闪一下。
    //    [self.mainTableV reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
//}

//-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
//    view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
//}

//给cell添加动画
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.tapSection == indexPath.section) {
        
        cell.transform = CGAffineTransformMakeScale(1, 0.1);
        
        [UIView animateWithDuration:0.5 animations:^{
            cell.transform = CGAffineTransformMakeScale(1, 1);
        }];
    
    }
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
