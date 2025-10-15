//
//  CNLiveScanResultController.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveScanResultController.h"
#import "QMUIKit.h"
#import "CNLiveCategory.h"

#import "CNLiveNavigationBar.h"
#import "CNLiveWebView.h"

@interface CNLiveScanResultController () <CNLiveWebViewDelegate>
@property (nonatomic, strong) CNLiveNavigationBar *navigationBar;
@property (nonatomic, strong) CNLiveWebView *webView;

@end

@implementation CNLiveScanResultController
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubView];

    if ([self.jump_URL hasPrefix:@"http://"]||[self.jump_URL hasPrefix:@"https://"]) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jump_URL]]];

    } else {
        [_webView loadHTMLString:[self html:self.jump_URL]];
    }
}

- (NSString *)html:(NSString *)url{
    return [NSString stringWithFormat:@"<div style=\"font-size:40px\">%@</div>",url];
}

- (void)setupSubView {
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.webView];
}

#pragma mark - 代理
- (void)webView:(CNLiveWebView *)webView didFinishLoadWithURL:(NSURL *)url {
    NSLog(@"didFinishLoad");
    if(webView.title.length != 0){
        self.navigationBar.title.text = webView.title;
    }else{
        self.navigationBar.title.text = @"识别结果";

    }

}

- (void)webView:(CNLiveWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - 懒加载
- (CNLiveNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [CNLiveNavigationBar navigationBar];
        __weak typeof(self) weakSelf = self;
        _navigationBar.onClickLeftButton = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
             if(!strongSelf) return ;
            [strongSelf goBack];
        };
        
    }
    return _navigationBar;
}

- (CNLiveWebView *)webView {
    if (!_webView) {
        _webView = [CNLiveWebView webViewWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - 响应方法
- (void)goBack {
    if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
