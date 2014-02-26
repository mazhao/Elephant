//
//  MZAppDelegate.m
//  Elephant
//
//  Created by mazhao on 13-11-26.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZAppDelegate.h"

#import "MobClick.h"
#import "UMSocial.h"


#import "MZBookStoreAPI.h"

#import "MHWCoreDataController.h"

#import "Config.h"


@implementation MZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    NSLog(@"ios 应用发布后 .app 应用文件 路径::%@",[NSBundle mainBundle] );
    NSLog(@"ios 应用发布后 .app 应用包(文件) 的详细信息 ::%@",[[NSBundle mainBundle] infoDictionary]);
    
    
    // 友盟统计
    [MobClick startWithAppkey:kUMKey reportPolicy:REALTIME channelId:@"Beta"];
    [MobClick setLogSendInterval:60];

    // 友盟社会化分享
    
    [UMSocialData setAppKey:kUMKey];
    
    [UMSocialConfig setWXAppId:kWeiXinKey url:kWeiXinShareUrl];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    
    [UMSocialConfig setSupportSinaSSO:YES];
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.title = @"大象书摘，快乐分享~";
    
//    [UMSocialData openLog:YES];

    
    // 初始化必要的类
    self.imageCache = [SDImageCache.alloc initWithNamespace:@"mzbookstoreimg"];
    self.bookStore = [MZBookStoreFactory initBookStoreOfType:kBookStoreCoreData];
    
    // 检查CoreData数据库是否需要升级
    
//    MHWCoreDataController * coreDataCtrl = [MHWCoreDataController sharedInstance];
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource: [self.bookStore modelName ] withExtension:[self.bookStore modelExtension ]];
//
//    if ( [coreDataCtrl isMigrationNeededOfStoreURL:modelURL ofType: NSSQLiteStoreType forNewModel: [self.bookStore managedObjectModel] ]) {
//        NSLog(@"need migration");
//    } else {
//        NSLog(@"no need migration");
//    }
    
    
    
    UIColor *mainColor =[UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    
    //[[UINavigationBar appearance] setBackgroundColor: mainColor];
    [[UINavigationBar appearance] setBarTintColor:mainColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Override point for customization after application launch.
    return YES;
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
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


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
