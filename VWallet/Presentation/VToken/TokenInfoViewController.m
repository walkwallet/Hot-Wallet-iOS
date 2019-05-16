//
//  TokenInfoViewController.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenInfoViewController.h"
#import "TransactionDetailTableViewCell.h"
#import "UIViewController+Alert.h"
#import "Language.h"

static NSString *const CellIdentifier = @"TransactionDetailTableViewCell";

@interface TokenInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *showData;
@end

@implementation TokenInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.title = VLocalize(@"token.info");
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSMutableArray *showData = @[
                                 @{@"title":VLocalize(@"token.info.token_id"), @"value":@"ATxEgdoX5GhkzqLnJjbPps6WdGkViSMLbQV"},
                                 @{@"title":VLocalize(@"token.info.issuer"), @"value":@"ATxEgdoX5GhkzqLnJjbPps6WdGkViSMLbQV"},
                                 @{@"title":VLocalize(@"token.info.register_time"), @"value":@"18/04/2019 15:00:00"},
                                 @{@"title":VLocalize(@"token.info.total_token"), @"value":@"200,000,000"},
                                 @{@"title":VLocalize(@"token.info.issued_token"), @"value":@"10,000"},
                                 @{@"title":VLocalize(@"token.info.description"), @"value":@"Never optimize an image mobile again.Get started today!"},
                                 ];
    self.showData = showData.copy;
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.showInfo = self.showData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        UIPasteboard.generalPasteboard.string = self.showData[indexPath.row][@"value"];
        [self remindWithMessage:VLocalize(@"tip.copy.success")];
    }
}

@end
