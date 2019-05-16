//
//  SuccessViewController.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController()
@property (nonatomic, strong) NSString *pageTitle;
@property (nonatomic, strong) NSString *topNote;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *bottomNote;

@property (weak, nonatomic) IBOutlet UILabel *topNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomNoteLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNoteLabelTop;

@property (nonatomic, strong) SuccessObject *object;
@end

@implementation SuccessViewController

- (instancetype)initWithObject:(SuccessObject *)object {
    if (self = [self init]) {
        self.object = object;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title topNote:(NSString *)topNote content:(NSString *)content bottomNote:(NSString *)bottomNote {
    if (self = [self init]) {
        self.pageTitle = title;
        self.content = content;
        self.topNote = topNote;
        self.bottomNote = bottomNote;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    if (self.object.title) {
        self.title = self.object.title;
    }
    if (self.object.content) {
        [self.contentLabel setText:self.object.content];
    }
    if (self.object.topNote) {
        [self.topNoteLabel setText:self.object.topNote];
    }
    if (self.object.bottomNote) {
        [self.bottomNoteLabel setText:self.bottomNote];
    }
}

@end
