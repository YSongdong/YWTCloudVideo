//
//  YWTMapViewController.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/13.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTMapViewController.h"
#import <WebKit/WebKit.h>

#import "YWTLineDetailController.h"
#import "YWTNaviViewController.h"
@interface YWTMapViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,strong) WKWebView *wkWebView;
// 加载提示框
@property (nonatomic,strong)  MBProgressHUD *HUD;
@end

@implementation YWTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    // 设置Navi
    [self setNavi];
    // 创建WKWebView
    [self createWKWebView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
#pragma mark - WKScriptMessageHandler ------
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    // 跳转到线路详情页面
    if ([message.name isEqualToString:@"CallWebToAppOpenTowerDetail"]) {
        NSDictionary *dict = message.body;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        YWTTabBarViewController *tabbar = (YWTTabBarViewController*)appDelegate.window.rootViewController;
        tabbar.selectedIndex = 1;
        YWTNaviViewController *navi = (YWTNaviViewController*)tabbar.childViewControllers[1];
        YWTLineDetailController *lineDateVC = [[YWTLineDetailController alloc]init];
        lineDateVC.titleStr = [NSString stringWithFormat:@"%@",dict[@"title"]];
        lineDateVC.towerId = [NSString stringWithFormat:@"%@",dict[@"towerId"]];
        [navi pushViewController:lineDateVC animated:YES];
    }
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark ----- WKNavigationDelegate  -------
// 开始加载wkweb
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
   __weak typeof(self)  weakSelf = self;
   dispatch_async(dispatch_get_main_queue(), ^{
      weakSelf.HUD = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
      weakSelf.HUD.bezelView.color =[UIColor colorWithWhite:0 alpha:0.7];
      weakSelf.HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
   });
}
// 加载完成  传值
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
   // 隐藏加载提示框
    __weak typeof(self)  weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.HUD hideAnimated:YES];
    });
}
// 网页由于某些原因加载失败
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    // 隐藏加载提示框
    __weak typeof(self)  weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.HUD hideAnimated:YES];
    });
    [self.view showErrorWithTitle:@"加载失败!"];
}
// 加载失败
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    // 隐藏加载提示框
    __weak typeof(self)  weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.HUD hideAnimated:YES];
    });
    [self.view showErrorWithTitle:@"加载失败!"];
}
// 网页加载内容进程终止
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    // 隐藏加载提示框
    __weak typeof(self)  weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.HUD hideAnimated:YES];
    });
    [self.view showErrorWithTitle:@"加载失败!"];
}
#pragma mark -----提示框 -------
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    completionHandler();
}
// 转换给js 的参数
-(NSString *) getWithJsParamDict:(NSDictionary *)dict{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}
#pragma mark ----- 设置Navi  -----
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title = @"地图";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@""]];
    self.customNavBar.onClickLeftButton = ^{
        
    };
}
#pragma mark - 创建WKWebView ------
-(void) createWKWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"CallWebToAppOpenTowerDetail"];
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH) configuration:config];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.scrollView.bounces = NO;
    [self.view addSubview:self.wkWebView];
    [self requestLoadWkWebData];
}
#pragma mark ---请求数据------
-(void)requestLoadWkWebData{
    NSString *bustUrl = @"http://49.4.30.17:9603/";
    // 将token封装入请求头
    NSString *token = [YWTNowLoginManager judgePassLogin] ? [YWTNowLoginManager shareInstance].loginModel.token : @"";
    NSString *urlStr = [NSString stringWithFormat:@"%@?port_type=%@&token=%@#",bustUrl,@"ios",token];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
}



@end
