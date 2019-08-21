//
//  OpenGLTestVC.m
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/21.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "OpenGLTestVC.h"
#import "TestTriangleView.h"
#import "TestSquareView.h"
#import "TestCircleView.h"
#import "TestColorfulSquareView.h"
#import "TestTextureView.h"

@interface OpenGLTestVC ()

@property (nonatomic) UIButton *displayButton;
@property (nonatomic) UIView *openGLView;

@end

@implementation OpenGLTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_displayButton) {
        [self.view addSubview:self.displayButton];
        CGSize btnSize = CGSizeMake(50, 30);
        self.displayButton.frame = CGRectMake(floor((self.view.bounds.size.width - btnSize.width) / 2), self.view.bounds.size.height - btnSize.height - 30, btnSize.width, btnSize.height);
        
        [self.view addSubview:self.openGLView];
        self.openGLView.layer.borderColor = [UIColor blackColor].CGColor;
        self.openGLView.layer.borderWidth = 1;
        self.openGLView.frame = CGRectMake(10, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, self.view.bounds.size.width - 20, CGRectGetMinY(self.displayButton.frame) - 10 - 20 - CGRectGetMaxY(self.navigationController.navigationBar.frame));
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

- (UIView *)openGLView {
    if (!_openGLView) {
        _openGLView = [[TestTextureView alloc] init];
    }
    return _openGLView;
}

- (void)btnAction:(UIButton *)sender {
    [self.openGLView performSelector:@selector(display)];
}

@end
