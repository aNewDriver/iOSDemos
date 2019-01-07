//
//  WKBaseWebViewController.m
//  iOSDemos
//
//  Created by Ke Wang on 2018/10/24.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//





#import "WKBaseWebViewController.h"
#import <WebKit/WebKit.h>

typedef enum : NSUInteger {
    BaseWebViewRequestType_url,
    BaseWebViewRequestType_HTML
} BaseWebViewRequestType;



@interface WKBaseWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, weak) CALayer *progressLayer; //!< 进度条
@property (nonatomic, assign) BaseWebViewRequestType baseWebViewRequestType;


@end

@implementation WKBaseWebViewController

#pragma mark - initation

- (instancetype)init 
{
    if (self == [super init]) {
        
    }
    return self;
}

- (instancetype)initWithUrlString:(NSString *)urlString {
    if (self = [super init]) {
        self.urlString = urlString;
        self.baseWebViewRequestType = BaseWebViewRequestType_url;
    }
    return self;
}

- (instancetype)initWithHTMLString:(NSString *)HTMLString {
    if (self = [super init]) {
        self.HTMLString = HTMLString;
        self.baseWebViewRequestType = BaseWebViewRequestType_HTML;
    }
    return self;
}

- (void)dealloc {
    
//    [self removeObserver:self.webView forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self initationProgressView]; //!< 初始化进度条
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil]; //!< 监听进度
    if (self.baseWebViewRequestType == BaseWebViewRequestType_url) {
        [self loadUrlString];
    } else {
        [self loadHTML];
    }
    // Do any additional setup after loading the view.
}

- (void)initationProgressView {
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT_iOS7, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;
}
#pragma mark - setMethod

- (void)setUrlString:(NSString *)urlString {
    if ([_urlString isEqualToString:urlString]) {
        return;
    }
    _urlString = urlString;
    [self loadUrlString];
}

- (void)setHTMLString:(NSString *)HTMLString {
    if ([_HTMLString isEqualToString:HTMLString]) {
        return;
    }
    _HTMLString = HTMLString;
    [self loadHTML];
}

#pragma mark - method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    self.progressLayer.opacity = 1;
    if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
        return;
    }
    self.progressLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
    if ([change[@"new"] floatValue] == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressLayer.opacity = 0;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
        });
        } else{
//            [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        };
}

- (void)loadUrlString {
    if (!self.urlString) {
        return;
    }
    if ([self.webView isLoading]) { //!< 先取消当前loading
        [self.webView stopLoading];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f]];
}

- (void)loadHTML {
    if (!self.HTMLString) {
        return;
    }
    if ([self.webView isLoading]) { //!< 先取消当前loading
        [self.webView stopLoading];
    }
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *basePath = [NSString stringWithFormat:@"%@/htmls",mainBundlePath]; //!< 获取htmls文件夹目录
    NSURL *BASEURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html",basePath, self.HTMLString];//目标 文件路径
    NSError *error ;
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];//把html文件转换成string类型
    if (htmlString) {
       [self.webView loadHTMLString:htmlString baseURL:BASEURL];
    }
    
}

#pragma mark - NAVDelegate

// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    self.title = webView.title;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",webView);
    NSLog(@"%@",navigationResponse);
    
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    self.title = webView.title;
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    if (navigationAction.navigationType==WKNavigationTypeBackForward) {//判断是返回类型
        
//        同时设置返回按钮和关闭按钮为导航栏左边的按钮 这里可以监听左滑返回事件，仿微信添加关闭按钮。
//        可以在这里找到指定的历史页面做跳转
            if (webView.backForwardList.backList.count>0) {                                  //得到栈里面的list
                NSLog(@"%@",webView.backForwardList.backList);
                NSLog(@"%@",webView.backForwardList.currentItem);
                WKBackForwardListItem * item = webView.backForwardList.currentItem;          //得到现在加载的list
                for (WKBackForwardListItem * backItem in webView.backForwardList.backList) { //循环遍历，得到你想退出到
                    //添加判断条件
                    [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
                }
            }
    }
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

#pragma mark - UIDelegate 用于JS交互

//显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"弹窗alert");
    NSLog(@"%@",message);
    NSLog(@"%@",frame);
    completionHandler();
}

//弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    NSLog(@"弹窗输入框");
    NSLog(@"%@",prompt);
    NSLog(@"%@",defaultText);
    NSLog(@"%@",frame);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //这里必须执行不然页面会加载不出来
        completionHandler(@"");
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",
             [alert.textFields firstObject].text);
        completionHandler([alert.textFields firstObject].text);
    }];
    [alert addAction:a1];
    [alert addAction:a2];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"%@",textField.text);
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    NSLog(@"弹窗确认框");
    NSLog(@"%@",message);
    NSLog(@"%@",frame);
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - get

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        //开了支持滑动返回
        _webView.allowsBackForwardNavigationGestures = YES;

    }
    return _webView;
}


@end
