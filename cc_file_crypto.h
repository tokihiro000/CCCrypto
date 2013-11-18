#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import "cc_crypto.h"

@interface cc_file_crypto : cc_crypto
{

}

- (int)CCCryptoInPath:(NSString *)inPath OutPath:(NSString*)outPath;
@end
