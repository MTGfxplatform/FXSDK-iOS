//
//  FXMacroDefine.h
//  FX
//
//  Created by FXMVP on 2021/9/26.
//

#ifndef FXMacroDefine_h
#define FXMacroDefine_h


#define SINGLETON_INTERFACE(className) +(className*)sharedInstance;

#define SINGLETON_IMPLE(className) \
+ (className*)sharedInstance { \
static className* s_pInstance; \
@synchronized(self) { \
if (nil == s_pInstance) { \
     s_pInstance = [[[self class] alloc] init]; \
} \
return s_pInstance; \
} \
}

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height


#define DLog(fmt, ...) {\
printf("===================================================\n\n");\
{NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}\
printf("\n===================================================\n");}\


//#ifdef DEBUG
//#define ALog(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
//#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
//#else
//#define ALog(fmt, ...)
//#define DLog(fmt, ...)
//#define NSLog(...) {}
//#endif

#ifdef DEBUG
#define MAssert(fmt) assert(fmt)
#else
#define MAssert(fmt)  {}
#endif



#define weakFXSelf __weak typeof(self) _weak_self = self;
#define strongFXSelf __strong typeof(_weak_self) self = _weak_self;
#define weak(obj) __weak typeof(obj) _weak_##obj = obj;
#define strong(obj) __strong typeof(_weak_##obj) obj = _weak_##obj;



#define kISNullString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )













#endif /* FXMacroDefine_h */
