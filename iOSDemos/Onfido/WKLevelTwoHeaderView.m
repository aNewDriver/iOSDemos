//
//  WKLevelTwoHeaderView.m
//  SampleAppObjC
//
//  Created by Ke Wang on 2018/9/19.
//  Copyright © 2018年 onfido. All rights reserved.
//

#define KLeftEdge 30.0f

#import "WKLevelTwoHeaderView.h"
#import "WKStepView.h"

@interface WKLevelTwoHeaderView ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *detailL;
@property (nonatomic, strong) WKStepView *stepView;

@end

@implementation WKLevelTwoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    [self addSubview:self.stepView];
    [self addSubview:self.titleL];
    [self addSubview:self.detailL];
}


#pragma mark - get

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.text = @"step 2 ID document verification";
        _titleL.frame = CGRectMake(KLeftEdge, CGRectGetMaxY(self.stepView.frame) + 10.0f, [UIScreen mainScreen].bounds.size.width - KLeftEdge * 2, 20.0f);
        _titleL.font = [UIFont systemFontOfSize:20];
    }
    return _titleL;
}

- (UILabel *)detailL {
    if (!_detailL) {
        _detailL = [[UILabel alloc] init];
        _detailL.backgroundColor = [UIColor clearColor];
        _detailL.textAlignment = NSTextAlignmentLeft;
        _detailL.text = @"Select one document to verify";
        _detailL.frame = CGRectMake(KLeftEdge, CGRectGetMaxY(self.titleL.frame) + 10.0f, [UIScreen mainScreen].bounds.size.width - KLeftEdge * 2, 20.0f);
        _detailL.font = [UIFont systemFontOfSize:14];
    }
    return _detailL;
}

- (WKStepView *)stepView {
    if (!_stepView) {
        _stepView = [[WKStepView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.0f) stepCount:3];
    }
    return _stepView;
}


@end
