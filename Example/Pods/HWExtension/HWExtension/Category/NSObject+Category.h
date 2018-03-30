//
//  NSObject+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/11/8.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

// perform block
#define performBlock(b, ...) if (b) { b(__VA_ARGS__); }

// perform block
#define performReturnValueBlock(b, nilReturnValue, ...) if (b) { return b(__VA_ARGS__); } else { return nilReturnValue; }

// perform Selector
#define performSelector(T, S, ...)  \
if (T && [(NSObject *)T respondsToSelector:S]) \
{   \
[(NSObject *)T performSelector:S withObjects:__VA_ARGS__];  \
}

// perform Selector
#define performReturnValueSelector(T, S, ...) \
if (T && [(NSObject *)T respondsToSelector:S]) \
{   \
return [(NSObject *)T performSelector:S withObjects:__VA_ARGS__];   \
}

//  属性引用类型
typedef NS_ENUM(NSInteger, HWPropertyRefType) {
    HWPropertyRefTypeAssign,    // assign
    HWPropertyRefTypeWeak,      // weak
    HWPropertyRefTypeStrong,    // strong / retain
    HWPropertyRefTypeCopy,      // copy
};

// 属性数据类型
typedef NS_ENUM(NSInteger, HWPropertyDataType) {
    /* unknown */
    HWPropertyDataTypeUnknown,
    /* basic data type */
    HWPropertyDataTypeBool,         // BOOL
    HWPropertyDataTypeChar,         // char
    HWPropertyDataTypeUChar,        // unsigned char
    HWPropertyDataTypeCharPointer,  // char * / unsigned char *
    HWPropertyDataTypeShort,        // short
    HWPropertyDataTypeUShort,       // unsigned short
    HWPropertyDataTypeInt,          // int
    HWPropertyDataTypeUInt,         // unsigned int
    HWPropertyDataTypeFloat,        // float
    HWPropertyDataTypeDouble,       // double
    HWPropertyDataTypeLong,         // long / NSInteger
    HWPropertyDataTypeULong,        // unsigned long / NSUInteger
    HWPropertyDataTypeLongLong,     // long long
    HWPropertyDataTypeULongLong,    // unsigned long long
    HWPropertyDataTypeStruct,       // struct
    HWPropertyDataTypeStructPointer,// struct *
    /* other data type */
    HWPropertyDataTypeVoid,         // void
    HWPropertyDataTypeVoidPointer,  // void *
    HWPropertyDataTypeId,           // id
    HWPropertyDataTypeObject,       // NSObject or subclass
    HWPropertyDataTypeClass,        // Class
    HWPropertyDataTypeSEL,          // SEL
    HWPropertyDataTypeIMP,          // IMP
};

NS_ASSUME_NONNULL_BEGIN

@class HWClassInfo, HWProtocolInfo, HWMethodInfo, HWPropertyInfo, HWIvarInfo;

@interface NSObject (Category)

- (id)performSelector:(SEL)aSelector withObjects:(id)object,...;

@property (nonatomic, copy) void (^willDeallocBlock)(__unsafe_unretained id obj);    // 对象将被释放

@end

typedef void(^KeyValueObserverChangedBlock)(NSString *keyPath, id object, NSDictionary<NSKeyValueChangeKey,id> *change, void * _Nullable context);

@interface NSObject (NSKeyValueObserverRegistrationBlock)

// 监听属性变化
- (void)observeValueForKeyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                       context:(nullable NSString *)context
                   changeBlock:(nonnull KeyValueObserverChangedBlock)block;

// 监听一组属性变化
- (void)observeValueForKeyPaths:(NSArray <NSString *>*)keyPaths
                        options:(NSKeyValueObservingOptions)options
                        context:(nullable NSString *)context
                    changeBlock:(nonnull KeyValueObserverChangedBlock)block;

// block移除监听, 如果block == nil, 所有相同keyPath & 相同context的block将移除监听
- (void)removeObserveValueForBlock:(nullable KeyValueObserverChangedBlock)block
                           keyPath:(NSString *)keyPath
                           context:(nullable NSString *)context;

@end

@interface NSObject (KeyValues)

@property (nonatomic, assign, readonly) NSDictionary <NSString *, id>*keyValueDictionary;    //

@end

@interface NSObject (ExchangeMethod)

+ (void)exchangeImplementations:(SEL)selfSEL1 otherMethod:(SEL)selfSEL2 isInstance:(BOOL)isInstance;
+ (void)exchangeImplementations:(Method)method otherMethod:(Method)otherMethod;

@end

@interface NSObject (ClassInfo)

// 已注册的类列表
+ (NSArray <HWClassInfo *>*)registeredClassList;
+ (NSArray <NSString *>*)registeredClassNameList;

