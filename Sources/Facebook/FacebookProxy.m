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
static NSString * const kFacebookErrorDomain = @"facebook_error_domain";
NSString * const kDiplomatTypeFacebook = @"diplomat_facebook";
@interface FacebookProxy()
@property (copy, nonatomic) DiplomatCompletedBlock block;
@end
@implementation FacebookProxy
#pragma mark DiplomatProxyProtocol
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
    
}
- (void)auth:(DiplomatCompletedBlock)completedBlock
{
    self.block = completedBlock;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];

    [login logInWithReadPermissions:nil
                 fromViewController:nil
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error || result.isCancelled) {
                                    !self.block?:self.block(nil, [NSError errorWithDomain:kFacebookErrorDomain code:-1024 userInfo:@{NSLocalizedDescriptionKey:@"取消授权"}]);
                                }else{
                                    [FBSDKAccessToken setCurrentAccessToken:result.token];
                                    [self getUserInfo];
                                }
                            }];

}

-(void)share:(DTMessage *)message completed:(DiplomatCompletedBlock)compltetedBlock{

}

-(BOOL)isInstalled{
    return NO;
}

- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
- (BOOL)handleApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
}
#endif

#pragma mark ---
-(void)getUserInfo{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  
                                  initWithGraphPath:[FBSDKAccessToken currentAccessToken].userID
                                  parameters:@{@"fields":@"id,name,link,gender,birthday,email,picture,locale,updated_time,timezone,age_range,first_name,last_name"}
                                  
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          
                                          id result,
                                          
                                          NSError *error) {
        DTUser *dtUser = nil;
        if (result[@"id"])
        {
            dtUser = [[DTUser alloc] init];
            dtUser.uid = result[@"id"];
            dtUser.gender = result[@"gender"];
            dtUser.nick = result[@"name"];
            if ([result[@"picture"] isKindOfClass:[NSDictionary class]] &&
                [result[@"picture"][@"data"] isKindOfClass:[NSDictionary class]]) {
                dtUser.avatar = result[@"picture"][@"data"][@"url"];
            }
            dtUser.provider = @"facebook";
            dtUser.rawData = result;
        }
        !self.block?:self.block(dtUser,error);
        
    }];
}

@end
