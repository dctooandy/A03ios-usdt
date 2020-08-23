//
//  HYEncryptor.h
//  HYGEntire
//
//  Created by zaky on 31/10/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#define PublicKey  @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDSu2AZPdT2Fqpqxctx3EbnRuuYdBxFZDYG7MASIgw/DFl3P9FAp7S9WaQjdM1NmgBDgvfUWx1xj72LNz4EP4Euh9EESKceNCeoE4M8ZP4ENUQX0nDMbpmIG3/JCI8B5Iv2FKj2q0gGbE0WsLdrYDzFXTYbZKRJSbMMjHT3HtKD/wIDAQAB"
@interface HYEncryptor : BaseModel

// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;

// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

@end

NS_ASSUME_NONNULL_END
