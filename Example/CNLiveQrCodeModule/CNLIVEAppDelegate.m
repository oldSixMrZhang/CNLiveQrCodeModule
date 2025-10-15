//
//  CNLIVEAppDelegate.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/14/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLIVEAppDelegate.h"
#import "CNLiveMyQrCodeController.h"
#import "CNLiveScanQrCodeController.h"
#import "CNLiveGroupQrCodeController.h"
#import "CNLiveScanResultController.h"
#import "CNLiveGenerateQrCodeController.h"

#import "CNLiveNetworking.h"
#import "CNLiveEnvironment.h"
#import "CNUserInfoManager.h"

@implementation CNLIVEAppDelegate
- (void)networkParamAction{
    NSMutableDictionary * mDict = [[NSMutableDictionary alloc] init];
    [mDict setValue:@"10514405" forKey:@"loginSid"];

    [mDict setValue:BundleId forKey:@"platform_id"];

    [mDict setValue:[[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"uuid"];
    [mDict setValue:@"i" forKey:@"plat"];
    [mDict setValue:@"1.7.8.19.10.30.15"forKey:@"ver"];
    [mDict setObject:AppId forKey:@"appId"];
    [CNLiveNetworking setupDefaultParam:mDict];
    [CNLiveNetworking setupShowResult:NO];
    [CNLiveNetworking setupSignKey:APPKey];
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setResponseSerializerType:CNLiveResponseSerializerJSON];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [CNLiveEnvironmentManager setEnvironment:CNLiveDebugAppStore];
    [self networkParamAction];
    [CNUserInfoManager saveUserinfoDic:@{
        @"bigFaceUrl":@"http://yweb0.cnliveimg.com/images/headImg/2019/1030/1572439148697.jpg",
        @"countryCode":@"86",
        @"email":@"",
        @"extInfo":@"",
        @"faceUrl":@"http://yweb0.cnliveimg.com/images/headImg/2019/1030/1572439148697_small.jpg",
        @"gender":@"m",
        @"hUid":@"",
        @"isNewUser":@"0",
        @"location":@"北京市海淀区",
        @"mobile":@"17600922519",
        @"nickName":@"金帝",
        @"platformId":@"769_jetj7bq525",
        @"qqUid":@"",
        @"renrenUid":@"",
        @"sinaUid":@"",
        @"token":@"RkFYeLkl/u5S7tW8UcOkT3rfLTP/Ua8NIkdEsKlcolvl/yxTMNbAYXmmJyhKGpkj",
        @"uid":@"10514405",
        @"wxUid":@""
    }];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
   
    CNLiveGroupQrCodeController *vc = [[CNLiveGroupQrCodeController alloc] init];
//    vc.ID = @"http://www.baidu.com";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
   
    self.window.rootViewController = nav;//设置根视图控制器
   
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
