#import "cc_crypto.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

/*
 * 参考
 * http://www.objectivec-iphone.com/foundation/NSFileManager/writeData.html
 *
 */

int main(void) {
  unsigned char key[16] = {0x01, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
  unsigned char iv[16] = {0x01, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
  id cc, cc2;
  void *res, *res2;
  NSString *filePath = @"/Users/tokihiro/image/yuuyake03.jpg";
  //NSString *filePath = @"/Users/tokihiro/image/test.txt";
  NSString *decfilePath = @"/Users/tokihiro/image/hoge.jpg";
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];

  if (!fileHandle) {
    NSLog(@"ファイルがありません．");
    exit(EXIT_FAILURE);
  }
  // ファイルの末尾まで読み込み、暗号化を行う
  NSData *data = [fileHandle readDataToEndOfFile];
  cc = [[cc_crypto alloc] initWithOperation:kCCEncrypt key:key iv:iv];
  res = [cc CCCrypto:data];
  NSLog(@"len = %lu", [cc CLen]);

  //暗号化されたデータを復号する
  cc2 = [[cc_crypto alloc] initWithOperation:kCCDecrypt key:key iv:iv];
  NSData* EncData = [NSData dataWithBytes:(const void *)res length:[cc CLen]];
  res2 = [cc2 CCCrypto:EncData ];

  /** 復号されたデータをファイルとして書き込む **/
  NSData* DecData = [NSData dataWithBytes:(const void *)res2 length:[cc2 CLen]];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  // ファイルが存在しないか?
  if (![fileManager fileExistsAtPath:decfilePath]) { // yes
    // 空のファイルを作成する
    BOOL result = [fileManager createFileAtPath:decfilePath contents:[NSData data] attributes:nil];
    if (!result) {
        NSLog(@"ファイルの作成に失敗");
        exit(EXIT_FAILURE);
    }
}
  // ファイルハンドルを作成する
  NSFileHandle *writefileHandle = [NSFileHandle fileHandleForWritingAtPath:decfilePath];
  // ファイルハンドルの作成に失敗したか?
  if (!writefileHandle) { // no
    NSLog(@"ファイルハンドルの作成に失敗");
    exit(EXIT_FAILURE);
  }
  // ファイルに書き込む
  [writefileHandle writeData:data];
}
