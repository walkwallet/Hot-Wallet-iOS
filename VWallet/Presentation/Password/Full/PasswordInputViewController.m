//
// PasswordInputViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "PasswordInputViewController.h"

#import "Language.h"
#import "WalletMgr.h"
#import "WindowManager.h"
#import "VColor.h"
#import "VStoryboard.h"
#import "TouchIDTool.h"
#import "AppState.h"
#import "VAlertViewController.h"
#import "TouchIDTool.h"
#import "UIViewController+Alert.h"

@interface PasswordInputViewController ()

@property (nonatomic, strong) void(^resultBlock)(BOOL);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImgViewTopLC;
@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIView *pwdBgView;

//@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (weak, nonatomic) IBOutlet UIButton *touchIDBtn;

@end

@implementation PasswordInputViewController

- (instancetype)initWithResult:(void (^)(BOOL))result {
    self = [VStoryboard.Password instantiateViewControllerWithIdentifier:@"PasswordInputViewController"];
    self.resultBlock = result;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    self.pageTitleLabel.text = VLocalize(@"password.auth.title");
    self.pageSubtitleLabel.text = VLocalize(@"password.auth.detail");
    self.enterBtn.tintColor = UIColor.grayColor;
    self.pwdTextField.placeholder = VLocalize(@"password.auth.textfield.placeholder");
    [self activeAuth];
    
    if ([TouchIDTool.authType isEqualToString:@"FaceID"]) {
        [self.touchIDBtn setImage:[UIImage imageNamed:@"face_id"] forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeAuth) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)activeAuth {
    if (AppState.shareInstance.lockEnable && WalletMgr.shareInstance.password) {
        [self touchIDBtnClick:self.touchIDBtn];
    } else {
        self.touchIDBtn.hidden = YES;
        [self.pwdTextField becomeFirstResponder];
    }
}

- (IBAction)pwdTextFieldEditingChanged {
    _enterBtn.enabled = self.pwdTextField.text.length > 0;
    _enterBtn.tintColor = _enterBtn.enabled ? VColor.orangeColor : UIColor.grayColor;
}

- (IBAction)submit {
    [self.view endEditing:YES];
    WalletMgr.shareInstance.password = _pwdTextField.text;
    NSError *error = [WalletMgr.shareInstance loadWallet:_pwdTextField.text];
    if (!error) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:@"errorCount"];
        if (_resultBlock) {
            _resultBlock(YES);
        } else {
            [WindowManager changeToRootViewController:VStoryboard.Main.instantiateInitialViewController];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        if (_resultBlock) {
            _resultBlock(NO);
        }
        
        NSInteger errorCount = 1;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"errorCount"]) {
            errorCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"errorCount"] integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:errorCount + 1] forKey:@"errorCount"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:errorCount] forKey:@"errorCount"];
        }
        
        if (errorCount >= 5) {
            VAlertViewController *pwdErrorAlert = [[VAlertViewController alloc] initWithTitle:VLocalize(@"tip.password.auth.err.title") secondTitle:nil contentView:nil cancelTitle:VLocalize(@"tip.password.auth.err.btn1.title") confirmTitle:VLocalize(@"tip.password.auth.err.btn2.title") cancel:^{
                VAlertViewController *vc = [[VAlertViewController alloc] initWithTitle:VLocalize(@"tip.logout.title") secondTitle:VLocalize(@"tip.logout.detail") contentView:^(UIStackView * _Nonnull view) {

                } cancelTitle:VLocalize(@"cancel") confirmTitle:VLocalize(@"logout") cancel:^{

                } confirm:^{
                    [WalletMgr.shareInstance logoutWallet];
                    [WindowManager changeToRootViewController:VStoryboard.Generate.instantiateInitialViewController];
                }];
                [weakSelf presentViewController:vc animated:YES completion:nil];
            } confirm:^{
                [weakSelf.pwdTextField becomeFirstResponder];
            }];
            [self presentViewController:pwdErrorAlert animated:YES completion:nil];
        }else{
            
            [self alertWithTitle:VLocalize(@"tip.password.auth.err.title") message:nil confirmText:VLocalize(@"confirm") handler:^{
                [weakSelf.pwdTextField becomeFirstResponder];
            }];
        }
        
    }
}

- (IBAction)touchIDBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    [TouchIDTool authSecureID:^(BOOL support, BOOL result) {
        if (support && !result) {
            return ;
        }
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(YES);
        } else {
            [WindowManager changeToRootViewController:VStoryboard.Main.instantiateInitialViewController];
        }
    }];
}


#pragma mark - keyboard
- (void)keyboardShow:(NSNotification *)notification {
    CGFloat keyboardMinY = CGRectGetMinY([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    CGFloat inputViewMaxY = CGRectGetMaxY([self.pwdBgView convertRect:self.pwdBgView.bounds toView:self.view]);
    // 100: distance between logo and top when keyboard hidden
    // 52: max distance between logo and top when keyboard show
    CGFloat offset = MAX((100 - 52), (inputViewMaxY + 20 - keyboardMinY));

    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewKeyframeAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:duration delay:0 options:option animations:^{
        weakSelf.logoImgViewTopLC.constant = 100 - offset;
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewKeyframeAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:duration delay:0 options:option animations:^{
        weakSelf.logoImgViewTopLC.constant = 100;
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

@end
