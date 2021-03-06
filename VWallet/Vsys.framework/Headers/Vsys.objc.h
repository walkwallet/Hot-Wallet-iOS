// Objective-C API for talking to Vsyslib Go package.
//   gobind -lang=objc Vsyslib
//
// File is generated by gobind. Do not edit.

#ifndef __Vsys_H__
#define __Vsys_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class VsysAccount;
@class VsysContract;
@class VsysDataEncoder;
@class VsysDataEntry;
@class VsysFunc;
@class VsysKeys;
@class VsysQRCodeContentItem;
@class VsysQRCodePagination;
@class VsysTextual;
@class VsysTransaction;
@class VsysWallet;

@interface VsysAccount : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
/**
 * 生成密钥对
 */
- (nullable instancetype)init:(NSString* _Nullable)network publicKey:(NSString* _Nullable)publicKey;
- (NSString* _Nonnull)accountSeed;
/**
 * 地址、Base58编码
 */
- (NSString* _Nonnull)address;
/**
 * 私钥、Base58编码
 */
- (NSString* _Nonnull)privateKey;
/**
 * 公钥、Base58编码
 */
- (NSString* _Nonnull)publicKey;
/**
 * The output is base58 encoded data
 */
- (NSString* _Nonnull)signData:(NSData* _Nullable)data;
- (NSString* _Nonnull)signDataBase58:(NSString* _Nullable)data;
/**
 * 验证签名
 */
- (BOOL)verifySignature:(NSData* _Nullable)data signature:(NSData* _Nullable)signature;
@end

@interface VsysContract : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull contractId;
@property (nonatomic) NSData* _Nullable contract;
@property (nonatomic) NSString* _Nonnull type;
@property (nonatomic) int64_t max;
@property (nonatomic) int64_t unity;
@property (nonatomic) NSString* _Nonnull tokenDescription;
@property (nonatomic) int64_t amount;
@property (nonatomic) int32_t tokenIdx;
@property (nonatomic) NSString* _Nonnull recipient;
@property (nonatomic) NSString* _Nonnull senderPublicKey;
@property (nonatomic) NSString* _Nonnull senderAddr;
// skipped field Contract.Textual with unsupported type: Vsyslib.Textual

// skipped field Contract.Functions with unsupported type: []Vsyslib.Func

- (NSData* _Nullable)buildDepositData;
- (NSData* _Nullable)buildDestroyData;
- (NSData* _Nullable)buildIssueData;
- (NSData* _Nullable)buildNFTSendData;
- (NSData* _Nullable)buildRegisterData;
- (NSData* _Nullable)buildSendData;
- (NSData* _Nullable)buildWithdrawData;
- (void)decodeDeposit:(NSData* _Nullable)data;
- (void)decodeDestroy:(NSData* _Nullable)data;
- (void)decodeIssue:(NSData* _Nullable)data;
- (void)decodeNFTSend:(NSData* _Nullable)data;
- (void)decodeRegister:(NSData* _Nullable)data;
- (void)decodeSend:(NSData* _Nullable)data;
- (void)decodeTexture;
- (void)decodeWithdraw:(NSData* _Nullable)data;
@end

@interface VsysDataEncoder : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
// skipped method DataEncoder.Decode with unsupported parameter or return types

// skipped method DataEncoder.Encode with unsupported parameter or return types

- (void)encodeArgAmount:(int16_t)amount;
- (NSData* _Nullable)result;
@end

@interface VsysDataEntry : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) int8_t type;
// skipped field DataEntry.Value with unsupported type: interface{}

@end

@interface VsysFunc : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull name;
// skipped field Func.Args with unsupported type: []string

// skipped field Func.RetArgs with unsupported type: []string

@end

@interface VsysKeys : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSData* _Nullable publicKey;
@property (nonatomic) NSData* _Nullable privateKey;
@end

@interface VsysQRCodeContentItem : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) long current;
@property (nonatomic) long total;
@property (nonatomic) NSString* _Nonnull checkSum;
@property (nonatomic) NSString* _Nonnull content;
@end

