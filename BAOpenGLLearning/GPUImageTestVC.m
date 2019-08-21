//
//  GPUImageTestVC.m
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/21.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "GPUImageTestVC.h"
#import "SimpleGPUImgProcesser.h"

@interface GPUImageTestVC ()

@property (nonatomic) UIImage *originalImage;
@property (nonatomic) UIButton *originalButton;
@property (nonatomic) UIButton *processedButton;
@property (nonatomic) UIImageView *imageView;

@end

@implementation GPUImageTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.originalImage = [UIImage imageNamed:@"testImage"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_originalButton) {
        CGSize btnSize = CGSizeMake(50, 30);
        
        [self.view addSubview:self.originalButton];
        self.originalButton.frame = CGRectMake(floor((self.view.bounds.size.width - btnSize.width * 2 - 50) / 2), self.view.bounds.size.height - btnSize.height - 30, btnSize.width, btnSize.height);
        
        [self.view addSubview:self.processedButton];
        self.processedButton.frame = CGRectMake(CGRectGetMaxX(self.originalButton.frame) + 50, CGRectGetMinY(self.originalButton.frame), btnSize.width, btnSize.height);
        
        [self.view addSubview:self.imageView];
        self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
        self.imageView.layer.borderWidth = 1;
        self.imageView.frame = CGRectMake(10, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, self.view.bounds.size.width - 20, CGRectGetMinY(self.originalButton.frame) - 10 - 20 - CGRectGetMaxY(self.navigationController.navigationBar.frame));
        
        [self btnAction:self.originalButton];
    }
}

- (UIButton *)originalButton {
    if (!_originalButton) {
        _originalButton = [[UIButton alloc] init];
        [_originalButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _originalButton.backgroundColor = [UIColor lightGrayColor];
        [_originalButton setTitle:@"原图" forState:UIControlStateNormal];
        _originalButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _originalButton;
}

- (UIButton *)processedButton {
    if (!_processedButton) {
        _processedButton = [[UIButton alloc] init];
        [_processedButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _processedButton.backgroundColor = [UIColor lightGrayColor];
        [_processedButton setTitle:@"处理后" forState:UIControlStateNormal];
        _processedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _processedButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)btnAction:(UIButton *)sender {
    if (sender == self.originalButton) {
        self.imageView.image = self.originalImage;
    } else if (sender == self.processedButton) {
//        GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
//        GPUImageFilter *filter = [[GPUImageColorInvertFilter alloc] init];
        GPUImageFilter *filter = [[GPUImageColorInvertFilter alloc] init];
        self.imageView.image = [SimpleGPUImgProcesser processImage:self.originalImage filters:@[filter]];
    }
}

@end
