// Objective-C API for talking to github.com/ProtonMail/gopenpgp/v2/models Go package.
//   gobind -lang=objc github.com/ProtonMail/gopenpgp/v2/models
//
// File is generated by gobind. Do not edit.

#ifndef __Models_H__
#define __Models_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class ModelsEncryptedSigned;

/**
 * EncryptedSigned contains an encrypted message and signature.
 */
@interface ModelsEncryptedSigned : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull encrypted;
@property (nonatomic) NSString* _Nonnull signature;
@end

#endif
