//
//  JsonParser.m
//  MainFrame
//
//  Created by Tang silence on 13-7-2.
//  Copyright (c) 2013年 Tang silence. All rights reserved.
//

#import "JsonParser.h"

@implementation JsonParser
@synthesize itemData = _itemData;
@synthesize isWY = _isWY;

- (id) init{
	self = [super init];
	if (self) {
		success = NO;
		loading = NO;
		parsed = NO;
	}
	return self;
}
-(BOOL)isHaveFlag:(NSString *)returnString
{
    NSRange tRange = [returnString rangeOfString:@"\"flag\":" options:NSCaseInsensitiveSearch];
    if(tRange.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

//得到数组的信息
- (id)getItems
{
    if (_isWY) 
        return returnWY;
    else
        return returnDic;
}

- (void)parse:(NSString *)url withDelegate:(id)sender onComplete:(SEL)callback onErrorComplete:(SEL) errorCallBack onNullComplete:(SEL)nullCallBack
{
    parentDelegate = sender;
    onCompleteCallback = callback;
    onErrorCompleteCallback = errorCallBack;
    onNullCompleteCallback = nullCallBack;
    requestUrl = url;
    loading = YES;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[[NSURL alloc] initWithString:requestUrl]];
    [request setHTTPMethod:@"GET"];
    request.timeoutInterval = 10;
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    id result = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"result %@",result);
    
     _itemData = [NSMutableData data];
}

#pragma mark NSURLConnection delegate methods
//当xml被接收的时候，进行连接
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        //  NSLog(@"RSSParser: Response is an NSHTTPURLResponse: Response=%d",[httpResponse statusCode]);
        
		if ([httpResponse statusCode] >= 400 && [httpResponse statusCode] <= 599) {
            success = NO;
        } else if([httpResponse statusCode] >= 100 && [httpResponse statusCode] <= 299) {
            success = YES;
        } else {
            // NSLog(@"RSSParser: Status code is unknown.");
        }
		
    }
	
}

//添加数据里面的信息内容
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_itemData appendData:data];
}
//连接之后进行的操作
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([_itemData isEqualToData:[@"null" dataUsingEncoding:NSUTF8StringEncoding]] == NO)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        returnDic = [NSJSONSerialization JSONObjectWithData:_itemData
                                                             options:NSJSONReadingAllowFragments error:nil];
         returnWY = [[NSMutableString alloc] initWithData:_itemData encoding:NSUTF8StringEncoding];
//        NSLog(@"returnDic %@",returnDic);
        if(returnDic != nil)
        {
            if([returnDic count] >0)
            {
                if ([parentDelegate respondsToSelector:onCompleteCallback]) {
                    SuppressPerformSelectorLeakWarning(
                                                       [parentDelegate performSelector:onCompleteCallback withObject:self];
                                                       );
                }
            }
            else
            {
                if ([parentDelegate respondsToSelector:onNullCompleteCallback]) {
                    SuppressPerformSelectorLeakWarning(
                                                       [parentDelegate performSelector:onNullCompleteCallback withObject:self];
                                                       );
                }
            }
        }
    }
    else
    {
        if ([parentDelegate respondsToSelector:onNullCompleteCallback]) {
            SuppressPerformSelectorLeakWarning(
                                               [parentDelegate performSelector:onNullCompleteCallback withObject:self];
                                               );
        }
    }
}

//连接报错
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    success = NO;
    loading = NO;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    [parentDelegate performSelector:onErrorCompleteCallback withObject:self];
//#pragma clang diagnostic pop
    if ([parentDelegate respondsToSelector:onErrorCompleteCallback]) {
        SuppressPerformSelectorLeakWarning(
                                           [parentDelegate performSelector:onErrorCompleteCallback withObject:self];
                                           );
    }
    NSLog(@"error %@",error);
}

//连接身份认证
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    success = NO;
}

@end
