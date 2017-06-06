//
//  FacebookProxy.m
//  Diplomat
//
//  Created by tl on 01/06/2017.
//  Copyright © 2017 Cloud Dai. All rights reserved.
//

#import "FacebookProxy.h"
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
NSString * const kDiplomatTypeFacebook = @"diplomat_facebook";
@interface FacebookProxy()
@property (copy, nonatomic) DiplomatCompletedBlock block;
@end
@implementation FacebookProxy

+ (id<DiplomatProxyProtocol> __nonnull)proxy
{
    return [[FacebookProxy alloc] init];
}

+ (void)load
{
    [[Diplomat sharedInstance] registerProxyObject:[[FacebookProxy alloc] init] withName:kDiplomatTypeFacebook];
}

- (void)registerWithConfiguration:(NSDictionary * __nonnull)configuration
{
    [FBSDKSettings setAppID:configuration[kDiplomatAppIdKey]];
    [FBSDKSettings setClientToken:configuration[kDiplomatAppSecretKey]];
    
    NSLog(@"%@",[FBSDKSettings appURLSchemeSuffix]);
}
- (void)auth:(DiplomatCompletedBlock)completedBlock
{
    self.block = completedBlock;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];

    [login logInWithReadPermissions:nil
                 fromViewController:nil
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error || result.isCancelled) {
                                    NSLog(@"aa");
                                }else{
                                    NSLog(@"bb");
                                }
                            }];

}

-(void)share:(DTMessage *)message completed:(DiplomatCompletedBlock)compltetedBlock{

}

-(BOOL)isInstalled{
    return NO;
}
-(BOOL)handleOpenURL:(NSURL *)url{
    BOOL ishandle = [[FBSDKApplicationDelegate sharedInstance] application:nil openURL:url sourceApplication:nil annotation:nil];
    return ishandle;
}
- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
}
#endif
@end
