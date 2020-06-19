//
//  ViewController.m
//  twoHeader
//
//  Created by zwm on 2018/1/11.
//  Copyright © 2018年 enhance. All rights reserved.
//

#import "ViewController.h"
#import "TwoHeaderView.h"

#define kSectionTwo 3       // 一级里面几个二级，这里定死了，可以按实际数据而不同的
#define kSectionTwoCell 5   // 二级底下几个cell，这里定死了，可以按实际数据而不同的

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_tableView registerNib:[UINib nibWithNibName:@"TwoHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"hIdentifier"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;// 理论上是所有二级的数量
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果下一段是另一个一级开始，多一个cell
    // 多出来的cell应与一级头的高度一样，此处都假设为44因此没有调cell高度
    return ((int)section + 1) % kSectionTwo == 0 ? kSectionTwoCell + 1 : kSectionTwoCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // 设置假数据
    UILabel *lbl = [cell viewWithTag:7777];
    lbl.text = [NSString stringWithFormat:@"LabelLabelLabelLabel%ld", (long)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    static NSString *hIdentifier = @"hIdentifier";
    
    TwoHeaderView *backView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];

    // 每一级的第一个二级默认显示一级头，其他隐藏
    backView.oneView.hidden = ((int)section) % kSectionTwo == 0 ? FALSE : TRUE;
    backView.layer.zPosition = backView.oneView.hidden ? 0 : 1;

    // 设置假数据
    backView.oneLbl.text = [NSString stringWithFormat:@"自然科学%d", ((int)section) / kSectionTwo];
    backView.twoLbl.text = [NSString stringWithFormat:@"社会活动%d", ((int)section) % kSectionTwo];
    
    return backView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        // 下拉隐藏假一级头显示真一级头
        _headerLbl.text = @"自然科学0";
        _headerView.hidden = TRUE;
        TwoHeaderView *backView = (TwoHeaderView *)[_tableView headerViewForSection:0];
        backView.oneView.hidden = FALSE;
    } else  {
        NSArray *cellIndex = [_tableView indexPathsForVisibleRows];
        if (!cellIndex || cellIndex.count <= 0) {
            return;
        }
        NSIndexPath *indexPath = cellIndex[0];
        // 如果不是当前一级的最后一个二级，则显示假一级头
        _headerView.hidden = ((int)indexPath.section + 1) % kSectionTwo == 0 ? TRUE : FALSE;
        if (!_headerView.hidden) {
            _headerLbl.text = [NSString stringWithFormat:@"自然科学%d", ((int)indexPath.section) / kSectionTwo];
        }
        // 先集体恢复
        for (NSIndexPath *index in cellIndex) {
            TwoHeaderView *backView = (TwoHeaderView *)[_tableView headerViewForSection:index.section];
            backView.oneView.hidden = ((int)index.section) % kSectionTwo == 0 ? FALSE : TRUE;
        }
        // 如果是最后一个二级，显示二级的一级头，否则隐藏
        TwoHeaderView *backView = (TwoHeaderView *)[_tableView headerViewForSection:indexPath.section];
        backView.oneView.hidden = !_headerView.hidden;
    }
}

@end
