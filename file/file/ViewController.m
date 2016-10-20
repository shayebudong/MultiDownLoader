//
//  ViewController.m
//  file
//
//  Created by ee on 16/10/20.
//  Copyright © 2016年 ee. All rights reserved.
//

#import "ViewController.h"
#import "lxMultiDownLoaders.h"
@interface ViewController ()
@property (nonatomic,strong) lxMultiDownLoaders *multiDowenLoaders;
@end

@implementation ViewController

-(lxMultiDownLoaders *)multiDowenLoaders
{
    if (_multiDowenLoaders == nil) {
        _multiDowenLoaders = [[lxMultiDownLoaders alloc]init];
        
        //设置下载的路径
        _multiDowenLoaders.url = @"http://www.baidu.com";
        
        //设置下载的文件保存路径
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filepath = [caches stringByAppendingPathComponent:@"jre.zip"];
        NSLog(@"%@",filepath);
        _multiDowenLoaders.destPath = filepath;
    }
    return _multiDowenLoaders;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.multiDowenLoaders start];
}
@end
