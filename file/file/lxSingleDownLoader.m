//
//  lxSingleDownLoader.m
//  file
//
//  Created by ee on 16/10/20.
//  Copyright © 2016年 ee. All rights reserved.
//

#import "lxSingleDownLoader.h"

@interface lxSingleDownLoader()<NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSURLConnection *conn;

@property (nonatomic,strong) NSFileHandle *handler;

@property (nonatomic,assign) long long currentLength;
@end
@implementation lxSingleDownLoader

-(NSFileHandle *)handler
{
    if (_handler == nil) {
        _handler =[NSFileHandle fileHandleForWritingAtPath:self.destPath];
    }
    return _handler;
}

-(void)start
{
    NSURL *url = [NSURL URLWithString:self.url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *value = [NSString stringWithFormat:@"bytes = %lld-%lld",self.begin+self.currentLength,self.end];
    [request setValue:value forHTTPHeaderField:@"Range"];
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
    _downLoading = YES;
}

-(void)pause
{
    [self.conn cancel];
    self.conn = nil;
    _downLoading = NO;
}

#pragma mark ---NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.handler seekToFileOffset:self.begin+self.currentLength];
    [self.handler writeData:data];
    self.currentLength += data.length;
    double progress = (double)self.currentLength/(self.end - self.begin);
    if (self.progressHandler) {
        self.progressHandler(progress);
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.currentLength  = 0 ;
    [self.handler closeFile];
    self.handler = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
@end












