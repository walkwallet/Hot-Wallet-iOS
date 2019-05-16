//
// MnemonicWordCheckViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "MnemonicWordCheckViewController.h"

#import "Language.h"
#import "WalletMgr.h"
#import "WindowManager.h"
#import "VStoryboard.h"
#import "StreamingLayoutView.h"
#import "ResultViewController.h"

@interface MnemonicWordCheckViewController () <StreamingLayoutViewDelegate>

@property (nonatomic, strong) NSArray<NSString *> *mnemonicWordArrsy;
@property (nonatomic, assign) BOOL createWallet;
@property (nonatomic, strong) NSArray<NSString *> *muddledMnemonicWordArrsy;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet StreamingLayoutView *streamingLayoutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *streamingLayoutViewHeightLC;

@property (weak, nonatomic) IBOutlet StreamingLayoutView *streamingLayoutView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *streamingLayoutView1HeightLC;
@property (weak, nonatomic) IBOutlet UIButton *submittBtn;

@property (nonatomic, assign) CGFloat contentWidth;

@end

@implementation MnemonicWordCheckViewController

- (instancetype)initWithMnemonicWordArray:(NSArray<NSString *> *)mnemonicWordArrsy createWallet:(BOOL)createWallet {
    if (self = [super init]) {
        self.mnemonicWordArrsy = mnemonicWordArrsy;
        self.createWallet = createWallet;
        self.muddledMnemonicWordArrsy = [self.mnemonicWordArrsy sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return arc4random() % 3 - 1;
        }];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:VLocalize(@"clear") style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    _contentWidth = CGRectGetWidth(UIScreen.mainScreen.bounds) - 40.f;
    self.navigationItem.title = VLocalize(@"nav.title.mnemonic.backup.check");
    _titleLabel.text = VLocalize(@"mnemonic.backup.check.title");
    [_submittBtn setTitle:VLocalize(@"confirm") forState:UIControlStateNormal];
    
    _streamingLayoutView1.delegate = self;
    _streamingLayoutView1HeightLC.constant = [_streamingLayoutView1 heightWithItemArray:self.muddledMnemonicWordArrsy width:_contentWidth];
    
    _streamingLayoutView.delegate = self;
    _streamingLayoutView.contentInsets = UIEdgeInsetsMake(16, 10, 16, 10);
    [self updateAlreadyMnemonicWords:@[]];
}

- (void)clear {
    [self updateAlreadyMnemonicWords:@[]];
    _streamingLayoutView1HeightLC.constant = [_streamingLayoutView1 heightWithItemArray:self.muddledMnemonicWordArrsy width:_contentWidth];
}

- (void)updateAlreadyMnemonicWords:(NSArray<NSString *> *)mnemonicWords {
    CGFloat height = [_streamingLayoutView heightWithItemArray:mnemonicWords.copy width:_contentWidth];
    self.streamingLayoutViewHeightLC.constant = height > _streamingLayoutView1HeightLC.constant + 32.f ? height : _streamingLayoutView1HeightLC.constant + 32.f;
    BOOL canSubmit = (_streamingLayoutView.itemArray.count == self.mnemonicWordArrsy.count) && ([[self.mnemonicWordArrsy componentsJoinedByString:@" "] isEqualToString:[_streamingLayoutView.itemArray componentsJoinedByString:@" "]]);
    _submittBtn.enabled = canSubmit;
}

#pragma mark - StreamingLayoutView Delegate
- (void)streamingLayoutView:(StreamingLayoutView *)streamingLayoutView didSelectItemBtn:(UIButton *)itemBtn {
    NSString *itemTitle = itemBtn.currentTitle;NSMutableArray *mnemonicWordArray = _streamingLayoutView.itemArray.mutableCopy;
    if (streamingLayoutView == _streamingLayoutView) {
        [_streamingLayoutView1 changeItemStateWithItem:itemTitle];
        [mnemonicWordArray removeObject:itemTitle];
    } else {
        if (itemBtn.selected) {
            [mnemonicWordArray addObject:itemTitle];
        } else {
            [mnemonicWordArray removeObject:itemTitle];
        }
    }
    [self updateAlreadyMnemonicWords:mnemonicWordArray];
}

- (IBAction)sibmitBtnClick {
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:VLocalize(@"mnemonic.backup.success.title") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32]}];
    NSAttributedString *attrMessage = [[NSAttributedString alloc] initWithString:VLocalize(@"mnemonic.backup.success.detail") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightLight]}];
    ResultParameter *parameter = [ResultParameter paramterWithImgResourceName:@"ico_success_tip" attrTitle:attrTitle attrMessage:attrMessage titleMessageSpecing:8];
    [parameter setOperateBtnTitle:VLocalize(@"done")];
    ResultViewController *resultVC = [[ResultViewController alloc] initWithResultParameter:parameter];
    __weak typeof(self) weakSelf = self;
    [parameter setOperateBlock:^{
        if (weakSelf.createWallet) {
            [WindowManager changeToRootViewController:[VStoryboard.Main instantiateInitialViewController]];
        } else {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    [self presentViewController:resultVC animated:YES completion:nil];
}

@end
