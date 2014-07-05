////
////  SessionModel.m
////  PartyApp
////
////  Created by Varun on 29/06/2014.
////  Copyright (c) 2014 WebFactory. All rights reserved.
////
//
//#import "SessionModel.h"
//#import "RequestBuilder.h"
//#import "ServerConnection.h"
////#import "Base64Transcoder.h"
//#import <CommonCrypto/CommonCrypto.h>
//
//@implementation SessionModel
//
//- (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
//{
//    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
//    
//    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
//    
//    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    
//    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
//    
//    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
//    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
//    
//    for (int i = 0; i < HMACData.length; ++i)
//        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)buffer[i]];
//    
//    return HMAC;
//}
//
//- (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
//    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
//    unsigned char result[20];
//	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
//    
//    char base64Result[32];
//    size_t theResultLength = 32;
//    Base64EncodeData(result, 20, base64Result, &theResultLength);
//    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
//    
//    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
//    
//    return base64EncodedResult;
//}
//
//- (NSString *)generateSignatureWithText:(NSData *)data andKey:(NSString *)secret {
//    
//    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *clearTextData = data;
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
//    CCHmacContext hmacContext;
//    CCHmacInit(&hmacContext, kCCHmacAlgSHA1, secretData.bytes, secretData.length);
//    CCHmacUpdate(&hmacContext, clearTextData.bytes, clearTextData.length);
//    CCHmacFinal(&hmacContext, digest);
//    NSData *result = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
//    NSString *hash = [result description];
//    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
//    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
//    
//    return hash;
//    
//}
//
//- (void)fetchSessionInfo {
//    
//    NSString *strPost = nil;
//    
//    NSString *strNonceValue = [NSString stringWithFormat:@"%d", arc4random() % 1000000];
//    NSString *timeStampValue = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//    
//    NSString *applicationID = [NSString stringWithFormat:@"%d", _pApplicationID];
//    
//    NSMutableDictionary *dictSessionInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                            applicationID, @"application_id",
//                                            _pAuthorizationKey, @"auth_key",
//                                            timeStampValue, @"timestamp",
//                                            strNonceValue, @"nonce", nil];
//    NSData *dataVal = [NSJSONSerialization dataWithJSONObject:dictSessionInfo options:NSJSONReadingAllowFragments error:nil];
//    //    NSString *hmacSign = [self hmac:[dictSessionInfo description] withKey:_pAuthorizationKey];
//    //    NSString *hmacSign = [self hmacsha1:[dictSessionInfo description] key:_pAuthorizationKey];
//    NSString *signature = [self generateSignatureWithText:dataVal andKey:_pAuthorizationKey];
//    [dictSessionInfo setObject:signature forKey:@"signature"];
//    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dictSessionInfo options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", _pQBBaseURL, _pQBSession];
//    
//    NSMutableURLRequest *request = [RequestBuilder sendRequest:serviceURL
//                                                   requestType:@"POST"
//                                               combinedDataStr:jsonString];
//    
//    ServerConnection *connection = [[ServerConnection alloc] init];
//    [connection serverRequest:self
//                     selector:@selector(serverResponseForSession:)
//                serverRequest:request
//           toShowWindowLoader:YES];
//}
//
//- (void)serverResponseForSession:(NSMutableData *)responseData {
//    NSError *error = nil;
//    
//    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
//    
//    NSLog(@"response dict : %@", responseDict.description);
//}
//
////- (void)serverResponseReceivedForProductAddedToCart:(NSMutableData *)responseData {
////    NSError *error = nil;
////    NSMutableDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
////
////    DLog(@"%@",responseDictionary);
////    [_controller performSelectorOnMainThread:_handler
////                                  withObject:responseDictionary
////                               waitUntilDone:YES];
////}
//
//@end
