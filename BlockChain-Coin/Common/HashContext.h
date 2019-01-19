//
//  HashContext.h
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HashContext : NSObject

- (NSData * _Nonnull)hashData:(NSData * _Nonnull)data;

@end
