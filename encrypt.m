#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

unsigned char key[16] = {0x01, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
unsigned char iv[16] = {0x01, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};

void decrypt(void* cipher, size_t length){
  CCOperation op;
  CCCryptorStatus err;
  CCCryptorRef ref;
  void *plain;
  size_t bufferSize;
  size_t updateResultLength = 0;
  size_t finalResultLength = 0;

  bufferSize = length;
  NSLog(@"bufferSize = %zu", bufferSize);

  err = CCCryptorCreate(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key, kCCKeySizeAES128, iv, &ref);
  NSLog(@"CCCryptorCreate = %d", err);

  plain = malloc(bufferSize*sizeof(size_t));
  err = CCCryptorUpdate(ref, cipher, length, plain, bufferSize, &updateResultLength);
  NSLog(@"CCCryptorUpdate = %d, resultLength = %zu", err, updateResultLength);

  err = CCCryptorFinal(ref, plain + updateResultLength, bufferSize, &finalResultLength);
  NSLog(@"CCCryptorFinal = %d, resultLength = %zu", err, finalResultLength);

  if( err == 0 ) {
    NSData* data = [NSData dataWithBytes:(const void *)plain length:(updateResultLength + finalResultLength)];
    NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%lu %@", [data length],str);
  }

  CCCryptorRelease(ref);
}

/*
 *
 *  リファレンス::
 *  http://www.opensource.apple.com/source/CommonCrypto/CommonCrypto-36064/CommonCrypto/CommonCryptor.h
 *
 *  参考
 *  http://mythosil.hatenablog.com/entry/20111017/1318873155
 *  http://ka-zoo.net/2013/03/nsdata%E5%9E%8B-%E3%81%8B%E3%82%89%E3%83%90%E3%82%A4%E3%83%88%E5%88%97%E3%81%B8%E3%81%AE%E5%A4%89%E6%8F%9B/
 */
int main(void){
  // char *test = "test";
  NSString* test = @"tesaaaaaaaaaaaataaaaaaaaaaaaaaaabbbbagafgarfajaowefjawpoefjao";
  NSData* test_data = [test dataUsingEncoding:NSUTF8StringEncoding];
  CCOperation op;
  CCCryptorStatus err;
  CCCryptorRef ref;
  void *response;
  size_t bufferSize;
  size_t updateResultLength = 0;
  size_t finalResultLength = 0;

  NSUInteger length = [test_data length];

  bufferSize = length + kCCBlockSizeAES128;

  NSLog(@"length = %lu, bufferSize = %zu, %@", length, bufferSize, [test_data description]);

  err = CCCryptorCreate(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key, kCCKeySizeAES128, iv, &ref);
  NSLog(@"CCCryptorCreate = %d", err);

  response = malloc(bufferSize*sizeof(size_t));
  err = CCCryptorUpdate(ref, [test_data bytes], [test_data length], response, bufferSize, &updateResultLength);
  NSLog(@"CCCryptorUpdate = %d, resultLength = %zu", err, updateResultLength);

  err = CCCryptorFinal(ref, response + updateResultLength, bufferSize, &finalResultLength);
  NSLog(@"CCCryptorFinal = %d, resultLength = %zu", err, finalResultLength);

  if( err == 0 ) {
    printf("success\n");
    unsigned char *ciphertext = (unsigned char *)malloc(bufferSize*sizeof(size_t));
    memcpy(ciphertext, response, updateResultLength + finalResultLength);
    for(int i = 0; i < updateResultLength + finalResultLength; i++ ) {
      printf("%02x", ciphertext[i]);
    }
  }
  putchar('\n');
  CCCryptorRelease(ref);

  decrypt(response, updateResultLength + finalResultLength);
}
