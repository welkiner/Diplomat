//
//  TwitterProxy.m
//  Diplomat
//
//  Created by tl on 2017/6/7.
//  Copyright © 2017年 Cloud Dai. All rights reserved.
//

#import "TwitterProxy.h"
#import "TwitterKit/TwitterKit.h"
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
    [[Twitter sharedInstance] startWithConsumerKey:configuration[kDiplomatAppIdKey] consumerSecret:configuration[kDiplomatAppSecretKey]];
}
- (void)auth:(DiplomatCompletedBlock)completedBlock
{
    self.block = completedBlock;
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    
}

-(void)share:(DTMessage *)message completed:(DiplomatCompletedBlock)compltetedBlock{
    
}

-(BOOL)isInstalled{
    return NO;
}

//SDK规定了必须iOS9以上，该方法并不会调用
- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return YES;
}

- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [[Twitter sharedInstance] application:application openURL:url options:options];
}

#pragma mark ---
@end
