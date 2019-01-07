//
//  WKLevelTwoVC.m
//  SampleAppObjC
//
//  Created by Ke Wang on 2018/9/19.
//  Copyright © 2018年 onfido. All rights reserved.
//

#import "WKLevelTwoVC.h"
#import "WKLevelTwoHeaderView.h"
#import <Onfido/Onfido-Swift.h>
#import "AFNetworking.h"
//#import <AFNetworking/AFNetworking.h>
//#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD.h"
#import "WKProcessingVC.h"

static NSString *APIToken= @"test_37NnaT3-mPbU8XRNn0A86tHhaD9YIhWK";
static NSString *MobileSDKToken = @"test_ngINtxSnbZChgU1uUbL6MlKc0P4qbveU";

@interface WKLevelTwoVC () <UITableViewDelegate, UITableViewDataSource> {
    NSString *token;
}

@property (nonatomic, strong) UITableView *mainTV;
@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) WKLevelTwoHeaderView *headerView;
@property (nonatomic, assign) NSUInteger hasSuccessCount;
@property (nonatomic, copy) NSString *country;




@end

@implementation WKLevelTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self configureSource];
    self.hasSuccessCount = 0;
    
    [self configureData:^(NSArray *list) {
        self.dataSource = list;
        [self.mainTV reloadData];
    }];
}


#pragma mark - configureData

- (void)configureData:(void(^)(NSArray *))onResponse {
    
    MBProgressHUD *progressDisplay = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"country" : @"Congo"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
//    NSString *tokenHeaderValue = [NSString stringWithFormat:@"Token token=%@", self->token];
//    [manager.requestSerializer setValue:tokenHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager GET:@"https://api-master.micai.ai:8443/user/user/kyc/supported_documents/"
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [progressDisplay removeFromSuperview];
              
              onResponse([responseObject valueForKey:@"doc_types_list"]);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [progressDisplay removeFromSuperview];
              NSLog(@"failed to create applicant");
              onResponse(NULL);
          }];
}



#pragma mark - method

- (void)btnCilck:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureBackBtn {
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(20, 20, 50, 20);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:button];
    [button addTarget:self action:@selector(btnCilck:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configureUI {
    self.title = @"Level2";
    self->token = MobileSDKToken;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTV];
    [self configureBackBtn];
}


- (void)setDataSource:(NSArray *)dataSource {
    
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    [self.mainTV reloadData];
}

- (void)configureSource
{
    self.dataSource = @[];
}


#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    NSString *title = self.dataSource[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.textColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self presentToOnfidoViewControllerWithIndexPath:indexPath];
}


- (void)presentToOnfidoViewControllerWithIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.mainTV cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        
        [self createApplicant:^(NSString *applicantId) {
            
            NSLog(@"applicantId = %@", applicantId);
            
            if (applicantId) {
                
                ONFlowConfigBuilder *configBuilder = [ONFlowConfig builder];
                [configBuilder withToken:self->token];
                [configBuilder withApplicantId:applicantId];
//                [configBuilder withDocumentStep];
                ONDocumentType type;
                NSString *str = self.dataSource[indexPath.row];
                if ([str isEqualToString:@"national_identity_card"]) {
                    type = ONDocumentTypeNationalIdentityCard;
                } else if ([str isEqualToString:@"driving_licence"]) {
                    type = ONDocumentTypeDrivingLicence;
                } else if ([str isEqualToString:@"residency_permit"]) {
                    type = ONDocumentTypeResidencePermit;
                }  else if ([str isEqualToString:@"passport"]) {
                    type = ONDocumentTypePassport;
                } else {
                    type = ONDocumentTypePassport;
                }
                [configBuilder withDocumentStepOfType:type andCountryCode:self.country];
                [configBuilder withFaceStepOfVariant:ONFaceStepVariantPhoto];
//                [configBuilder withFaceStepOfVariant:ONFaceStepVariantVideo];
                
                NSError *configError = NULL;
                ONFlowConfig *config = [configBuilder buildAndReturnError:&configError];
                
                if (configError == NULL) {
                    
                    ONFlow *flow = [[ONFlow alloc] initWithFlowConfiguration:config];
                    [flow withResponseHandler:^(ONFlowResponse * _Nonnull response) {
                        
                        if (response.error) {
                            
                            if (response.error.code == ONFlowErrorCameraPermission) {
                                NSLog(@"Camera permission denied");
                            } else {
                                NSLog(@"Run error %@", [[response.error userInfo] valueForKey:@"message"]);
                            }
                            
                        } else if (response.userCanceled) {
                            NSLog(@"user canceled flow");
                        } else if (response.results) {
                            
                            cell.accessoryType = UITableViewCellAccessoryCheckmark;
                            
                            for (ONFlowResult *result in response.results) {
                                
                                if (result.type == ONFlowResultTypeDocument) {
                                    ONDocumentResult *docResult = (ONDocumentResult *)(result.result);
                                    
                                    NSLog(@"docResult = %@", docResult);
                                    
                                    /* Document Result
                                     Onfido api response to the creation of the document result
                                     More details: https://documentation.onfido.com/#document-object
                                     */
                                    NSLog(@"%@", docResult.id);
                                } else if (result.type == ONFlowResultTypeFace) {
                                    ONFaceResult *faceResult = (ONFaceResult *)(result.result);
                                    
                                    /* Live Photo / Live Video
                                     Onfido api response to the creation of the live photo / live video
                                     More details: https://documentation.onfido.com/#live-photo-object
                                     */
                                    NSLog(@"faceResult = %@", faceResult);

                                    NSLog(@"%@", faceResult.id);
                                }
                            }
                            
                            self.hasSuccessCount +=1;
                            if (self.hasSuccessCount == self.dataSource.count) {
                                [self pushToProcessingVC];
                            }
                        }
                    }];
                    
                    NSError *runError = NULL;
                    UIViewController *flowVC = [flow runAndReturnError:&runError];
                    
                    if (runError == NULL) {
                        [self presentViewController:flowVC animated:YES completion:nil];
                    } else {
                        NSLog(@"Run error %@", [[runError userInfo] valueForKey:@"message"]);
                    }
                } else {
                    NSLog(@"Config error %@", [[configError userInfo] valueForKey:@"message"]);
                }
            }
        }];
        
    }
}

- (void)pushToProcessingVC {
    WKProcessingVC *vc = [[WKProcessingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - onfido-Method

/**
 Creates applicant, return NULL if unable to create
 */
- (void)createApplicant: (void(^)(NSString *))onResponse {
    
    MBProgressHUD *progressDisplay = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressDisplay.label.text = @"Creating applicant";
    
    NSDictionary *parameters = @{@"first_name":@"Frank", @"last_name":@"Abagnale"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    NSString *tokenHeaderValue = [NSString stringWithFormat:@"Token token=%@", self->token];
    [manager.requestSerializer setValue:tokenHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager POST:@"https://api.onfido.com/v2/applicants"
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [progressDisplay removeFromSuperview];
              self.country = responseObject[@"country_name"];
              onResponse([responseObject valueForKey:@"id"]);
              
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [progressDisplay removeFromSuperview];
              NSLog(@"failed to create applicant");
              onResponse(NULL);
          }];
}




#pragma mark - get

- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView  alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
        _mainTV.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
        _mainTV.sectionIndexColor =[UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1.0];
        _mainTV.sectionIndexBackgroundColor=[UIColor clearColor];
        [_mainTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        _mainTV.tableHeaderView = self.headerView;
    }
    return _mainTV;
}

- (WKLevelTwoHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WKLevelTwoHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)];
    }
    
    return _headerView;
}



@end
