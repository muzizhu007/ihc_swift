//
//  BLOauthResult.h
//  Let
//
//  Created by zhujunjie on 2017/8/1.
//  Copyright © 2017年 BroadLink Co., Ltd. All rights reserved.
//

#import "BLBaseResult.h"

@interface BLOauthResult : BLBaseResult

@property (nonatomic, copy) NSString *accessToken;
/** Access Token的失效期 */
@property(nonatomic, copy) NSDate* expirationDate;

@end
