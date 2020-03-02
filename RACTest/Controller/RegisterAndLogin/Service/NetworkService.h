//
//  NetworkService.h
//  RACTest
//
//  Created by mzl on 2020/3/2.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject
@property (nonatomic,copy) NSString *returnCode;
@property (nonatomic,strong) id result;

@end

NS_ASSUME_NONNULL_END
