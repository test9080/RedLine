//
//  TUMineController.m
//  RedLine
//
//  Created by chengxianghe on 16/3/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUMineController.h"
#import "TUMineCell.h"

#define kMineCell   @"TUMineCell"

@interface TUMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *imageArray;

@property (weak, nonatomic) IBOutlet UITableView *mineTable;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@end

@implementation TUMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initArray];
    
    [self initTable];
}

- (void)initArray {
    self.titleArray = [[NSArray alloc] initWithObjects:
                            [NSArray arrayWithObjects:@"积分", nil],
                            [NSArray arrayWithObjects:@"设置", @"意见反馈", @"关于红线", @"给红线好评", nil],
                            nil];
    
    self.imageArray = [[NSArray alloc] initWithObjects:
                            [NSArray arrayWithObjects:@"mine_1", nil],
                            [NSArray arrayWithObjects:@"mine_2", @"mine_3", @"mine_4", @"mine_5", nil],
                            nil];
}

- (void)initTable {
    self.mineTable.tableHeaderView = self.headerView;
    [self.mineTable registerNib:[UINib nibWithNibName:kMineCell bundle:nil] forCellReuseIdentifier:kMineCell];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    TUMineCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineCell forIndexPath:indexPath];
    [cell setInfo:[[self.titleArray objectAtIndex:section] objectAtIndex:row] image:[[self.imageArray objectAtIndex:section] objectAtIndex:row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
