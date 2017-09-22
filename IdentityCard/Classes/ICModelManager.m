//
//  ICModelManager.m
//  IdentityCard
//
//  Created by 李翔宇 on 2017/9/19.
//

#import "ICModelManager.h"
#import "IdentityCardMacros.h"
#import "NSMutableDictionary+ICExtension.h"

@interface ICModelManager()

//{object, [keyPath]}
@property (nonatomic, strong) NSMutableDictionary<id, NSMutableArray<NSString *> *> *targetKeyPathsM;
@property (nonatomic, strong) dispatch_queue_t archive_serial_queue;

@end

@implementation ICModelManager

+ (ICModelManager *)manager {
    static ICModelManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (id)alloc {
    return [self manager];
}

+ (id)allocWithZone:(NSZone * _Nullable)zone {
    return [self manager];
}

- (id)copy {
    return self;
}

- (id)copyWithZone:(NSZone * _Nullable)zone {
    return self;
}

#pragma mark - Public Method

+ (void)observe:(id)target keyPath:(NSString *)firstKeyPath, ... {
    NSString *keyPath = firstKeyPath;
    va_list argList;
    va_start(argList, firstKeyPath);
    do {
        if(![keyPath isKindOfClass:[NSString class]]
           || !keyPath.length) {
            continue;
        }

        NSMutableArray *keyPathsM = [self.manager.targetKeyPathsM ic_keyPathsForObject:target];
        if([keyPathsM containsObject:keyPath]) {
            continue;
        }

        [keyPathsM addObject:keyPath];
        [target addObserver:self.manager forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    } while ((keyPath = va_arg(argList, id)));
    va_end(argList);
}

+ (void)ignore:(id)target keyPath:(NSString *)firstKeyPath, ... {
    NSString *keyPath = firstKeyPath;
    va_list argList;
    va_start(argList, firstKeyPath);
    do {
        if(![keyPath isKindOfClass:[NSString class]]
           || !keyPath.length) {
            continue;
        }
        
        NSMutableArray *keyPathsM = [self.manager.targetKeyPathsM ic_keyPathsForObject:target];
        if(![keyPathsM containsObject:keyPath]) {
            continue;
        }

        [keyPathsM removeObject:keyPath];
        [target removeObserver:self.manager forKeyPath:keyPath];
    } while ((keyPath = va_arg(argList, id)));
    va_end(argList);
}

+ (void)pause:(id)target {
    NSArray *keyPaths = [self.manager.targetKeyPathsM[target] copy];
    [keyPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull keyPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [target removeObserver:self.manager forKeyPath:keyPath];
    }];
}

+ (void)resume:(id)target {
    NSArray *keyPaths = [self.manager.targetKeyPathsM[target] copy];
    [keyPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull keyPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [target addObserver:self.manager forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }];
}

+ (void)remove:(id)target {
    [self pause:target];
    self.manager.targetKeyPathsM[target] = nil;
}

#pragma mark - 重载方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    IdentityCardLog(@"%@ 变更属性 %@，%@ -> %@", object, keyPath, change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);
    dispatch_async(self.archive_serial_queue, ^{
        if([object conformsToProtocol:@protocol(ICModelProtocol)]) {
            [object cacheSingleton];
        }
    });
}

#pragma mark - Property Method
- (NSMutableDictionary *)targetKeyPathsM {
    if(_targetKeyPathsM) {
        return _targetKeyPathsM;
    }
    
    _targetKeyPathsM = [NSMutableDictionary dictionary];
    return _targetKeyPathsM;
}

- (dispatch_queue_t)archive_serial_queue {
    if(_archive_serial_queue) {
        return _archive_serial_queue;
    }
    
    const char *queue_label = [NSBundle.mainBundle.bundleIdentifier stringByAppendingFormat:@".%@.serial", NSStringFromClass([self class])].UTF8String;
    _archive_serial_queue = dispatch_queue_create(queue_label, DISPATCH_QUEUE_SERIAL);
    return _archive_serial_queue;
}

@end
