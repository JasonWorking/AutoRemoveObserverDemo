//
//  NSNotificationCenter+Add.m
//  noteTest
//
//  Created by Jason on 15/8/14.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "NSNotificationCenter+Add.h"
#import "NSObject+Utils.h"
#import "APFakeObserver.h"

@implementation NSNotificationCenter (AutoRemoveObserver)


//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleMethodWithOrigSel:@selector(addObserver:selector:name:object:) alterMethodSel:@selector(ap_addObserver:selector:name:object:)];
//    });
//}

- (void)ap_addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject{
        APFakeObserver *fakeObserver = [APFakeObserver sharedInstance];
        [fakeObserver fake_addObserver:observer
                              selector:aSelector
                                  name:aName
                                object:anObject];
        [self  addObserver:fakeObserver
                  selector:@selector(middleMan:)
                      name:aName
                    object:anObject];
}



@end
