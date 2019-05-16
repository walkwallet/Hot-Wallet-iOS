//
// ServiceAPI.h
//  Wallet
//
//  All rights reserved.
//

#ifndef ServiceAPI_h
#define ServiceAPI_h



//[
// {
//     "height": 2232354
// },
// {
//     "slotId": 0,
//     "address": "ATxpELPa3yhE5h4XELxtPrW9TfXPrmYE7ze",
//     "mintingAverageBalance": 99999999999964800
// }
//]
static NSString *const ApiAllSlotsInfo = @"/consensus/allSlotsInfo";

//
//{
//    "address": "AUAHdqvnFDbxRZ8rkyqm4wT9A7qQ8CZRGLM",
//    "regular": 50410441000,
//    "mintingAverage": 45501315441,
//    "available": 36410441000,
//    "effective": 53632663222,
//    "height": 2232288
//}

static NSString *const ApiAddressBalanceDetail = @"/addresses/balance/details/%@";


//URL
//http://52.8.148.150:9922/transactions/address/AUAHdqvnFDbxRZ8rkyqm4wT9A7qQ8CZRGLM/limit/2
//Response Body
//[
// [
//  {
//      "type": 4,
//      "id": "BrCEkpaBzNMELaJQe15hkcCRw7SdzEpnMAaqz1pEjqRg",
//      "fee": 10000000,
//      "timestamp": 1543411367625000000,
//      "proofs": [
//          {
//                     "proofType": "Curve25519",
//                     "publicKey": "HVfzNgXowHd3wBJuq7qTL336pvuvv8GrD1oxLdcRFRN2",
//                     "signature": "3SZRyUGhoSunEuXPDXyUjBTx8JFM7NB12FbmC7yGxz1pucKo36hGUzh3QCVgH5ZoMcpvyq7JSbzpdMZKUUWJxgJi"
//          }
//      ],
//      "feeScale": 100,
//      "leaseId": "EWU6hHo9BVyWPSeqCKUXVch9jgEBzx1WJbhw66ozRe6J",
//      "status": "Success",
//      "feeCharged": 10000000,
//      "lease": {
//          "type": 3,
//          "id": "EWU6hHo9BVyWPSeqCKUXVch9jgEBzx1WJbhw66ozRe6J",
//          "fee": 10000000,
//          "timestamp": 1543411295718000000,
//          "proofs": [
//                     {
//                         "proofType": "Curve25519",
//                         "publicKey": "HVfzNgXowHd3wBJuq7qTL336pvuvv8GrD1oxLdcRFRN2",
//                         "signature": "4bEy6vQ54SwokyP1sE4c5ovVhrQxno3mF9Hcu6hanKe9iWL7k5Eo5TmDE5DH7H6dA1pVHY4dWqiGmqH8fhZwFZRC"
//                     }
//                     ],
//          "amount": 2000000000,
//          "recipient": "AUAHdqvnFDbxRZ8rkyqm4wT9A7qQ8CZRGLM",
//          "feeScale": 100
//      }
//  },
//  {
//      "type": 3,
//      "id": "EWU6hHo9BVyWPSeqCKUXVch9jgEBzx1WJbhw66ozRe6J",
//      "fee": 10000000,
//      "timestamp": 1543411295718000000,
//      "proofs": [
//                 {
//                     "proofType": "Curve25519",
//                     "publicKey": "HVfzNgXowHd3wBJuq7qTL336pvuvv8GrD1oxLdcRFRN2",
//                     "signature": "4bEy6vQ54SwokyP1sE4c5ovVhrQxno3mF9Hcu6hanKe9iWL7k5Eo5TmDE5DH7H6dA1pVHY4dWqiGmqH8fhZwFZRC"
//                 }
//                 ],
//      "amount": 2000000000,
//      "recipient": "AUAHdqvnFDbxRZ8rkyqm4wT9A7qQ8CZRGLM",
//      "feeScale": 100,
//      "status": "Success",
//      "feeCharged": 10000000
//  },
//{
//    "type": 2,
//    "id": "CVdUN9hPMWe5UmhtLEKwnUJeZiv3mBYM5EPYy7NuyQQ6",
//    "fee": 10000000,
//    "timestamp": 1543411226451000000,
//    "proofs": [
//               {
//                   "proofType": "Curve25519",
//                   "publicKey": "HVfzNgXowHd3wBJuq7qTL336pvuvv8GrD1oxLdcRFRN2",
//                   "signature": "x6eR1X38WPwTfCL7MhR961bkqaBCv2nh6uyfgaEwWqXv9gqiMxJhhXXXPAHhjtvzsKg6NUGE676mQthqLRWPtV2"
//               }
//               ],
//    "recipient": "AUAHdqvnFDbxRZ8rkyqm4wT9A7qQ8CZRGLM",
//    "feeScale": 100,
//    "amount": 2000000000,
//    "attachment": "",
//    "status": "Success",
//    "feeCharged": 10000000
//},
//  ]
// ]
static NSString *const ApiTransactionList = @"/transactions/address/%@/limit/999";


//{
//    "senderPublicKey": "string",
//    "amount": 0,
//    "fee": 0,
//    "feeScale": 0,
//    "recipient": "string",
//    "timestamp": 0,
//    "signature": "string"
//}

static NSString *const ApiLease = @"/leasing/broadcast/lease";


//{
//    "senderPublicKey": "string",
//    "txId": "string",
//    "timestamp": 0,
//    "signature": "string",
//    "fee": 0,
//    "feeScale": 0
//}
static NSString *const ApiCancelLease = @"/leasing/broadcast/cancel";

//{
//    "timestamp": 0,
//    "amount": 0,
//    "fee": 0,
//    "feeScale": 0,
//    "recipient": "string",
//    "senderPublicKey": "string",
//    "attachment": "string",
//    "signature": "string"
//}
static NSString *const ApiPayment = @"/vsys/broadcast/payment";

static NSString *const ApiGetTokenInfo = @"/contract/tokenInfo/%@";

static NSString *const ApiGetContractInfo = @"/contract/info/%@";

static NSString *const ApiGetAddressTokenBalance = @"/contract/balance/%@/%@";

#endif /* ServiceAPI_h */
