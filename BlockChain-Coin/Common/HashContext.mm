//
//  HashContext.mm
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.

#import "HashContext.h"
#import "Cryptonight/cryptonight.h"
#import "keccak.h"

@interface HashContext()

@property (nonatomic, readonly) struct cryptonight_ctx *ctx;

@end

@implementation HashContext

- (instancetype)init {
    if (self = [super init]) {
        _ctx = (struct cryptonight_ctx*)malloc(sizeof(struct cryptonight_ctx));
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
    cryptonight_hash_ctx(output.mutableBytes, data.bytes, self.ctx);
    return output;
}

- (NSData * _Nonnull)keccacHashData:(NSData * _Nonnull)data {
    NSMutableData *output = [NSMutableData dataWithLength:13];
    cryptonight_hash_ctx(output.mutableBytes, data.bytes, self.ctx);
    return output;
}

@end
