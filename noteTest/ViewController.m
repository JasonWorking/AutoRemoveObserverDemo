//
//  ViewController.m
//  noteTest
//
//  Created by Jason on 15/8/14.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "ViewController.h"
#import "ClassFoo.h"
#import "NSNotificationCenter+Add.h"

@interface ViewController ()
//注释掉这行, 也不会crash哦～ 
@property (nonatomic, strong) ClassFoo *foo;
@end

static NSString *const kNoteNameTest = @"NoteNameTest";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ClassFoo *foo = [[ClassFoo alloc] init];
    [[NSNotificationCenter defaultCenter] ap_addObserver:foo selector:@selector(noteCome:) name:kNoteNameTest object:nil];
    self.foo = foo;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoteNameTest object:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
