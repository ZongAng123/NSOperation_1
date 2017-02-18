//
//  ViewController.m
//  NSOperation_1
//
//  Created by Ostrish on 16/7/6.
//  Copyright © 2016年 ZY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     NSOperation：操作类，任务
     //NSOperation是抽象类，不具有封装操作的能力，所以不能使用NSOperation来封装操作，必须使用它的子类
     使用NSOperation子类有三种方式：
     1.NSInvocationOperation
     2.NSBlockOperation
     3.自定NSOperation的子类，实现相应的方法
     */
    //1.创建NSInvocationOperation对象，封装一个操作
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test) object:nil];
    //操作对象默认是在主线程中执行，只有当他加入到queue中才会开启新的线程 --- 即在默认的情况下，如果我们的操作没有放在队列（queue）中它是同步执行，放到队列中才会异步执行
    
    //开启一个操作   默认在主线程执行
//    [operation start];
    
    /**
     同步：在当前线程中执行
     异步：在另一条线程中执行操作， 开启了新线程
     
     并发：多个线程（任务）同时执行
     串行：任务一个接一个的执行
     */
    
    //2.
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2.1 ------------ %@", [NSThread currentThread]);
        for (int i = 0; i < 5; i++) {
            NSLog(@"2.1-------111------- %@", [NSThread currentThread]);
        }
    }];
    //监测线程   当线程执行结束调用
    [blockOperation setCompletionBlock:^{
        NSLog(@"blockOperation ---- 执行完了 %@", [NSThread currentThread]);
    }];
    //添加操作   只要NSBlockOperation他的操作数>1时，它就会开启分线程，异步执行操作
    [blockOperation addExecutionBlock:^{
        NSLog(@"2.2 ------------ %@", [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"2.3 ------------ %@", [NSThread currentThread]);
    }];
    //开启执行操作   --- 默认主线程
//    [blockOperation start];
    
    /**
     NSOperationQueue:队列
     NSOperationQueue:NSOperation调用start默认是在主线程中执行任务，同步执行。如果加入到queue（队列），系统会自动的执行队列中的操作，并且自动的为其开启线程 --- 异步执行
     */
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //设置最大并发数 如果把最大并发数设为1，遵循先入先出原则（FIFO） 此时为串行队列  如果>1为并行（并发）队列
    //建议值：2~3
    queue.maxConcurrentOperationCount = 1;
    [queue addOperationWithBlock:^{
        NSLog(@"3.1 ------------ %@", [NSThread currentThread]);
        for (int i = 0; i < 5; i++) {
            NSLog(@"3.1-------111------- %@", [NSThread currentThread]);
        }
    }];
    
    //添加依赖：先执行operation ---->blockOperation
//    [blockOperation addDependency:operation];
    //不能相互依赖
//    [operation addDependency:blockOperation];
    
    [queue addOperation:blockOperation];
    [queue addOperation:operation];
    
    /**
     配合使用NSOperationQueue和NSOperation
     1.先将需要执行的操作封装成一个NSOperation对象
     2.将NSOperation对象添加到NSOperationQueue中
     3.系统会自动的将NSOperationQueue的NSOperation取出来
     4.将取出来的NSOperation对象（操作）放到一条线程中执行
     */
}

- (void)test {
    NSLog(@"1.-------------- %@", [NSThread currentThread]);
    for (int i = 0; i < 5; i++) {
        NSLog(@"1.-------111------- %@", [NSThread currentThread]);
    }
    
    //回到主线程刷新UI
//    [self performSelectorOnMainThread:<#(nonnull SEL)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>]
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
