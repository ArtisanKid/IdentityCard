//
//  IdentityCardMacros.h
//  Pods
//
//  Created by 李翔宇 on 2016/12/17.
//

#ifndef IdentityCardMacros_h
#define IdentityCardMacros_h

#if DEBUG
    #define IdentityCardLog(_Format, ...)\
    do {\
        NSString *file = [NSString stringWithUTF8String:__FILE__].lastPathComponent;\
        NSLog((@"\n[%@][%d][%s]\n" _Format), file, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__);\
        printf("\n");\
    } while(0)
#else
    #define ICModelLog(_Format, ...)
#endif

//nil和类型判断
//_stuff传入{}(代码块)

#define ICQQ_String_Nilable_Return(_string, _nilable, _stuff, ...) \
    do {\
        NSString *string = (NSString *)(_string);\
        if(string) {\
            if(![string isKindOfClass:[NSString class]]) {\
                NSAssert(0, nil);\
                _stuff;\
                return __VA_ARGS__;\
            }\
            \
            if(!_nilable) {\
                if(!string.length) {\
                    NSAssert(0, nil);\
                    _stuff;\
                    return __VA_ARGS__;\
                }\
            }\
        } else if(!_nilable) {\
            NSAssert(0, nil);\
            _stuff;\
            return __VA_ARGS__;\
        }\
    } while(0)

#endif /* IdentityCardMacros_h */
