//
//  MZAppDelegate.m
//  Elephant
//
//  Created by mazhao on 13-11-26.
//  Copyright (c) 2013年 mz. All rights reserved.
//

#import "MZAppDelegate.h"

#import "MobClick.h"

#import "MZBookStoreAPI.h"

#import "MHWCoreDataController.h"

@implementation MZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"ios 应用发布后 .app 应用文件 路径::%@",[NSBundle mainBundle] );
    
    NSLog(@"ios 应用发布后 .app 应用包(文件) 的详细信息 ::%@",[[NSBundle mainBundle] infoDictionary]);
    
    [MobClick startWithAppkey:@"52ac4dd556240b9353098a52" reportPolicy:REALTIME channelId:@"Beta"];
    [MobClick setLogSendInterval:60];

    
    // 初始化必要的类
    self.imageCache = [SDImageCache.alloc initWithNamespace:@"mzbookstoreimg"];
    self.bookStore = [MZBookStoreFactory initBookStoreOfType:kBookStoreCoreData];
    
    // 检查CoreData数据库是否需要升级
    
    MHWCoreDataController * coreDataCtrl = [MHWCoreDataController sharedInstance];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource: [self.bookStore modelName ] withExtension:[self.bookStore modelExtension ]];

    if ( [coreDataCtrl isMigrationNeededOfStoreURL:modelURL ofType: NSSQLiteStoreType forNewModel: [self.bookStore managedObjectModel] ]) {
        NSLog(@"need migration");
    } else {
        NSLog(@"no need migration");
    }
    
    
    // Override point for customization after application launch.
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
