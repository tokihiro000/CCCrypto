#import "cc_file_crypto.h"

@implementation cc_file_crypto
- (int)CCCryptoInPath:(NSString *)inPath OutPath:(NSString*)outPath {
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:inPath];

  if (!fileHandle) {
    NSLog(@"ファイルがありません．");
    return 1;
  }
  // ファイルの末尾まで読み込み、暗号化を行う
  NSData *data = [fileHandle readDataToEndOfFile];
  NSData* CryptedData = [super CCCrypto:data];

  /** 復号されたデータをファイルとして書き込む **/
  NSFileManager *fileManager = [NSFileManager defaultManager];
  // ファイルが存在しないか?
  if (![fileManager fileExistsAtPath:outPath]) { // yes
    // 空のファイルを作成する
    BOOL result = [fileManager createFileAtPath:outPath contents:[NSData data] attributes:nil];
    if (!result) {
        NSLog(@"ファイルの作成に失敗");
        return 1;
    }
}
  // ファイルハンドルを作成する
  NSFileHandle *writefileHandle = [NSFileHandle fileHandleForWritingAtPath:outPath];
  // ファイルハンドルの作成に失敗したか?
  if (!writefileHandle) { // no
    NSLog(@"ファイルハンドルの作成に失敗");
    return 1;
  }
  // ファイルに書き込む
  [writefileHandle writeData:CryptedData];

  return 0;
}
@end
