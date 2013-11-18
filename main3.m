#import "cc_file_crypto.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

/*
 * ファイルの暗号化のテスト
 *
 *
 */

int main(void) {
  unsigned char key[16] = {0x01, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
  unsigned char iv[16] = {0x01, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
  id cc, cc2;
  NSString *filePath = @"/Users/tokihiro/image/yuuyake03.jpg";
  NSString *encfilePath = @"/Users/tokihiro/image/E1";
  NSString *decfilePath = @"/Users/tokihiro/image/hoge.jpg";

  cc = [[cc_file_crypto alloc] initWithOperation:kCCEncrypt key:key iv:iv];
  cc2 = [[cc_file_crypto alloc] initWithOperation:kCCDecrypt key:key iv:iv];

  int result = [cc CCCryptoInPath:filePath OutPath:encfilePath];
  if(result == 1){
    NSLog(@"encrypt error");
    exit(EXIT_FAILURE);
  }

  result = [cc2 CCCryptoInPath:encfilePath OutPath:decfilePath];
  if(result == 1){
    NSLog(@"decrypt error");
    exit(EXIT_FAILURE);
  }
}
