//
//  lxMultiDownLoaders.m
//  file
//
//  Created by ee on 16/10/20.
//  Copyright © 2016年 ee. All rights reserved.
//

#import "lxMultiDownLoaders.h"
#import "lxSingleDownLoader.h"

#define lxMaxDownLoaders 4

@interface lxMultiDownLoaders()

@property (nonatomic,strong) NSMutableArray *singleDownLoaders;
@property (nonatomic,assign) long long totalLength;

@end
@implementation lxMultiDownLoaders

-(void)getFilesize
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    request.HTTPMethod = @"HEAD";
   
    
    NSURLResponse *response = nil;
#warning 这里要用异步请求
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    self.totalLength = response.expectedContentLength;
    
}

-(NSMutableArray *)singleDownLoaders
{
    if (_singleDownLoaders == nil) {
        _singleDownLoaders = [NSMutableArray array];
        //获取要下载文件的总长度
        [self getFilesize];
        NSLog(@"%lld", self.totalLength);
        //为每一个下载器均分下载长度（任务量）
        long long size = 0;
        if (self.totalLength %lxMaxDownLoaders == 0) {
            size = self.totalLength/lxMaxDownLoaders;
        }else{
            size = self.totalLength/lxMaxDownLoaders +1;
        }
        for (int i = 0; i < lxMaxDownLoaders; i++) {
            lxSingleDownLoader *single = [[lxSingleDownLoader alloc]init];
            //设置每个下载器的下载路径
            single.url = self.url;
            //设置每个下载器下载的长度
            single.begin = i*size;
            single.end = single.begin +size-1;
            
            //设置每个下载器的目标路径
            single.destPath = self.destPath;
            
            single.progressHandler = ^(double progress){
                
                NSLog(@"%d--- %f",i,progress);
            };

            //将每一个下载器添加到数组里边
            [_singleDownLoaders addObject:single];
        }
        //预先创建一个文件与要下载的文件大小相同
        [[NSFileManager defaultManager]createFileAtPath:self.destPath contents:nil attributes:nil];
        NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:self.destPath];
        [handler truncateFileAtOffset:self.totalLength];
    }
    return _singleDownLoaders;
}

//让下载器开始下载
-(void)start
{
    [self.singleDownLoaders makeObjectsPerformSelector:@selector(start)];
    _downLoading = YES;
}
//让下载器停止下载
-(void)pause
{
    [self.singleDownLoaders makeObjectsPerformSelector:@selector(pause)];
    _downLoading = NO;
}
@end
