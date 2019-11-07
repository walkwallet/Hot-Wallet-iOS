//
//  AddTokenViewController.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "AddTokenViewController.h"
#import "QRScannerViewController.h"
#import "VThemeTextView.h"
#import "Language.h"
#import "Account.h"
#import "ApiServer.h"
#import "Token.h"
#import "Contract.h"
#import "UIView+Loading.h"
#import "UIViewController+Alert.h"
#import "VThemeButton.h"
#import "LoadingView.h"

#import "UITextView+Placeholder.h"
#import "TokenMgr.h"
#import "VColor.h"
#import "CertifiedTokenTableViewCell.h"

static NSString *const CellIdentifier = @"CertifiedTokenTableViewCell";

@interface AddTokenViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *tokenIdNoteLabel;
@property (weak, nonatomic) IBOutlet VThemeTextView *tokenIdTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorLabelHeight;
@property (nonatomic, strong) Account *account;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) Token *token;
@property (weak, nonatomic) IBOutlet VThemeButton *scanButton;
@property (weak, nonatomic) IBOutlet VThemeButton *pastButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Token *> *certifiedList;
@end

@implementation AddTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadCertifiedTokenListFromCache];
    [self loadCertifiedTokenList];
}

- (instancetype)initWithAccount:(Account *)account {
    if (self = [super init]) {
        self.account = account;
    }
    return self;
}

- (void)initView {
    self.title = VLocalize(@"token.add.token");
    [self.pastButton setTitle:VLocalize(@"account.transaction.paste") forState:UIControlStateNormal];
    [self.scanButton setTitle:VLocalize(@"account.transaction.scan.qr") forState:UIControlStateNormal];
    self.doneButton.alpha = 0.5;
    [self.doneButton setTitle:VLocalize(@"add") forState:UIControlStateNormal];
    self.tokenIdNoteLabel.text = VLocalize(@"token.token.id.note");
    self.tokenIdTextFiled.placeholder = VLocalize(@"token.input.token.id");
    self.tokenIdTextFiled.delegate = self;
    self.errorLabelHeight.constant = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = VColor.tableViewBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
}

- (void)loadCertifiedTokenListFromCache {
    NSArray<Token*> *watchedList = [TokenMgr.shareInstance loadAddressWatchToken:self.account.originAccount.address];
    NSMutableArray<NSString *> *watchedTokenIdList = [[NSMutableArray alloc] init];
    for (Token *one in watchedList) {
        [watchedTokenIdList addObject:one.tokenId];
    }
    NSArray<Token *> *cacheCertifiedList = [TokenMgr.shareInstance getCertifiedTokenList];
    for (Token *one in cacheCertifiedList) {
        if ([watchedTokenIdList containsObject:one.tokenId]) {
            NSInteger index = [cacheCertifiedList indexOfObject:one];
            cacheCertifiedList[index].watched = YES;
        }
    }
    self.certifiedList = cacheCertifiedList;
    [self.tableView reloadData];
}

