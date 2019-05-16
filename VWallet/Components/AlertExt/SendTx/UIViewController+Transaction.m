
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
                            [weakSelf showSuccessTx:transaction.originTransaction];
                        }
                    }];
                } else if (transaction.originTransaction.txType == VsysTxTypeLease) {
                    [ApiServer broadcastLease:transaction callback:^(BOOL isSuc) {
                        [alertVC.mainView stopLoading];
                        if (isSuc) {
                            [weakSelf showSuccessTx:transaction.originTransaction];
                        }
                    }];
                } else if (transaction.originTransaction.txType == VsysTxTypeCancelLease) {
                    [ApiServer broadcastCancelLease:transaction callback:^(BOOL isSuc) {
                        [alertVC.mainView stopLoading];
                        if (isSuc) {
                            [weakSelf showSuccessTx:transaction.originTransaction];
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

- (void)showSuccessTx: (VsysTransaction *)tx {
    __weak typeof(self) weakSelf = self;
    
    NSString *amountStr = [NSString stringWithDecimal:(tx.amount * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    NSString *title;
    if (tx.txType == VsysTxTypePayment) {
        title = [NSString stringWithFormat:VLocalize(@"transaction.sent.success.title"), amountStr, tx.recipient];
    } else if (tx.txType == VsysTxTypeLease) {
        title = [NSString stringWithFormat:VLocalize(@"transaction.lease.success.title"), amountStr, tx.recipient];
    } else if (tx.txType == VsysTxTypeCancelLease) {
        title = [NSString stringWithFormat:VLocalize(@"transaction.cancel.lease.success.title"), amountStr, tx.recipient];
    } else {
        return;
    }
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    [attrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[title rangeOfString:tx.recipient]];
    
    NSAttributedString *attrMessage = [[NSAttributedString alloc] initWithString:VLocalize(@"transaction.success.detail") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightLight]}];
    ResultParameter *parameter = [ResultParameter paramterWithImgResourceName:@"ico_success_tip" attrTitle:attrTitle attrMessage:attrMessage titleMessageSpecing:16];
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