@interface VsysQRCodePagination : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull fullContent;
@property (nonatomic) long current;
@property (nonatomic) long total;
@property (nonatomic) NSString* _Nonnull currentContent;
@end

@interface VsysTextual : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull triggers;
@property (nonatomic) NSString* _Nonnull descriptors;
@property (nonatomic) NSString* _Nonnull stateVariables;
@end

@interface VsysTransaction : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull txId;
@property (nonatomic) int64_t timestamp;
@property (nonatomic) int64_t fee;
@property (nonatomic) int16_t feeScale;
@property (nonatomic) int64_t amount;
@property (nonatomic) NSData* _Nullable attachment;
@property (nonatomic) NSString* _Nonnull recipient;
/**
 * Contract
 */
@property (nonatomic) NSData* _Nullable contract;
@property (nonatomic) NSString* _Nonnull contractId;
@property (nonatomic) int32_t tokenIdx;
@property (nonatomic) NSString* _Nonnull description;
@property (nonatomic) int16_t funcIdx;
@property (nonatomic) NSData* _Nullable data;
/**
 * 生成数据
 */
- (NSData* _Nullable)buildTxData;
- (long)txType;
@end

@interface VsysWallet : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
/**
 * 创建钱包
 */
- (nullable instancetype)init:(NSString* _Nullable)seed network:(NSString* _Nullable)network;
/**
 * n >= 0
 */
- (VsysAccount* _Nullable)generateAccount:(long)nonce;
@end

/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionDeposit;
/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionDestroy;
/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionInit;
/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionIssue;
/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionSend;
/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionSplit;
/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionSupersede;
/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionTransfer;
/**
 * contract funcIdx variable
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysActionWithdraw;
FOUNDATION_EXPORT const int64_t VsysApi;
FOUNDATION_EXPORT const int64_t VsysColdSignApi;
FOUNDATION_EXPORT NSString* _Nonnull const VsysConstContractDefault;
FOUNDATION_EXPORT NSString* _Nonnull const VsysConstContractSplit;
FOUNDATION_EXPORT const int64_t VsysContractApi;
FOUNDATION_EXPORT const int64_t VsysDETypeAccount;
FOUNDATION_EXPORT const int64_t VsysDeTypeAddress;
FOUNDATION_EXPORT const int64_t VsysDeTypeAmount;
FOUNDATION_EXPORT const int64_t VsysDeTypeContractAccount;
FOUNDATION_EXPORT const int64_t VsysDeTypeInt32;
FOUNDATION_EXPORT const int64_t VsysDeTypePublicKey;
FOUNDATION_EXPORT const int64_t VsysDeTypeShortText;
/**
 * Fee
 */
FOUNDATION_EXPORT const int64_t VsysDefaultContractExecuteFee;
/**
 * Fee
 */
FOUNDATION_EXPORT const int64_t VsysDefaultContractRegisterFee;
/**
 * Fee
 */
FOUNDATION_EXPORT const int16_t VsysDefaultFeeScale;
/**
 * Fee
 */
FOUNDATION_EXPORT const int64_t VsysDefaultTxFee;
FOUNDATION_EXPORT NSString* _Nonnull const VsysErrDecodeContract;
/**
 * Network
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysNetworkMainnet;
/**
 * Network
 */
FOUNDATION_EXPORT NSString* _Nonnull const VsysNetworkTestnet;
FOUNDATION_EXPORT NSString* _Nonnull const VsysOpcTypeAccount;
FOUNDATION_EXPORT NSString* _Nonnull const VsysOpcTypeContract;
FOUNDATION_EXPORT NSString* _Nonnull const VsysOpcTypeFunction;
FOUNDATION_EXPORT NSString* _Nonnull const VsysOpcTypeSeed;
FOUNDATION_EXPORT NSString* _Nonnull const VsysOpcTypeSignature;
FOUNDATION_EXPORT NSString* _Nonnull const VsysOpcTypeTransction;
FOUNDATION_EXPORT NSString* _Nonnull const VsysProtocol;
FOUNDATION_EXPORT const int64_t VsysTransactionNewApi;
FOUNDATION_EXPORT const int64_t VsysTransactionOldApi;
/**
 * TX_TYPE
 */
