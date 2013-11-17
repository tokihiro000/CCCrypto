#import "cc_crypto.h"

@implementation cc_crypto
- (id)initWithOperation:(CCOperation)operation key:(unsigned char *)key iv:(unsigned char *)iv{
  self = [super init];
  if(self != nil){
    op = operation;
    memcpy(crypto_key, key, 16);
    memcpy(crypto_iv, iv, 16);
  }
  return self;
}

- (NSUInteger)CLen {
  return CLen;
}

- (void *)CCCrypto:(NSData *)data {
  CCCryptorStatus err;
  CCCryptorRef ref;
  void *response;
  size_t bufferSize;
  size_t updateResultLength = 0;
  size_t finalResultLength = 0;

  NSUInteger length = [data length];

  bufferSize = length + kCCBlockSizeAES128;

  //NSLog(@"length = %lu, bufferSize = %zu, %@", length, bufferSize, [data description]);

  err = CCCryptorCreate(op, kCCAlgorithmAES128, kCCOptionPKCS7Padding, crypto_key, kCCKeySizeAES128, crypto_iv, &ref);
  NSLog(@"CCCryptorCreate = %d", err);

  response = malloc(bufferSize*sizeof(size_t));
  err = CCCryptorUpdate(ref, [data bytes], [data length], response, bufferSize, &updateResultLength);
  NSLog(@"CCCryptorUpdate = %d, resultLength = %zu", err, updateResultLength);

  err = CCCryptorFinal(ref, response + updateResultLength, bufferSize, &finalResultLength);
  NSLog(@"CCCryptorFinal = %d, resultLength = %zu", err, finalResultLength);

  if( err == 0 ) {
    printf("success\n");
    CLen = (updateResultLength + finalResultLength);
  }

  CCCryptorRelease(ref);
  return response;
}

@end
