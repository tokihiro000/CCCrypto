#import "cc_crypto.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

int main(void) {
  unsigned char key[16] = {0x01, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
  unsigned char iv[16] = {0x01, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
  id cc, cc2;
  void *res, *res2;
  NSString *filePath = @"/Users/tokihiro/imageyuuyake03.jpg";
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];

  if (!fileHandle) {
    NSLog(@"ファイルがありません．");
    exit(EXIT_FAILURE);
  }
  // ファイルの末尾まで読み込む
  NSData *data = [fileHandle readDataToEndOfFile];
  cc = [[cc_crypto alloc] initWithOperation:kCCEncrypt key:key iv:iv];
  res = [cc CCCrypto:data];
  NSLog(@"len = %lu", [cc CLen]);

  cc2 = [[cc_crypto alloc] initWithOperation:kCCDecrypt key:key iv:iv];
  NSData* data2 = [NSData dataWithBytes:(const void *)res length:[cc CLen]];
  res2 = [cc2 CCCrypto:data ];

}
