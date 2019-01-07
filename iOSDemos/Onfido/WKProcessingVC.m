//
//  WKProcessingVC.m
//  SampleAppObjC
//
//  Created by Ke Wang on 2018/9/20.
//  Copyright © 2018年 onfido. All rights reserved.
//

#import "WKProcessingVC.h"

@interface WKProcessingVC ()

@property (nonatomic, strong) UIImageView *processingImage;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *detailL;
@property (nonatomic, strong) UIButton *button;


@end

@implementation WKProcessingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    // Do any additional setup after loading the view.
}

- (void)configureUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self customGoBack];
    [self.view addSubview:self.processingImage];
    [self.view addSubview:self.titleL];
    [self.view addSubview:self.detailL];
    [self.view addSubview:self.button];
    
}

- (void)customGoBack {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)goBack:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - method

- (void)btnClick:(UIButton *)sender {

    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - get

- (UIImageView *)processingImage {
    if (!_processingImage) {
        _processingImage = [[UIImageView alloc] init];
        _processingImage.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 130) / 2, 104, 130, 130);
        _processingImage.image = [UIImage imageNamed:@"processing"];
        _processingImage.layer.cornerRadius = 130/2;
        _processingImage.layer.masksToBounds = YES;
    }
    return _processingImage;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.processingImage.frame) + 40, [UIScreen mainScreen].bounds.size.width - 60, 48)];
        _titleL.text = @"Your information has successfully sent for review";
        _titleL.numberOfLines = 2;
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:20];
    }
    return _titleL;
}

- (UILabel *)detailL {
    if (!_detailL) {
        _detailL = [[UILabel alloc] init];
        _detailL.backgroundColor = [UIColor clearColor];
        _detailL.textAlignment = NSTextAlignmentCenter;
        _detailL.text = @"your status will be updated soon.";
        _detailL.frame = CGRectMake(30, CGRectGetMaxY(self.titleL.frame) + 20.0f, [UIScreen mainScreen].bounds.size.width - 30 * 2, 20.0f);
        _detailL.font = [UIFont systemFontOfSize:14];
    }
    return _detailL;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(30, CGRectGetMaxY(self.detailL.frame) + 50.0f, [UIScreen mainScreen].bounds.size.width - 30 * 2, 40.0f);
        _button.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1.0];
        [_button setTitle:@"OK" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _button.layer.cornerRadius = 4.0f;
        _button.layer.masksToBounds = YES;
    }
    return _button;
}



@end
