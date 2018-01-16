//
//  DNAControllerResult.h
//  Let
//
//  Created by yzm on 16/5/19.
//  Copyright © 2016年 BroadLink Co., Ltd. All rights reserved.
//

#import "BLBaseResult.h"

@interface BLDNAControllerResult : BLBaseResult

/**
 Device control send raw data
 */
@property (nonatomic, strong) NSString *sendData;

/**
 Device control receive raw data
 */
@property (nonatomic, strong) NSString *recvData;

/**
 Device control cookie
 */
@property (nonatomic, strong, getter=getCookie) NSString *cookie;

/**
 Device control data
 */
@property (nonatomic, strong, getter=getData) NSDictionary *data;

@end
