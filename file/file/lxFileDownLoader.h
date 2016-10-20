//
//  lxFileDownLoader.h
//  file
//
//  Created by ee on 16/10/20.
//  Copyright © 2016年 ee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lxFileDownLoader : NSObject
{
    BOOL _downLoading;
}
/**
 *  文件下载地址
 */
@property(nonatomic,copy)NSString *url;

/**
 *  文件下载路径
 */
@property(nonatomic,copy)NSString *destPath;
/**
 *  文件是否正在下载
 */
@property (nonatomic,readonly,getter=isDownLoading) BOOL downLoading;

/**
 *  文件下载进度
 */
@property(nonatomic,copy)void (^progressHandler)(double progress);

/**
 *  开始下载
 */
-(void)start;
/**
 *  暂停下载
 */
-(void)pause;
@end
