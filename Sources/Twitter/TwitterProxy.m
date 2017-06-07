//
//  TwitterProxy.m
//  Diplomat
//
//  Created by tl on 2017/6/7.
//  Copyright © 2017年 Cloud Dai. All rights reserved.
//

#import "TwitterProxy.h"
static NSString * const kTwitterErrorDomain = @"twitter_error_domain";
NSString * const kDiplomatTypeTwitter = @"diplomat_twitter";
@interface TwitterProxy()
@property (copy, nonatomic) DiplomatCompletedBlock block;
@end
@implementation TwitterProxy
#pragma mark DiplomatProxyProtocol
+ (id<DiplomatProxyProtocol> __nonnull)proxy
{
    return [[TwitterProxy alloc] init];
}

+ (void)load
{
    [[Diplomat sharedInstance] registerProxyObject:[[TwitterProxy alloc] init] withName:kDiplomatTypeTwitter];
}

- (void)registerWithConfiguration:(NSDictionary * __nonnull)configuration
{
//    [FBSDKSettings setAppID:configuration[kDiplomatAppIdKey]];
//    [FBSDKSettings setClientToken:configuration[kDiplomatAppSecretKey]];
    
}
- (void)auth:(DiplomatCompletedBlock)completedBlock
{
    self.block = completedBlock;
    
    
}

-(void)share:(DTMessage *)message completed:(DiplomatCompletedBlock)compltetedBlock{
    
}

-(BOOL)isInstalled{
    return NO;
}

- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
//    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
    return YES;
}
#endif

#pragma mark ---
@end
