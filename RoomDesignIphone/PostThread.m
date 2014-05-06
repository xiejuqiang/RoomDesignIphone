//
//  PostThread.m
//  AiGuoZhe
//
//  Created by Tang silence on 13-7-31.
//  Copyright (c) 2013年 Tang silence. All rights reserved.
//

#import "PostThread.h"


@implementation PostThread
@synthesize controller;


- (void)main{
//    NSURL *url=[NSURL URLWithString:obj.postUrl];//建立URL
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    NSString *returnString;
    switch (1) {
        case 1://加入购物车
        {
//            [request setPostValue:obj.goods_id forKey:@"goods_id"];
//            [request setPostValue:obj.goods_number forKey:@"number"];
//            [request setPostValue:@"1" forKey:@"quick"];
//            [request setPostValue:obj.speIdStr forKey:@"spec"];
//            
//            [request startSynchronous];
//            NSError *error = [request error];
//            if(!error)
//            {
//                returnString = [request responseString];
//                ((ProductDetailViewController *)controller).returnString = returnString;
//                [(ProductDetailViewController *)controller performSelectorOnMainThread:@selector(postResult) withObject:nil waitUntilDone:NO];
//                NSLog(@"returnString %@",returnString);
//            }
//            else {
//                NSLog(@"error %@",error);
//                ((ProductDetailViewController *)controller).returnString = @"網絡連接超時，請檢查您的網絡";
//                [(ProductDetailViewController *)controller performSelectorOnMainThread:@selector(postFail) withObject:nil waitUntilDone:NO];
//            }
        }
    }
}

@end
