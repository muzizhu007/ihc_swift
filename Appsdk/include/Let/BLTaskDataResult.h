//
//  TaskDataResult.h
//  Let
//
//  Created by yzm on 16/5/17.
//  Copyright © 2016年 BroadLink Co., Ltd. All rights reserved.
//

#import "BLBaseResult.h"
#import "BLStdData.h"

@interface BLTaskDataResult : BLBaseResult

/**
 Task control data object
 */
@property (nonatomic, strong, getter=getData) BLStdData *data;

@end
