//
//  UIViewController+ColdWalletTransaction.m
//  Wallet
//
//  All rights reserved.
//

#import "UIViewController+ColdWalletTransaction.h"
@import Vsys;
#import "Language.h"
#import "AppState.h"
#import "TouchIDTool.h"
#import "UIViewController+Alert.h"
#import "WalletMgr.h"
#import "VColor.h"
#import "VStoryboard.h"
#import "UIViewController+Alert.h"
#import "AlertViewController.h"
#import "AlertNavController.h"
#import <Masonry/Masonry.h>
#import "ResultViewController.h"
#import "NSString+Decimal.h"
#import "MediaManager.h"
#import "QRScannerViewController.h"
#import "TransactionQrcodeViewController.h"
#import "TransactionDetailViewController.h"
#import "Transaction.h"
#import "ApiServer.h"
#import "UIView+Loading.h"

@implementation UIViewController (ColdWalletTransaction)

- (void)coldWalletSendTransactionWithTransation:(Transaction *)transaction account:(Account *)account {
    __weak typeof(self) weakSelf = self;
    
    AlertViewController *vc = [[AlertViewController alloc] initWithTitle:VLocalize(@"tip.transaction.review.title") confirmTitle:VLocalize(@"tip.transaction.review.btn.title") configureContent:^(UIViewController * _Nonnull vc, UIStackView * _Nonnull parentView) {
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
        [vc qrCodeConfirmTx:transaction account:account];
    } back:NO];
    AlertNavController *nav = [[AlertNavController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)qrCodeConfirmTx:(Transaction *)tx account:(Account *)account {
    __weak typeof(self) weakSelf = self;
    
    AlertViewController *vc = [[AlertViewController alloc] initWithTitle:VLocalize(@"tip.transaction.qrcode.title") confirmTitle:VLocalize(@"continue") configureContent:^(UIViewController * _Nonnull vc, UIStackView * _Nonnull parentView) {
        TransactionQrcodeViewController *qrCodeVc = [[TransactionQrcodeViewController alloc] initWithTransaction:tx.originTransaction account:account];
        [vc addChildViewController:qrCodeVc];
        [parentView addArrangedSubview:qrCodeVc.view];
        CGFloat maxHeight = CGRectGetHeight(UIScreen.mainScreen.bounds) * 0.8 - 104;
        [qrCodeVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(450 > maxHeight ? maxHeight : 450);
        }];
    } cancel:^(UIViewController * _Nonnull vc) {
        [vc.navigationController popViewControllerAnimated:YES];
    } confirm:^(UIViewController * _Nonnull vc) {
        [vc scanQrCode:tx account:account];
    } back:YES];
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

- (void)scanQrCode:(Transaction *)tx account:(Account *)account {
    __weak typeof(self) weakSelf = self;
    
    [MediaManager checkCameraPermissionsWithCallVC:self result:^ {
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:nil noMatchTipText:nil result:^(NSString * _Nullable qrCode) {
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[qrCode dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            if (error || !dict[@"signature"] || ![dict[@"opc"] isEqualToString:VsysOpcTypeSignature]) {
                [weakSelf alertWithTitle:VLocalize(@"tip.qrcode.unsupported.types") confirmText:VLocalize(@"ok")];
                return;
            }
            [weakSelf transactionReConfirmTx:tx account:account signature:dict[@"signature"]];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}

- (void)transactionReConfirmTx:(Transaction *)transaction account:(Account *)account signature:(NSString *)signature {
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
        [vc.navigationController popViewControllerAnimated:YES];
    } confirm:^(UIViewController * _Nonnull vc) {
        AlertViewController *alertVC = (AlertViewController *)vc;
        [alertVC.mainView startLoadingWithColor:VColor.themeColor];
        transaction.signature = signature;
        if (transaction.originTransaction.txType == VsysTxTypePayment) {
            [ApiServer broadcastPayment:transaction callback:^(BOOL isSuc) {
                [alertVC.mainView stopLoading];
                if (isSuc) {
                    [weakSelf showSuccessTxForColdWallet:transaction.originTransaction];
                }
            }];
        } else if (transaction.originTransaction.txType == VsysTxTypeLease) {
            [ApiServer broadcastLease:transaction callback:^(BOOL isSuc) {
                [alertVC.mainView stopLoading];
                if (isSuc) {
                    [weakSelf showSuccessTxForColdWallet:transaction.originTransaction];
                }
            }];
        } else if (transaction.originTransaction.txType == VsysTxTypeCancelLease) {
            [ApiServer broadcastCancelLease:transaction callback:^(BOOL isSuc) {
                [alertVC.mainView stopLoading];
                if (isSuc) {
                    [weakSelf showSuccessTxForColdWallet:transaction.originTransaction];
                }
            }];
        } else {
            [vc.view stopLoading];
        }
    } back:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showSuccessTxForColdWallet:(VsysTransaction *)tx {
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
        [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [(UINavigationController *)weakSelf.navigationController.presentingViewController.childViewControllers[0] popViewControllerAnimated:NO];
    }];
    resultVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:resultVC animated:YES completion:nil];
}

@end
