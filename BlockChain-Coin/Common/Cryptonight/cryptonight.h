#include "oaes_lib.h"

#ifndef CRYPTONIGHT_H
#define CRYPTONIGHT_H

#define CRYPTONIIGHT_MEMORY         (1 << 21) /* 2 MiB */
#define CRYPTONIIGHT_ITER           (1 << 20)
#define CRYPTONIIGHT_AES_BLOCK_SIZE  16
#define CRYPTONIIGHT_AES_KEY_SIZE    32 /*16*/
#define CRYPTONIIGHT_INIT_SIZE_BLK   8
#define CRYPTONIIGHT_INIT_SIZE_BYTE (CRYPTONIIGHT_INIT_SIZE_BLK * CRYPTONIIGHT_AES_BLOCK_SIZE)    // 128*/

#define likely(x) (x)

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma pack(push, 1)
    union hash_state {
        uint8_t b[200];
        uint64_t w[25];
    };
#pragma pack(pop)
    
#pragma pack(push, 1)
    union cn_slow_hash_state {
        union hash_state hs;
        struct {
            uint8_t k[64];
            uint8_t init[CRYPTONIIGHT_INIT_SIZE_BYTE];
        };
    };
#pragma pack(pop)
    
    struct cryptonight_ctx {
        uint8_t long_state[CRYPTONIIGHT_MEMORY] __attribute((aligned(16)));
        union cn_slow_hash_state state;
        uint8_t text[CRYPTONIIGHT_INIT_SIZE_BYTE] __attribute((aligned(16)));
        uint8_t a[CRYPTONIIGHT_AES_BLOCK_SIZE] __attribute__((aligned(16)));
        uint8_t b[CRYPTONIIGHT_AES_BLOCK_SIZE] __attribute__((aligned(16)));
        uint8_t c[CRYPTONIIGHT_AES_BLOCK_SIZE] __attribute__((aligned(16)));
        oaes_ctx* aes_ctx;
    };
    
    void cryptonight(void *output, const void *input, size_t len);
    void cryptonight_hash_ctx(void * output, const void * input, struct cryptonight_ctx * ctx);
    
#ifdef __cplusplus
}
#endif

#endif
