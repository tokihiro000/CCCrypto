#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface cc_crypto:NSObject
{
  CCOperation op;
  NSUInteger CLen;
  unsigned char crypto_key[16];
  unsigned char crypto_iv[16];
}

- (id)initWithOperation:(CCOperation)op key:(unsigned char *)key iv:(unsigned char *)iv;
- (NSUInteger)CLen;
- (NSData *)CCCrypto:(NSData *)data ;

@end
