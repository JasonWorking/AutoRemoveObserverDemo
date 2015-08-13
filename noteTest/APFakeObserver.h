//
//  APFakeObserver.h
//  noteTest
//
//  Created by Jason on 15/8/14.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBSingleton.h"
@interface APFakeObserver : NSObject

DEF_SINGLETON

- (void)fake_addObserver:(id)observer
              selector:(SEL)aSelector
                  name:(NSString *)aName
                object:(id)anObject;

- (void)middleMan:(NSNotification *)note;


@end
