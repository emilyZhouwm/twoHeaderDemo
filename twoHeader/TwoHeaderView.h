//
//  TwoHeaderView.h
//  twoHeader
//
//  Created by zwm on 2018/1/15.
//  Copyright © 2018年 enhance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UILabel *oneLbl;
@property (weak, nonatomic) IBOutlet UILabel *twoLbl;

@end
