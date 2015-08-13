//
//  LBWeakList.h
//  noteTest
//
//  Created by Jason on 15/8/14.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface LBWeakRef : NSObject
- (instancetype)initWithObject:(id)object;
@property (weak, readonly) id object;
@end


@interface LBWeakList : NSObject

- (instancetype)init;
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (void)forEach:(void (^)(id object))consumer;

@end
