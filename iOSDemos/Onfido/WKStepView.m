//
//  WKStepView.m
//  SampleAppObjC
//
//  Created by Ke Wang on 2018/9/19.
//  Copyright © 2018年 onfido. All rights reserved.
//

#define KStepTagBegain 2000
#define KSepLineTagBegain 3000


#import "WKStepView.h"

@interface WKStepView ()

@property (nonatomic, assign) NSUInteger stepCount;

@end

@implementation WKStepView

- (instancetype)initWithFrame:(CGRect)frame stepCount:(NSUInteger)stepCount{
    if (self = [super initWithFrame:frame]) {
        self.stepCount = stepCount;
        [self configureUI];
    }
    return self;
}

#pragma mark - method

- (void)configureUI {
    
    if (self.stepCount < 1) {
        return;
    }
    [self configureSteps];
}

- (void)configureSteps {
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat stepW = 30.0f;
    CGFloat sepLW = 74.0f;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat leftEdge = (screenW - (stepW * self.stepCount + sepLW * (self.stepCount - 1))) / 2;
    
    for (int i = 0; i < self.stepCount; i++) {
        
        UILabel *step = [[UILabel alloc] init];
        step.frame = CGRectMake(leftEdge + (stepW + sepLW) * i, 20.0f, stepW, stepW);
        step.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        if (i < 2) {
            step.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1.0];
        }
        step.text = [NSString stringWithFormat:@"%d", i + 1];
        step.textAlignment = NSTextAlignmentCenter;
        step.textColor = [UIColor whiteColor];
        [step setTag:KStepTagBegain + i];
        step.layer.cornerRadius = stepW / 2;
        step.layer.masksToBounds = YES;
        [self addSubview:step];
        
        if (i!= self.stepCount - 1) {
            UIView *sepLine = [[UIView alloc] init];
            sepLine.frame = CGRectMake(leftEdge + stepW *(i + 1) + sepLW * i, 35, sepLW, 1.0f);
            sepLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
            [sepLine setTag:KSepLineTagBegain + i];
            [self addSubview:sepLine];
            
            if (i < 1) {
                sepLine.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1.0];
            }
            
        }
        
        
    }
}



@end