// 协议列表
+ (NSArray <HWProtocolInfo *>*)protocolList;
+ (NSArray <HWProtocolInfo *>*)allProtocolListEndOfClass:(Class)endOfClass;
+ (NSArray <NSString *>*)protocolNameList;
+ (NSArray <NSString *>*)allProtocolNameListEndOfClass:(Class)endOfClass;

// 属性列表
+ (NSArray <HWPropertyInfo *>*)propertyList;
+ (NSArray <HWPropertyInfo *>*)allPropertyListEndOfClass:(Class)endOfClass;
+ (NSArray <NSString *>*)propertyNameList;
+ (NSArray <NSString *>*)allPropertyNameListEndOfClass:(Class)endOfClass;

// 成员变量列表
+ (NSArray <HWIvarInfo *>*)ivarList;
+ (NSArray <HWIvarInfo *>*)allIvarListEndOfClass:(Class)endOfClass;
+ (NSArray <NSString *>*)ivarNameList;
+ (NSArray <NSString *>*)allIvarListNameEndOfClass:(Class)endOfClass;

// 实例方法列表
+ (NSArray <HWMethodInfo *>*)instanceMethodList;
+ (NSArray <HWMethodInfo *>*)allInstanceMethodListEndOfClass:(Class)endOfClass;
+ (NSArray <NSString *>*)instanceMethodNameList;
+ (NSArray <NSString *>*)allInstanceMethodNameListEndOfClass:(Class)endOfClass;

// 类方法列表
+ (NSArray <HWMethodInfo *>*)classMethodList;
+ (NSArray <HWMethodInfo *>*)allClassMethodListEndOfClass:(Class)endOfClass;
+ (NSArray <NSString *>*)classMethodNameList;
+ (NSArray <NSString *>*)allClassMethodNameListEndOfClass:(Class)endOfClass;

@end

@interface HWClassInfo : NSObject

@property (nonatomic, copy) NSString *name;         //
@property (nonatomic, assign) BOOL isMetaClass;     //
@property (nonatomic, assign) int version;          //
@property (nonatomic, strong) Class superCls;       // super class
@property (nonatomic, assign) size_t instanceSize;  //

@property (nonatomic, copy) NSArray <HWMethodInfo *>*instanceMethodList;  //
@property (nonatomic, copy) NSArray <HWMethodInfo *>*classMethodList;     //
@property (nonatomic, copy) NSArray <HWProtocolInfo *>*protocolList;      //
@property (nonatomic, copy) NSArray <HWPropertyInfo *>*propertyList;      //
@property (nonatomic, copy) NSArray <HWIvarInfo *>*ivarList;              //

@end

@interface HWProtocolInfo : NSObject
@property (nonatomic, copy) NSString *name;    //
@end

@interface HWPropertyAttributeInfo :NSObject
@property (nonatomic, copy) NSString *name;    //
@property (nonatomic, copy) NSString *value;   //
@end

@interface HWPropertyInfo : NSObject
@property (nonatomic, copy) NSString *name;                         //
@property (nonatomic, copy) NSString *getterMethod;                 // getter
@property (nonatomic, copy) NSString *setterMethod;                 // setter
@property (nonatomic, copy) NSString *ivarName;                     // 对应的实例变量名字
@property (nonatomic, assign) HWPropertyDataType dataType;          // 数据类型
@property (nonatomic, assign) HWPropertyRefType refType;            // 引用类型

@property (nonatomic, assign) BOOL isNonatomic;                     // 原子属性
@property (nonatomic, assign, getter=isReadonly) BOOL readonly;     // 是否只读

@property (nonatomic, assign) Class cls;                            // 如果是对象有值
@property (nonatomic, assign) BOOL isBasicPointer;                  // 是否是基础数据类型指针 (char * 、BOOL * 、int * 、struct * ...)

@property (nonatomic, copy) NSString *attributes;                   //
@property (nonatomic, copy) NSArray  <HWPropertyAttributeInfo *>*attributeList;    //
@end

@interface HWIvarInfo : NSObject
@property (nonatomic, copy) NSString *name;            //
@property (nonatomic, copy) NSString *typeEncoding;    //
@end

@interface HWMethodInfo : NSObject
@property (nonatomic, copy) NSString *name;                         //
@property (nonatomic, copy) NSString *typeEncoding;                 //
@property (nonatomic, copy) NSString *returnType;                   //
@property (nonatomic, assign) unsigned int numberOfArguments;       //
@property (nonatomic, copy) NSArray <NSString *>*argumentTypes;     //
@property (nonatomic, assign) IMP implementation ;                  //
@end

NS_ASSUME_NONNULL_END

