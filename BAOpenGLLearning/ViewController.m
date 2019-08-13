//
//  ViewController.m
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/13.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "ViewController.h"
#import "TestTriangleView.h"

@interface ViewController ()

@property (nonatomic) UIButton *displayButton;
@property (nonatomic) TestTriangleView *testTriangleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_testTriangleView) {
        [self.view addSubview:self.displayButton];
        CGSize btnSize = CGSizeMake(50, 30);
        self.displayButton.frame = CGRectMake(floor((self.view.bounds.size.width - btnSize.width) / 2), self.view.bounds.size.height - btnSize.height - 30, btnSize.width, btnSize.height);
        
        self.testTriangleView = [[TestTriangleView alloc] init];
        [self.view addSubview:self.testTriangleView];
        self.testTriangleView.frame = CGRectMake(10, 10, self.view.bounds.size.width - 20, CGRectGetMinY(self.displayButton.frame) - 10 - 20);
    }
}

- (UIButton *)displayButton {
    if (!_displayButton) {
        _displayButton = [[UIButton alloc] init];
        [_displayButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _displayButton.backgroundColor = [UIColor lightGrayColor];
        [_displayButton setTitle:@"显示" forState:UIControlStateNormal];
        _displayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _displayButton;
}

- (void)btnAction:(UIButton *)sender {
    [self.testTriangleView display];
}

@end
