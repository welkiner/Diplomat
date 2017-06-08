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
            [self getUserInfo];
        } else {
            !self.block?:self.block(nil, error);
        }
    }];
    
}

-(void)share:(DTMessage *)message completed:(DiplomatCompletedBlock)compltetedBlock{
    
}

-(BOOL)isInstalled{
    return YES;
}

//SDK规定了必须iOS9以上，该方法并不会调用
- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return YES;
}

- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [[Twitter sharedInstance] application:application openURL:url options:options];
}

#pragma mark ---

-(void)getUserInfo{
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    [client loadUserWithID:client.userID completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
        
        DTUser *dtUser = nil;
        NSError *terror = error;
        if (user)
        {
            dtUser = [[DTUser alloc] init];
            dtUser.uid = user.userID;
            dtUser.gender = @"male";
            dtUser.nick = user.name;
            dtUser.avatar = user.profileImageURL;
            dtUser.provider = @"twitter";
            
        }else if (!terror){
            terror = [NSError errorWithDomain:kTwitterErrorDomain code:-1024 userInfo:@{NSLocalizedDescriptionKey: @"获取用户信息失败"}];
        }
        
        !self.block?:self.block(dtUser,terror);
    }];
}
@end