- (void)loadCertifiedTokenList {
    NSArray<Token*> *watchedList = [TokenMgr.shareInstance loadAddressWatchToken:self.account.originAccount.address];
    NSMutableArray<NSString *> *watchedTokenIdList = [[NSMutableArray alloc] init];
    for (Token *one in watchedList) {
        [watchedTokenIdList addObject:one.tokenId];
    }
    [ApiServer getCertifiedTokenList:1 callback:^(BOOL isSuc, NSArray<Token *> * _Nonnull tokenArr) {
        NSMutableArray<Token *> *tokenList = [NSMutableArray new];
        for (Token *one in tokenArr) {
            if ([watchedTokenIdList containsObject: one.tokenId]) {
                one.watched = YES;
            }
            [tokenList addObject:one];
        }
        self.certifiedList = tokenList;
        [TokenMgr.shareInstance saveCertifiedTokenList:tokenArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (IBAction)ClickPaste:(id)sender {
    self.tokenIdTextFiled.text = UIPasteboard.generalPasteboard.string;
    [self.tokenIdTextFiled updatePlaceholderState];
    [self checkTokenId];
}

- (IBAction)ClickQRCode:(id)sender {
    __weak typeof(self) weakSelf = self;
    [MediaManager checkCameraPermissionsWithCallVC:self result:^ {
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:nil noMatchTipText:nil result:^(NSString * _Nullable qrCode) {
            [weakSelf scanQRcodeResult:qrCode];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}

- (IBAction)ClickDone:(id)sender {
    NSString *tokenId = self.tokenIdTextFiled.text;
    [self addToken:tokenId back:YES];
}

- (void)loadContractTextualDescriptor:(NSString *)contractId {
    __weak typeof (self) weakSelf = self;
    [ApiServer getContractContent:contractId callback:^(BOOL isSuc, ContractContent * _Nonnull contractContent) {
        if (contractContent.textual && contractContent.textual.descriptors) {
            weakSelf.token.textualDescriptor = contractContent.textual.descriptors;
        }
    }];
}

- (void)scanQRcodeResult:(NSString *)qrCode {
    self.tokenIdTextFiled.text = qrCode;
    [self.tokenIdTextFiled updatePlaceholderState];
    [self checkTokenId];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    [textView updatePlaceholderState];
    if (textView == self.tokenIdTextFiled) {
        [self checkTokenId];
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.certifiedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CertifiedTokenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.token = self.certifiedList[indexPath.row];
    if (cell.token.watched) {
        cell.addButton.layer.borderWidth = 0;
    }else {
        cell.addButton.layer.borderWidth = 1;
    }
    cell.addButton.tag = indexPath.row;
    [cell.addButton addTarget:self action:@selector(clickAddToken:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)clickAddToken:(UIButton *)sender {
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loadingView];
    [loadingView startLoadingWithColor:VColor.themeColor];
    __weak typeof (self) weakSelf = self;
    [ApiServer getTokenInfo:self.certifiedList[sender.tag].tokenId callback:^(BOOL isSuc, Token * _Nonnull token) {
        if (isSuc) {
            weakSelf.token = token;
            [self addToken:self.certifiedList[sender.tag].tokenId back:NO];
            [loadingView stopLoading];
            [loadingView removeFromSuperview];
        }else {
            [weakSelf showError:VLocalize(@"token.operate.error.id.not.exist")];
            [loadingView stopLoading];
            [loadingView removeFromSuperview];
        }
    }];
}

- (void)addToken:(NSString *)tokenId back:(BOOL)back {
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loadingView];
    [loadingView startLoadingWithColor:VColor.themeColor];
    __weak typeof (self) weakSelf = self;
    [ApiServer getAddressTokenBalance:self.account.originAccount.address tokenId:tokenId callback:^(BOOL isSuc, Token * _Nonnull token) {
        if (isSuc) {
            if ([weakSelf.token.tokenId isEqualToString:token.tokenId]) {
                NSArray<Token*> *oldList = [TokenMgr.shareInstance loadAddressWatchToken:weakSelf.account.originAccount.address];
                for (Token *one in oldList) {
                    if ([one.tokenId isEqualToString:weakSelf.token.tokenId]) {
                        [weakSelf alertWithTitle:VLocalize(@"error.token.exist")  confirmText:VLocalize(@"close")];
                        return;
                    }
                }
                [ApiServer getContractContent:VsysTokenId2ContractId(weakSelf.token.tokenId) callback:^(BOOL isSuc, ContractContent * _Nonnull contractContent) {
                    [loadingView stopLoading];
                    if (contractContent.textual && contractContent.textual.descriptors) {
                        weakSelf.token.textualDescriptor = contractContent.textual.descriptors;
                        NSString *funcJson = VsysDecodeContractTextrue(weakSelf.token.textualDescriptor);
                        if ([funcJson containsString:@"split"]) {
                            weakSelf.token.splitable = YES;
                        }
                        NSMutableArray *newList = [[NSMutableArray alloc] init];
                        [newList addObjectsFromArray:oldList];
                        weakSelf.token.balance = token.balance;
                        [newList addObject:weakSelf.token];
                        NSError *error = [TokenMgr.shareInstance saveToStorage:weakSelf.account.originAccount.address list:newList];
                        if (error != nil) {
                            [weakSelf alertWithTitle:[error localizedDescription] confirmText:VLocalize(@"close")];
                        }else {
                            [weakSelf loadCertifiedTokenList];
                            if (back) {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }
                    }else {
                        [weakSelf alertWithTitle:@"" confirmText:VLocalize(@"")];
                    }
                }];
            }else {
                [loadingView stopLoading];
                [weakSelf alertWithTitle:VLocalize(@"") confirmText:VLocalize(@"close")];
            }
        }else {
            [loadingView stopLoading];
            [weakSelf alertWithTitle:VLocalize(@"fail.add.token") confirmText:VLocalize(@"close")];
        }
    }];
}

- (void)checkTokenId {
    BOOL tokenValid = NO;
    NSString *tokenId = self.tokenIdTextFiled.text;
    if(tokenId.length > 38) {
        tokenValid = YES;
        __weak typeof (self) weakSelf = self;
        [ApiServer getTokenInfo:tokenId callback:^(BOOL isSuc, Token * _Nonnull token) {
            if (isSuc) {
                weakSelf.token = token;
                [weakSelf showError:@""];
            }else {
                [weakSelf showError:VLocalize(@"token.operate.error.id.not.exist")];
            }
        }];
    }else {
        [self showError:VLocalize(@"token.operate.error.id.format")];
    }
}

- (void)showError:(NSString*)error {
    if ([error isEqualToString:@""]) {
        self.errorLabel.text = @"";
        [UIView animateWithDuration:0.2 animations:^{
            self.errorLabelHeight.constant = 0;
            [self.doneButton setEnabled:YES];
            self.doneButton.alpha = 1;
        }];
    }else {
        self.errorLabel.text = error;
        [UIView animateWithDuration:0.2 animations:^{
            self.errorLabelHeight.constant = 15;
            [self.doneButton setEnabled:NO];
            self.doneButton.alpha = 0.5;
        }];
    }
}

@end
