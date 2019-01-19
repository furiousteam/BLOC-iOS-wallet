//
//  HashContext.mm
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.

#import "HashContext.h"
#import "Cryptonight/cryptonight.h"
#import "keccak.h"
#import "cn_slow_hash.hpp"

@interface HashContext() {
    cn_heavy::cn_pow_hash_v2 *_ctx;
}

@end

@implementation HashContext

- (instancetype)init {
    if (self = [super init]) {
        _ctx = new cn_heavy::cn_pow_hash_v2();
    }
        
    return self;
}
    
- (void)dealloc {
    if (_ctx) {
        free(_ctx);
        _ctx = NULL;
    }
}

- (NSData * _Nonnull)hashData:(NSData * _Nonnull)data {
    NSMutableData *output = [NSMutableData dataWithLength:32];
   
    _ctx->hash(data.bytes, data.length, output.mutableBytes);
    
    return output;
}

- (NSData * _Nonnull)keccacHashData:(NSData * _Nonnull)data {
    NSMutableData *output = [NSMutableData dataWithLength:13];
    _ctx->hash(data.bytes, data.length, output.mutableBytes);
    return output;
}

@end
