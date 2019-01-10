//
// DatePicker.m
//  Wallet
//
//  All rights reserved.
//

#import "DatePicker.h"
#import "VColor.h"
#import "Language.h"

@interface DatePicker ()

@property (nonatomic, assign) NSTimeInterval minTimestamp;
@property (nonatomic, assign) NSTimeInterval maxTimestamp;
@property (nonatomic, assign) NSTimeInterval currentTimestamp;
@property (nonatomic, strong) void(^resultBlock)(NSTimeInterval);

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UIButton *negativeBtn;
@property (weak, nonatomic) IBOutlet UIButton *positiveBtn;

@end

@implementation DatePicker

- (instancetype)initWithMinTimestamp:(NSTimeInterval)minTimestamp maxTimestamp:(NSTimeInterval)maxTimestamp currentTimestamp:(NSTimeInterval)currentTimestamp result:(nonnull void (^)(NSTimeInterval))result {
    if (self = [super init]) {
        self.minTimestamp = minTimestamp;
        self.maxTimestamp = maxTimestamp;
        self.currentTimestamp = currentTimestamp;
        self.resultBlock = result;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self.negativeBtn setTitle:VLocalize(@"cancel") forState:UIControlStateNormal];
    [self.positiveBtn setTitle:VLocalize(@"done") forState:UIControlStateNormal];
    if (self.minTimestamp > 0) {
        self.dataPicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:self.minTimestamp];
    }
    if (self.maxTimestamp > 0) {
        self.dataPicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:self.maxTimestamp];
    }
    if (self.currentTimestamp > 0) {
        self.dataPicker.date = [NSDate dateWithTimeIntervalSince1970:self.currentTimestamp];
    }
    self.containerView.transform = CGAffineTransformMakeTranslation(0, 250);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)done {
    if (self.resultBlock) {
        self.resultBlock(self.dataPicker.date.timeIntervalSince1970);
    }
    [self close];
}

- (IBAction)close {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform =  CGAffineTransformMakeTranslation(0, 250);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.containerView];
    if (!CGRectContainsPoint(self.containerView.bounds, point)) {
        [self close];
    }
}

@end
