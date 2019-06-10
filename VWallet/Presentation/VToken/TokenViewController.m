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
#import "ApiServer.h"
#import "ServerConfig.h"

#import "WalletMgr.h"
#import "Token.h"
#import "TokenMgr.h"

#import "NSString+Decimal.h"
#import "NSString+Asterisk.h"
#import "UIScrollView+EmptyData.h"
#import "UIViewController+NavigationBar.h"
#import "UIScrollView+EmptyData.h"

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
    NSDecimalNumber *availabelDecimal= [[NSDecimalNumber alloc] initWithLongLong:self.account.availableBalance];
    NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLong:VsysVSYS];
    NSString *availabelBalanceStr = [NSString stringWithDecimal:[availabelDecimal decimalNumberByDividingBy:unityDecimal] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    self.balanceLabel.text = availabelBalanceStr;
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray<Token*> *list = [TokenMgr.shareInstance loadAddressWatchToken:self.account.originAccount.address];
    self.tokenList = list.copy;
    if(self.tokenList.count == 0) {
        [self.tableView ed_setupEmptyDataDisplay];
    }
    [self.tableView reloadData];
    [self refreshTokenListInfo];
    [self getAccountInfo];
}

- (void)getAccountInfo {
    __weak typeof(self) weakSelf = self;
    [ApiServer addressBalanceDetail:self.account callback:^(BOOL isSuc, Account * _Nonnull account) {
        if (isSuc && account) {
            NSString *availabelBalanceStr = [NSString stringWithDecimal:[NSString getAccurateDouble:account.availableBalance unity:VsysVSYS] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
            weakSelf.balanceLabel.text = availabelBalanceStr;
        }
    }];
}

- (void)refreshTokenListInfo {
    __weak typeof (self) weakSelf = self;
    for (Token *one in self.tokenList) {
        [ApiServer getTokenInfo:one.tokenId callback:^(BOOL isSuc, Token * _Nonnull token) {
            if (isSuc) {
                Token *weakToken = token;
                [ApiServer getAddressTokenBalance:weakSelf.account.originAccount.address tokenId:one.tokenId callback:^(BOOL isSuc, Token * _Nonnull token) {
                    NSInteger i = [weakSelf.tokenList indexOfObject:one];
                    weakSelf.tokenList[i].balance = token.balance;
                    weakSelf.tokenList[i].total = weakToken.total;
                    [weakSelf.tableView reloadData];
                    [TokenMgr.shareInstance saveToStorage:weakSelf.account.originAccount.address list:weakSelf.tokenList];
                }];
            }
        }];
    }
    for (Token *one in self.tokenList) {
        [ApiServer getTokenDetailFromExplorer:one.tokenId callback:^(BOOL isSuc, Token * _Nonnull tokenDetail) {
            if (isSuc) {
                NSInteger i = [weakSelf.tokenList indexOfObject:one];
                weakSelf.tokenList[i].name = tokenDetail.name;
                weakSelf.tokenList[i].icon = tokenDetail.icon;
                [weakSelf.tableView reloadData];
                [TokenMgr.shareInstance saveToStorage:weakSelf.account.originAccount.address list:weakSelf.tokenList];
            }
        }];
    }
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
    [self actionSheetWithTitle:self.tokenList[indexPath.row].name message:nil withActionDatas:@[VLocalize(@"token.send.token"), VLocalize(@"token.info"), VLocalize(@"token.issue.token"), VLocalize(@"token.burn.token"), VLocalize(@"token.remove.token")] handler:^(NSInteger index) {
        if (index == 0) {
            TransactionOperateViewController *vc = [[TransactionOperateViewController alloc] initWithAccount:weakSelf.account token:self.tokenList[indexPath.row] operateType:TransactionOperateTypeSendToken];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 1) {
            TokenInfoViewController *vc = [[TokenInfoViewController alloc] initWithAccount:self.account token:self.tokenList[indexPath.row]];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 2) {
            TokenOperateViewController *vc = [[TokenOperateViewController alloc] initWithAccount:weakSelf.account type:TokenOperatePageTypeIssue token:self.tokenList[indexPath.row]];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (index == 3) {
            for(Account *one in WalletMgr.shareInstance.accounts) {
                if ([self.tokenList[indexPath.row].issuer isEqualToString:one.originAccount.address]) {
                    TokenOperateViewController *vc = [[TokenOperateViewController alloc] initWithAccount:weakSelf.account type:TokenOperatePageTypeBurn token:self.tokenList[indexPath.row]];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    return;
                }
            }
            [weakSelf remindWithMessage:VLocalize(@"error.contract.operate.permission.not.issuer")];
        }else if (index == 4) {
            NSArray<Token *> *list = [TokenMgr.shareInstance loadAddressWatchToken:weakSelf.account.originAccount.address];
            NSMutableArray *newList = [[NSMutableArray alloc] init];
            for (Token *one in list) {
                if ([one.tokenId isEqualToString:weakSelf.tokenList[indexPath.row].tokenId]) {
                    continue;
                }
                [newList addObject:one];
            }
            NSError *error = [TokenMgr.shareInstance saveToStorage:weakSelf.account.originAccount.address list:newList];
            if (error != nil) {
                [weakSelf alertWithTitle:[error localizedDescription] confirmText:VLocalize(@"close")];
                return;
            }
            weakSelf.tokenList = newList.copy;
            if (weakSelf.tokenList.count == 0) {
                [weakSelf.tableView ed_setupEmptyDataDisplay];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
@end
