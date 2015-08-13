//
//  APFakeObserver.m
//  noteTest
//
//  Created by Jason on 15/8/14.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "APFakeObserver.h"
#import "LBWeakList.h"

@interface APFakeObserver  ()

@property (nonatomic, strong) NSMutableDictionary *observerMap;
@property (nonatomic, strong) NSMutableDictionary *selMap;
@end

@implementation APFakeObserver

IMP_SINGLETON

- (instancetype)init
{
    self =  [super init];
    if (self) {
        _observerMap = [NSMutableDictionary dictionary];
        _selMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}



- (void)fake_addObserver:(id)observer
                selector:(SEL)aSelector
                    name:(NSString *)aName
                  object:(id)anObject;
{
    if (!observer || !aSelector) {
        return;
    }
    
    LBWeakList *list = self.observerMap[aName];
    if (!list) {
        list  = [[LBWeakList alloc] init];
        self.observerMap[aName] = list;
    }
    [list addObject:observer];
    
    NSString *selName = NSStringFromSelector(aSelector);
    NSString *selectorKey = [NSString stringWithFormat:@"%@-%p",aName,observer];
    self.selMap[selectorKey] = selName;
}


- (void)middleMan:(NSNotification *)note
{
    if (!note || !note.name || !note.name.length) {
        return;
    }
    LBWeakList *observerList = self.observerMap[note.name];
    [observerList forEach:^(id object) {
        NSString *selectorKey = [NSString stringWithFormat:@"%@-%p",note.name,object];
        NSString *selName = self.selMap[selectorKey];
        SEL sel = NSSelectorFromString(selName);
        if (object && [object respondsToSelector:sel]) {
            NSMethodSignature *msig = [object methodSignatureForSelector:sel];
            if (msig != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                NSUInteger nargs = [msig numberOfArguments];
                if (nargs == 2) { // 0 non-hidden arguments
                    [object performSelector:sel];
                }
                else if (nargs == 3) { // 1 non-hidden argument
                    [object performSelector:sel withObject:note];
                }
                else {
                    NSAssert(NO, @"too many arguments");
                }
#pragma clang diagnostic pop
            }

        }
    }];
    
}


@end
