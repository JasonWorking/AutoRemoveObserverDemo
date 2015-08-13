//
//  NSObject+Utils.m
//
//  Created by Jason on 14-9-8.
//  Copyright (c) 2014年 Jason. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>

@implementation NSObject(plugin_performs)
- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}
- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

- (void)performBlockOnMainThread:(void (^)(void))block
{
    [self performSelectorOnMainThread:@selector(fireBlockOnMainThread:)
                           withObject:block
                        waitUntilDone:NO];
}

- (void)fireBlockOnMainThread:(void (^)(void))block {
    block();
}


- (void)performBlockInBackground:(void (^)(void))block
{
    [self performSelectorInBackground:@selector(fireBlockInBackground:) withObject:block];
}

- (void)performBlockInBackground:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(performBlockInBackground:) withObject:block afterDelay:delay];
}

- (void)fireBlockInBackground:(void (^)(void))block {
    block();
}

//- (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg afterDelay:(NSTimeInterval)delay
//{
//    [self performSelector:@selector(fireInBackground:withObject:) withObject:arg afterDelay:delay];
//    
//}

- (void)fireInBackground:(SEL)aSelector withObject:arg
{
    [self performSelectorInBackground:aSelector withObject:arg];
}

- (void)dumpClassMethod:(NSString *)className
{
    id theClass = NSClassFromString(className);
    unsigned int outCount;
    Method *m =  class_copyMethodList(theClass,&outCount);
    
    NSLog(@"%d",outCount);
    for (int i = 0; i<outCount; i++) {
        NSLog(@"%@",NSStringFromSelector(method_getName(*(m+i))));
    }
}

+ (BOOL)swizzleMethodWithOrigSel:(SEL)origSel alterMethodSel:(SEL)alterSel {
    
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method alterMethod = class_getInstanceMethod(self, alterSel);
    
    if (!origMethod || !alterMethod) return NO;
    
	class_addMethod(self,
					origSel,
					class_getMethodImplementation(self, origSel),
					method_getTypeEncoding(origMethod));
	class_addMethod(self,
					alterSel,
					class_getMethodImplementation(self, alterSel),
					method_getTypeEncoding(alterMethod));
    
    origMethod = class_getInstanceMethod(self, origSel);
    alterMethod = class_getInstanceMethod(self, alterSel);
    method_exchangeImplementations(origMethod,alterMethod);
    
    return YES;
}


- (NSString *)className
{
    return NSStringFromClass(self.class);
}

@end