FOUNDATION_EXPORT const int64_t VsysTxTypeCancelLease;
/**
 * TX_TYPE
 */
FOUNDATION_EXPORT const int64_t VsysTxTypeContractExecute;
/**
 * TX_TYPE
 */
FOUNDATION_EXPORT const int64_t VsysTxTypeContractRegister;
/**
 * TX_TYPE
 */
FOUNDATION_EXPORT const int64_t VsysTxTypeLease;
/**
 * TX_TYPE
 */
FOUNDATION_EXPORT const int64_t VsysTxTypeMining;
/**
 * TX_TYPE
 */
FOUNDATION_EXPORT const int64_t VsysTxTypePayment;
/**
 * Fee
 */
FOUNDATION_EXPORT const int64_t VsysVSYS;

@interface Vsys : NSObject
// skipped variable D with unsupported type: []int64

// skipped variable D2 with unsupported type: []int64

// skipped variable I with unsupported type: []int64

// skipped variable K with unsupported type: []int64

// skipped variable L with unsupported type: []int64

// skipped variable X with unsupported type: []int64

// skipped variable Y with unsupported type: []int64

@end

// skipped function A with unsupported parameter or return types


/**
 * AesDecrypt aes cbc PKCS5Padding 解密
 */
FOUNDATION_EXPORT NSData* _Nullable VsysAesDecrypt(NSData* _Nullable key, NSData* _Nullable data, NSError* _Nullable* _Nullable error);

/**
 * AesEncrypt aes加密
key为任意长度
data为任意长度
使用随机化iv,多次加密结果不同
PKCS5Padding
CBC模式
 */
FOUNDATION_EXPORT NSData* _Nullable VsysAesEncrypt(NSData* _Nullable key, NSData* _Nullable data, NSError* _Nullable* _Nullable error);

FOUNDATION_EXPORT NSData* _Nullable VsysBase58Decode(NSData* _Nullable data);

FOUNDATION_EXPORT NSString* _Nonnull VsysBase58DecodeString(NSString* _Nullable in_);

FOUNDATION_EXPORT NSData* _Nullable VsysBase58Encode(NSData* _Nullable data);

FOUNDATION_EXPORT NSString* _Nonnull VsysBase58EncodeString(NSString* _Nullable in_);

FOUNDATION_EXPORT NSString* _Nonnull VsysBase58EncodeToString(NSData* _Nullable data);

/**
 * tokenIndex fixed = 0
TODO tokenIndex variable
 */
FOUNDATION_EXPORT NSString* _Nonnull VsysContractId2TokenId(NSString* _Nullable contractId, long tokenIndex);

/**
 * output decode result json
 */
FOUNDATION_EXPORT NSString* _Nonnull VsysDecodeContractTexture(NSString* _Nullable data);

FOUNDATION_EXPORT NSString* _Nonnull VsysDecodeDescription(NSString* _Nullable in_);

/**
 * 生成密钥对
 */
FOUNDATION_EXPORT VsysAccount* _Nullable VsysGenerateKeyPair(NSData* _Nullable seedHash);

// skipped function GenerateKeyPair1 with unsupported parameter or return types


/**
 * 生成助记词
 */
FOUNDATION_EXPORT NSString* _Nonnull VsysGenerateSeed(void);

FOUNDATION_EXPORT VsysAccount* _Nullable VsysGetAccountFromPrivateKey(NSString* _Nullable privateKey, NSString* _Nullable network);

FOUNDATION_EXPORT NSString* _Nonnull VsysGetAddressNetwork(NSString* _Nullable address);

