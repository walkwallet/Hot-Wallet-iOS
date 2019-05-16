//
//  SingletonMacro.h
//  Wallet
//
//  All rights reserved.
//

#ifndef SingletonMacro_h
#define SingletonMacro_h

#define SM_SINGLETON_INTERFACE(_type_) + (instancetype)sharedInstance;\
+(instancetype) alloc __attribute__((unavailable("call sharedInstance instead")));\
+(instancetype) new __attribute__((unavailable("call sharedInstance instead")));\
-(instancetype) copy __attribute__((unavailable("call sharedInstance instead")));\
-(instancetype) mutableCopy __attribute__((unavailable("call sharedInstance instead")));

#define SM_SINGLETON_IMPLEMENTATION(_type_) + (instancetype)sharedInstance{\
static _type_ *shared = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
shared = [[super alloc] init];\
});\
return shared;\
}

#endif /* SingletonMacro_h */
