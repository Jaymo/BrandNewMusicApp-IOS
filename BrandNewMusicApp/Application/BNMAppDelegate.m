//
//  BNMAppDelegate.m
//  BrandNewMusicApp
//

#import "BNMAppDelegate.h"
#import "BNMTabsViewController.h"


@implementation BNMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
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

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DEVICETOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
            
    NSLog(@"My token is: %@", token);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"userInfo %@",userInfo);
    UIAlertView *pushAlertView = [[UIAlertView alloc] initWithTitle:@"Notification" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [pushAlertView show];
    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

#pragma mark
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    if ([navigationController.topViewController isKindOfClass:[BNMTabsViewController class]]) {
        [(BNMTabsViewController *)navigationController.topViewController viewDidLoad];
        
    }
    
    else {
        
        BOOL isTabViewControllerInStack = NO;
        
        for (int i = 0; i < navigationController.viewControllers.count; i++)
        {
            UIViewController *vc = navigationController.viewControllers[i];
            if ([vc isKindOfClass:[BNMTabsViewController class]])
            {
                isTabViewControllerInStack = YES;
                [navigationController popToViewController:vc animated:YES];
                
                break;
            }
        }
        
        if (!isTabViewControllerInStack) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard"
                                                                     bundle: nil];
            
            BNMTabsViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"BNMTabsViewController"];
            [navigationController pushViewController:controller animated:YES];
            
        }


    }

    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to

    return YES;
}



@end
