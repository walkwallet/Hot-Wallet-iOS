
//
//  UIViewController+Transaction.m
//  Wallet
//
//  All rights reserved.
//

#import "UIViewController+Transaction.h"
#import "Language.h"
#import "AlertViewController.h"
#import "AlertNavController.h"
#import <Masonry/Masonry.h>
@import Vsys;
#import "TransactionDetailViewController.h"
#import "ToastPasswordViewController.h"
#import "ApiServer.h"
#import "Account.h"
#import "ResultViewController.h"
#import "NSString+Decimal.h"
#import "UIView+Loading.h"
#import "VColor.h"
#import "TokenMgr.h"
#import "UIViewController+Alert.h"

@implementation UIViewController (Transaction)

- (void)beginTransactionConfirmWithTransaction:(Transaction *)transaction account:(Account *)account {
    __weak typeof(self) weakSelf = self;
    
    AlertViewController *vc = [[AlertViewController alloc] initWithTitle:VLocalize(@"tip.transaction.review.title") confirmTitle:VLocalize(@"confirm") configureContent:^(UIViewController * _Nonnull vc, UIStackView * _Nonnull parentView) {
        TransactionDetailViewController *detailVC = [[TransactionDetailViewController alloc] initWithTransaction:transaction account:account];
        [vc addChildViewController:detailVC];
        [parentView addArrangedSubview:detailVC.view];
        CGFloat maxHeight = CGRectGetHeight(UIScreen.mainScreen.bounds) * 0.8 - 104;
        [detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(450 > maxHeight ? maxHeight : 450);
        }];
    } cancel:^(UIViewController * _Nonnull vc) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } confirm:^(UIViewController * _Nonnull vc) {
        [vc transactionPasswordAuth:^(BOOL result) {
            if (result) {
                AlertViewController *alertVC = (AlertViewController *)vc;
                [alertVC.mainView startLoadingWithColor:VColor.themeColor];
                if (transaction.originTransaction.txType == VsysTxTypePayment) {
                    [ApiServer broadcastPayment:transaction callback:^(BOOL isSuc) {
                        [alertVC.mainView stopLoading];
                        if (isSuc) {
                            [weakSelf showSuccessTx:transaction];
                        }
                    }];
                } else if (transaction.originTransaction.txType == VsysTxTypeLease) {
                    [ApiServer broadcastLease:transaction callback:^(BOOL isSuc) {
                        [alertVC.mainView stopLoading];
                        if (isSuc) {
                            [weakSelf showSuccessTx:transaction];
                        }
                    }];
                } else if (transaction.originTransaction.txType == VsysTxTypeCancelLease) {
                    [ApiServer broadcastCancelLease:transaction callback:^(BOOL isSuc) {
                        [alertVC.mainView stopLoading];
                        if (isSuc) {
                            [weakSelf showSuccessTx:transaction];
                        }
                    }];
                } else if (transaction.originTransaction.txType == VsysTxTypeContractRegister) {
                    [ApiServer broadcastContractRegister:transaction callback:^(BOOL isSuc, Token * _Nonnull token) {
                        [alertVC.mainView stopLoading];
                        if (isSuc) {
                            NSMutableArray *newList = [NSMutableArray new];
                            [newList addObjectsFromArray:[TokenMgr.shareInstance loadAddressWatchToken:account.originAccount.address]];
                            [newList addObject:token];
                            NSError *error = [TokenMgr.shareInstance saveToStorage:account.originAccount.address list:newList];
                            if (error != nil) {
                                NSLog(@"add new token to storage error: %@", error.localizedDescription);
                            }else {
                                transaction.originTransaction.contractId = token.contractId;
                                [weakSelf showSuccessTx:transaction];
                            }
                        }
                    }];
                } else if (transaction.originTransaction.txType == VsysTxTypeContractExecute) {
                    [ApiServer broadcastContractExecute:transaction callback:^(BOOL isSuc) {
                        [alertVC.mainView stopLoading];
                        if (isSuc) {
                            [weakSelf showSuccessTx:transaction];
                        }else {
                            [weakSelf remindWithMessage:VLocalize(@"error.contract.send.failed")];
                        }
                    }];
                } else {
                    [alertVC.mainView stopLoading];
                }
            }
        }];
    } back:NO];
    AlertNavController *nav = [[AlertNavController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showSuccessTx: (Transaction *)transaction {
    __weak typeof(self) weakSelf = self;
    VsysTransaction *tx = transaction.originTransaction;
    NSDecimalNumber *amountDecimal = [[NSDecimalNumber alloc] initWithLongLong:tx.amount];
    NSString *title;
    NSString *iconName = @"ico_success_tip";
    if (tx.txType == VsysTxTypePayment) {
        NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLong:VsysVSYS];
        NSString *amountStr = [NSString stringWithDecimal:[amountDecimal decimalNumberByDividingBy:unityDecimal] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
        title = [NSString stringWithFormat:VLocalize(@"transaction.sent.success.title"), amountStr, tx.recipient];
    } else if (tx.txType == VsysTxTypeLease) {
        NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLong:VsysVSYS];
        NSString *amountStr = [NSString stringWithDecimal:[amountDecimal decimalNumberByDividingBy:unityDecimal] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
        title = [NSString stringWithFormat:VLocalize(@"transaction.lease.success.title"), amountStr, tx.recipient];
    } else if (tx.txType == VsysTxTypeCancelLease) {
        NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLong:VsysVSYS];
        NSString *amountStr = [NSString stringWithDecimal:[amountDecimal decimalNumberByDividingBy:unityDecimal] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
        title = [NSString stringWithFormat:VLocalize(@"transaction.cancel.lease.success.title"), amountStr, tx.recipient];
    } else if (tx.txType == VsysTxTypeContractRegister) {
        title = [NSString stringWithFormat:VLocalize(@"transaction.create.contract"), VsysContractId2TokenId(tx.contractId, 0)];
    } else if (tx.txType == VsysTxTypeContractExecute) {
        Token *token = [TokenMgr.shareInstance getTokenByAddress:transaction.senderAddress tokenId:VsysContractId2TokenId(tx.contractId, 0)];
        VsysContract *c = [VsysContract new];
        NSString *funcName = VsysGetFuncNameFromDescriptor(token.textualDescriptor, transaction.originTransaction.funcIdx);
        if ([funcName isEqualToString:@"send"]) {
            [c decodeSend: tx.data];
            tx.recipient = c.recipient;
            tx.amount = c.amount;
            NSDecimalNumber *tokenAmount = [[NSDecimalNumber alloc] initWithLongLong:c.amount];
            NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLongLong:token.unity];
            NSString *amountStr = [NSString stringWithDecimal:[tokenAmount decimalNumberByDividingBy:unityDecimal] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES];
            title = [NSString stringWithFormat:VLocalize(@"transaction.contract.execute"), amountStr, [NSString isNilOrEmpty:token.name] ? @"tokens" : token.name, c.recipient];
        }else if([funcName isEqualToString:@"issue"]) {
            [c decodeIssue: tx.data];
            tx.recipient = c.recipient;
            tx.amount = c.amount;
            NSDecimalNumber *tokenAmount = [[NSDecimalNumber alloc] initWithLongLong:c.amount];
            NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLongLong:token.unity];
            NSString *amountStr = [NSString stringWithDecimal:[tokenAmount decimalNumberByDividingBy:unityDecimal] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES];
            title = [NSString stringWithFormat:@"%@\n%@", amountStr, VLocalize(@"token.operate.issue.amount")];
        }else if([funcName isEqualToString:@"destroy"]) {
            [c decodeDestroy: tx.data];
            tx.recipient = c.recipient;
            tx.amount = c.amount;
            NSDecimalNumber *tokenAmount = [[NSDecimalNumber alloc] initWithLongLong:c.amount];
            NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLongLong:token.unity];
            NSString *amountStr = [NSString stringWithDecimal:[tokenAmount decimalNumberByDividingBy:unityDecimal] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES];
            title = [NSString stringWithFormat:@"%@\n%@", amountStr, VLocalize(@"token.operate.burn.amount")];
            iconName = @"ico_burn_big";
        }else {
            title = VLocalize(@"success");
        }
    } else {
        return;
    }
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    NSAttributedString *attrMessage = [[NSAttributedString alloc] initWithString:VLocalize(@"transaction.success.detail") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightLight]}];
    if (tx.txType == VsysTxTypeContractRegister) {
        [attrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[title rangeOfString:VsysContractId2TokenId(tx.contractId, 0)]];
        attrMessage = [[NSAttributedString alloc] initWithString:VLocalize(@"token.register.success.check.watch.list") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightLight]}];
    }else if (tx.txType == VsysTxTypeContractExecute) {
        Token *token = [TokenMgr.shareInstance getTokenByAddress:transaction.senderAddress tokenId:VsysContractId2TokenId(tx.contractId, 0)];
        NSString *funcName = VsysGetFuncNameFromDescriptor(token.textualDescriptor, transaction.originTransaction.funcIdx);
        NSDecimalNumber *tokenAmount = [[NSDecimalNumber alloc] initWithLongLong:tx.amount];
        NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLongLong:token.unity];
        NSString *amountStr = [NSString stringWithDecimal:[tokenAmount decimalNumberByDividingBy:unityDecimal] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES];
        if ([funcName isEqualToString:@"issue"]) {
            [attrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:32] range:[title rangeOfString:amountStr]];
        }else if ([funcName isEqualToString:@"destroy"]) {
            [attrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:32] range:[title rangeOfString:amountStr]];
        }else {
            [attrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[title rangeOfString:tx.recipient]];
        }
        attrMessage = [[NSAttributedString alloc] initWithString:VLocalize(@"token.register.success.check.watch.list") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightLight]}];
    }else {
        [attrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[title rangeOfString:tx.recipient]];
    }
    ResultParameter *parameter = [ResultParameter paramterWithImgResourceName:iconName attrTitle:attrTitle attrMessage:attrMessage titleMessageSpecing:16];
    parameter.showNavigationBar = YES;
    [parameter setOperateBtnTitle:VLocalize(@"done")];
    ResultViewController *resultVC = [[ResultViewController alloc] initWithResultParameter:parameter];
    [parameter setOperateBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    resultVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:resultVC animated:YES completion:nil];
}

- (void)transactionPasswordAuth:(void(^)(BOOL result))callback {
    __weak typeof(self) weakSelf = self;
    AlertViewController *vc = [[AlertViewController alloc] initWithTitle:VLocalize(@"tip.password.auth.title") confirmTitle:VLocalize(@"") configureContent:^(UIViewController * _Nonnull vc, UIStackView * _Nonnull parentView) {
        ToastPasswordViewController *toast = [[ToastPasswordViewController alloc] initWithConfirmTitle:VLocalize(@"confirm") result:^(BOOL result) {
            if (result) {
                callback(result);
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
            }
        }];
        
        [vc addChildViewController:toast];
        [parentView addArrangedSubview:toast.view];
        CGFloat maxHeight = CGRectGetHeight(UIScreen.mainScreen.bounds) * 0.8 - 104;
        [toast.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(450 > maxHeight ? maxHeight + 60 : 510);
        }];
    } cancel:^(UIViewController * _Nonnull vc) {
        [vc.navigationController popViewControllerAnimated:YES];
    } confirm:^(UIViewController * _Nonnull vc) {
        
    } back:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
