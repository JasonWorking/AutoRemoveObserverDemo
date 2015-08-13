//
//  NSObject+Utils.h
//
//  Created by Jason on 14-9-8.
//  Copyright (c) 2014年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(plugin_performs)

//给performSelectorXXX增加block操作

- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay;

- (void)performBlockOnMainThread:(void (^)(void))block;

//- (void)performSelectorInBackground:(SEL)aSelector
//                         withObject:(id)arg
//                         afterDelay:(NSTimeInterval)delay;

- (void)performBlockInBackground:(void (^)(void))block;

- (void)performBlockInBackground:(void (^)(void))block
                      afterDelay:(NSTimeInterval)delay;

- (void)dumpClassMethod:(id)obj;
+ (BOOL)swizzleMethodWithOrigSel:(SEL)origSel alterMethodSel:(SEL)alterSel;

- (NSString*)className;
@end
