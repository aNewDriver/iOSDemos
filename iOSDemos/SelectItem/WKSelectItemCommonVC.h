//
//  WKSelectItemCommonVC.h
//  SampleAppObjC
//
//  Created by Ke Wang on 2018/9/17.
//  Copyright © 2018年 onfido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKSelectCell : UITableViewCell

- (void)configuireCellWithString:(NSString *)string;

@end


typedef void(^WKSelectModelCallBack)(id result);

@interface WKSelectItemCommonVC : UIViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) WKSelectModelCallBack WKselectModelCallBack;

@end