FOUNDATION_EXPORT long VsysGetAttachmentLength(NSString* _Nullable in_);

FOUNDATION_EXPORT VsysQRCodeContentItem* _Nullable VsysGetContentItem(NSString* _Nullable in_);

/**
 * DbKey: 用来获取Lock Contract & Payment Channel 对应地址下的token余额
 */
FOUNDATION_EXPORT NSString* _Nonnull VsysGetContractBalanceDbKey(NSString* _Nullable address);

/**
 * funcName 小写, eg: issue
 */
FOUNDATION_EXPORT int16_t VsysGetFuncIndexFromDescriptor(NSString* _Nullable textualDescriptor, NSString* _Nullable funcName);

FOUNDATION_EXPORT NSString* _Nonnull VsysGetFuncNameFromDescriptor(NSString* _Nullable textualDescriptor, long funcIndex);

FOUNDATION_EXPORT NSString* _Nonnull VsysGetNetworkFromAddress(NSString* _Nullable address);

/**
 * QRCode pagination protocol
 */
FOUNDATION_EXPORT VsysQRCodePagination* _Nullable VsysGetPaginationContent(NSString* _Nullable fullContent, long pagination);

FOUNDATION_EXPORT NSData* _Nullable VsysHashChain(NSData* _Nullable nonceSecret);

// skipped function Keccak256 with unsupported parameter or return types


// skipped function M with unsupported parameter or return types


/**
 * 生成密钥对
 */
FOUNDATION_EXPORT VsysAccount* _Nullable VsysNewAccount(NSString* _Nullable network, NSString* _Nullable publicKey);

FOUNDATION_EXPORT VsysTransaction* _Nullable VsysNewCancelLeaseTransaction(NSString* _Nullable txId);

/**
 * funcIdx may change
 */
FOUNDATION_EXPORT VsysTransaction* _Nullable VsysNewExecuteTransaction(NSString* _Nullable contractId, NSString* _Nullable data, int16_t funcIdx, NSString* _Nullable attachment);

FOUNDATION_EXPORT VsysTransaction* _Nullable VsysNewLeaseTransaction(NSString* _Nullable recipient, int64_t amount);

FOUNDATION_EXPORT VsysTransaction* _Nullable VsysNewMiningTransaction(void);

FOUNDATION_EXPORT VsysTransaction* _Nullable VsysNewPaymentTransaction(NSString* _Nullable recipient, int64_t amount);

FOUNDATION_EXPORT VsysTransaction* _Nullable VsysNewRegisterTransaction(NSString* _Nullable contract, NSString* _Nullable data, NSString* _Nullable contractDescription);

/**
 * 创建钱包
 */
FOUNDATION_EXPORT VsysWallet* _Nullable VsysNewWallet(NSString* _Nullable seed, NSString* _Nullable network);

// skipped function S with unsupported parameter or return types


FOUNDATION_EXPORT NSData* _Nullable VsysSharedKey(NSData* _Nullable secretKey, NSData* _Nullable publicKey);

FOUNDATION_EXPORT NSData* _Nullable VsysSign(NSData* _Nullable secretKey, NSData* _Nullable msg, NSData* _Nullable opt_random);

FOUNDATION_EXPORT NSData* _Nullable VsysSignMessage(NSData* _Nullable secretKey, NSData* _Nullable msg, NSData* _Nullable opt_random);

FOUNDATION_EXPORT NSString* _Nonnull VsysTokenId2ContractId(NSString* _Nullable tokenId);

FOUNDATION_EXPORT int32_t VsysTokenId2TokenIdx(NSString* _Nullable tokenId);

FOUNDATION_EXPORT BOOL VsysValidateAddress(NSString* _Nullable address);

FOUNDATION_EXPORT BOOL VsysValidatePhrase(NSString* _Nullable phrase);

FOUNDATION_EXPORT long VsysVerify(NSData* _Nullable publicKey, NSData* _Nullable msg, NSData* _Nullable signature);

// skipped function Z with unsupported parameter or return types


#endif
