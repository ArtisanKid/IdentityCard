//
//  ICModel.m
//  Pods
//
//  Created by 李翔宇 on 2016/12/17.
//

#import "ICModel.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import "IdentityCardMacros.h"
#import "ICModelManager.h"

@interface ICModel ()

@property (nonatomic, strong) NSMutableSet *observedKeyPathsM;

@end

@implementation ICModel

- (void)cacheSingleton {
    [self cacheWithSignature:[[self class] defaultSignature]];
}

- (void)cacheWithSignature:(NSString *)signature {
    NSString *folderPath = [[self class] modelFolderPath];
    [self cacheToFolderPath:folderPath signature:signature];
}

- (void)cacheToFolderPath:(NSString *)folderPath signature:(NSString *)signature {
    Class class = [self class];
    IdentityCardLog(@"缓存%@对象", NSStringFromClass(class));
    if(![self conformsToProtocol:@protocol(NSCoding)]) {
        IdentityCardLog(@"%@未实现NSCoding协议", NSStringFromClass(class));
        return;
    }
    
    NSError *error = nil;
    if(![NSFileManager.defaultManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        if(error) {
            IdentityCardLog(@"创建目录错误 error:%@", error);
        } else {
            IdentityCardLog(@"创建目录未知错误");
        }
        return;
    }
    
    NSString *path = [[self class] modelPathWithFolderPath:folderPath signature:signature];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+ (id)readSingleton {
    return [self readWithSignature:[self defaultSignature]];
}

+ (id)readWithSignature:(NSString *)signature {
    NSString *folderPath = [self modelFolderPath];
    return [self readFromFolderPath:folderPath signature:signature];
}

+ (id)readFromFolderPath:(NSString *)folderPath signature:(NSString *)signature {
    Class class = [self class];
    IdentityCardLog(@"读取%@对象", NSStringFromClass(class));
    if(![self conformsToProtocol:@protocol(NSCoding)]) {
        IdentityCardLog(@"%@未实现NSCoding协议", NSStringFromClass(class));
        return nil;
    }
    
    NSString *path = [self modelPathWithFolderPath:folderPath signature:signature];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)reset {
    [ICModelManager pause:self];
    [[self.observedKeyPathsM copy] enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        id object = [self valueForKey:key];
        if([object isKindOfClass:[NSValue class]]) {
            [self setValue:[[self class] nilValue:object] forKey:key];
        } else {
            [self setValue:nil forKey:key];
        }
    }];
    [ICModelManager resume:self];
}

#pragma mark - Private Method

+ (NSArray<NSString *> *)customPropertyNames {
    Class class = [self class];
    NSMutableArray *propertyNamesM = [NSMutableArray array];
    do {
        NSBundle *bundle = [NSBundle bundleForClass:class];
        if (![bundle.bundlePath containsString:NSBundle.mainBundle.bundlePath]) {//非自定义类，不做监听
            return [propertyNamesM copy];
        }
        
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for(int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = [NSString stringWithUTF8String:propertyName];
            [propertyNamesM addObject:key];
        }
    } while ((class = [class superclass]));
    return [propertyNamesM copy];
}

+ (NSString *)defaultSignature {
    NSMutableArray<NSString *> *signatureComponents = [[self customPropertyNames] mutableCopy];
    [signatureComponents sortUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString *signature = @([[signatureComponents componentsJoinedByString:@":"] hash]).description;
    
    unsigned char output[CC_MD5_DIGEST_LENGTH];
    CC_MD5(signature.UTF8String, (CC_LONG)strlen(signature.UTF8String), output);
    NSMutableString *hash = [NSMutableString string];
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", output[i]];
    }
    
    return [hash copy];
}

+ (NSString *)modelFolderPath {
    NSMutableArray *componentsM = [NSMutableArray array];
    [componentsM addObject:NSHomeDirectory()];
    [componentsM addObject:@"Library"];
    [componentsM addObject:@"ICModel"];
    [componentsM addObject:NSStringFromClass(self)];
    NSString *path = [NSString pathWithComponents:[componentsM copy]];
    return path;
}

//模型对象路径
+ (NSString *)modelPathWithFolderPath:(NSString *)folderPath signature:(NSString *)signature {
    NSMutableArray *componentsM = [NSMutableArray array];
    [componentsM addObject:folderPath];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@", NSStringFromClass([self class]), signature];
    [componentsM addObject:fileName];
    NSString *path = [NSString pathWithComponents:[componentsM copy]];
    return path;
}

+ (NSValue *)nilValue:(NSValue *)value {
    NSString *type = [NSString stringWithUTF8String:value.objCType];
    if ([type isEqualToString:@"c"]) {
        return [NSNumber numberWithChar:0];//char
    } else if ([type isEqualToString:@"i"]) {
        return [NSNumber numberWithInt:0];//int
    } else if ([type isEqualToString:@"s"]) {
        return [NSNumber numberWithShort:0];//short
    } else if ([type isEqualToString:@"l"]) {
        return [NSNumber numberWithLong:0];//long
    } else if ([type isEqualToString:@"q"]) {
        return [NSNumber numberWithLongLong:0];//long long
    } else if ([type isEqualToString:@"C"]) {
        return [NSNumber numberWithUnsignedChar:0];
    } else if ([type isEqualToString:@"I"]) {
        return [NSNumber numberWithUnsignedInt:0];
    } else if ([type isEqualToString:@"S"]) {
        return [NSNumber numberWithUnsignedShort:0];
    } else if ([type isEqualToString:@"L"]) {
        return [NSNumber numberWithUnsignedLong:0];
    } else if ([type isEqualToString:@"Q"]) {
        return [NSNumber numberWithUnsignedLongLong:0];
    } else if ([type isEqualToString:@"f"]) {
        return [NSNumber numberWithFloat:0.];
    } else if ([type isEqualToString:@"d"]) {
        return [NSNumber numberWithDouble:0.];
    } else if ([type isEqualToString:@"B"]) {
        return [NSNumber numberWithBool:NO];
    }
    return nil;
}

@end
