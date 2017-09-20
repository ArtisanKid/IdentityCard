//
//  ICCoding.h
//  Pods
//
//  Created by 李翔宇 on 16/2/16.
//
//

#ifndef ICCoding_h
#define ICCoding_h
 
#import <YYModel/YYModel.h>

//ARC下标准的NSCoding实现（借助YYModel）

#define ICCoding \
\
    - (id)initWithCoder:(NSCoder *)decoder {\
        if (self = [super init]) {\
            [self yy_modelInitWithCoder:decoder];\
        }\
        return self;\
    }\
\
    - (void)encodeWithCoder:(NSCoder *)encoder {\
        [self yy_modelEncodeWithCoder:encoder];\
    }

#endif /* ICCoding_h */
