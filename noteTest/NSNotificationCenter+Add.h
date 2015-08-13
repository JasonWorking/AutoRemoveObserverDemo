//
//  NSNotificationCenter+Add.h
//  noteTest
//
//  Created by Jason on 15/8/14.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (AutoRemoveObserver)

- (void)ap_addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;

@end
