//
//  ViewController.m
//  BAOpenGLLearning
//
//  Created by BenArvin on 2019/8/13.
//  Copyright © 2019 BenArvin. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLTestVC.h"
#import "GPUImageTestVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *datas;
@property (nonatomic) UIButton *displayButton;
@property (nonatomic) UIView *openGLView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[@"OpenGL ES test", @"GPUImage test"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_tableView) {
        [self.view addSubview:self.tableView];
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIViewController *vc = [[OpenGLTestVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        UIViewController *vc = [[GPUImageTestVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    return cell;
}

@end
