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
#import "TokenMgr.h"
#import "Token.h"
#import "Account.h"
#import "Contract.h"
#import "ApiServer.h"
#import "NSString+Decimal.h"

static NSString *const CellIdentifier = @"TransactionDetailTableViewCell";

@interface TokenInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *showData;
@property (nonatomic, strong) Token *token;
@property (nonatomic, strong) Account *account;
@end

@implementation TokenInfoViewController

- (instancetype)initWithAccount:(Account *)account token:(Token *)token {
    if (self = [super init]) {
        self.account = account;
        self.token = token;
    }
    return self;
}

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
    [self refereshTable];
    __weak typeof (self) weakSelf = self;
    [ApiServer getContractInfo:self.token.contractId callback:^(BOOL isSuc, Contract * _Nonnull contract) {
        if (isSuc) {
            for (ContractInfoItem *one in contract.info) {
                if ([one.name isEqualToString:@"issuer"]) {
                    weakSelf.token.issuer = one.data;
                }
                if ([one.name isEqualToString:@"maker"]) {
                    weakSelf.token.maker = one.data;
                }
                [weakSelf refereshTable];
            }
        }
    }];
}

- (void)refereshTable {
    NSArray *showData = @[
                                 @{@"title":VLocalize(@"token.info.id.token"), @"value":[self handleStringValue:self.token.tokenId]},
                                 @{@"title":VLocalize(@"token.info.id.contract"), @"value":[self handleStringValue:self.token.contractId]},
                                 @{@"title":VLocalize(@"token.info.issuer"), @"value":[self handleStringValue:self.token.issuer]},
                                 @{@"title":VLocalize(@"token.info.maker"), @"value":[self handleStringValue:self.token.maker]},
                                 @{@"title":VLocalize(@"token.info.supply.max"), @"value":[NSString stringWithDecimal:[NSString getAccurateDouble:self.token.max unity:self.token.unity] maxFractionDigits:[NSString getDecimal:self.token.unity] minFractionDigits:2 trimTrailing:YES]},
                                 @{@"title":VLocalize(@"token.info.supply.current"), @"value":[NSString stringWithDecimal:[NSString getAccurateDouble:self.token.total unity:self.token.unity] maxFractionDigits:[NSString getDecimal:self.token.unity] minFractionDigits:2 trimTrailing:YES]},
                                 @{@"title":VLocalize(@"token.info.unity"), @"value":[NSString stringWithFormat:@"%lld", self.token.unity]},
                                 @{@"title":VLocalize(@"token.info.description"), @"value":[self handleStringValue:self.token.desc]},
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

- (NSString *)handleStringValue:(NSString *)v {
    if (v == nil) {
        return @"";
    }
    return v;
}

@end
