//
//  TokenViewController.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenViewController.h"
#import "TokenTableViewCell.h"
#import "TokenHeaderView.h"
#import "VStoryboard.h"
#import "TokenHeaderView.h"
#import "VColor.h"
#import "Account.h"
#import "Language.h"
#import "ApiServer.h"
#import "AddTokenViewController.h"
#import "TokenOperateViewController.h"
#import "TokenInfoViewController.h"
#import "UIViewController+Alert.h"
#import "TransactionOperateViewController.h"

#import "Token.h"

#import "NSString+Decimal.h"
#import "NSString+Asterisk.h"
#import "UIScrollView+EmptyData.h"
#import "UIViewController+NavigationBar.h"

static NSString *const CellIdentifier = @"TokenTableViewCell";

@interface TokenViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Account *account;
@property (weak, nonatomic) IBOutlet TokenHeaderView *tokenHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<Token *> *tokenList;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToken;
@property (weak, nonatomic) IBOutlet UIButton *createToken;
@property (weak, nonatomic) IBOutlet UILabel *tokenNoteLabel;
@end

@implementation TokenViewController

- (instancetype)initWithAccount:(Account *)account {
    if (self = [super init]) {
        self.account = account;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self.navigationItem setTitle:@"Token"];
    [self.addToken setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.createToken setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    self.tokenHeaderView.account = self.account;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = VColor.tableViewBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    NSString *availabelBalanceStr = [NSString stringWithDecimal:self.account.availableBalance * 1.0 / VsysVSYS maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    self.balanceLabel.text = availabelBalanceStr;
    
    Token *t1 = [[Token alloc] init];
    t1.name = @"FToken";
    t1.contractId = @"t1";
    t1.balance = 124.234;
    self.tokenList = @[t1, t1, t1];
    [self.tableView reloadData];
}

- (IBAction)ClickAdd:(id)sender {
    AddTokenViewController *vc = [[AddTokenViewController alloc] initWithAccount:self.account];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ClickCreate:(id)sender {
    TokenOperateViewController *vc = [[TokenOperateViewController alloc] initWithAccount:self.account];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tokenList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TokenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.token = self.tokenList[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 32)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 32)];
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    label.textColor = VColor.textSecondColor;
    label.text = VLocalize(@"account.detail.token.watchList");
    [view addSubview: label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    [self actionSheetWithTitle:self.tokenList[indexPath.row].name message:nil withActionDatas:@[VLocalize(@"token.send_token"), VLocalize(@"token.info"), VLocalize(@"token.issue_token"), VLocalize(@"token.burn_token"), VLocalize(@"token.remove_token")] handler:^(NSInteger index) {
        if (index == 0) {
            TransactionOperateViewController *vc = [[TransactionOperateViewController alloc] initWithAccount:self.account operateType:TransactionOperateTypeLease];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 1) {
            TokenInfoViewController *vc = [[TokenInfoViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 2) {
            TokenOperateViewController *vc = [[TokenOperateViewController alloc] initWithAccount:self.account type:TokenOperatePageTypeIssue];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 3) {
            TokenOperateViewController *vc = [[TokenOperateViewController alloc] initWithAccount:self.account type:TokenOperatePageTypeBurn];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 4) {
            
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
@end
