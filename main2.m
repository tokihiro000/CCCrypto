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
  NSString *filePath = @"/Users/tokihiro/image/yuuyake03.jpg";
  NSString *decfilePath = @"/Users/tokihiro/image/hoge.jpg";
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];

  if (!fileHandle) {
    NSLog(@"ファイルがありません．");
    exit(EXIT_FAILURE);
  }
  // ファイルの末尾まで読み込み、暗号化を行う
  NSData *data = [fileHandle readDataToEndOfFile];
  cc = [[cc_crypto alloc] initWithOperation:kCCEncrypt key:key iv:iv];
  NSData* EncData = [cc CCCrypto:data];

  //暗号化されたデータを復号する
  cc2 = [[cc_crypto alloc] initWithOperation:kCCDecrypt key:key iv:iv];
  NSData* DecData = [cc2 CCCrypto:EncData ];

  /** 復号されたデータをファイルとして書き込む **/
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
