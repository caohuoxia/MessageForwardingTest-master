//
//  PersonModel.m
//  
//
//  Created by 黄龙辉 on 15/9/18.
//
//

#import "PersonModel.h"
#import "CompanyModel.h"
//动态运行时必须添加这个头文件
#import <objc/runtime.h>

@interface PersonModel()

@property(nonatomic, strong)CompanyModel *companyModel;

@end

@implementation PersonModel
//dynamic修饰的属性，编译器不会自动生成getter和setter，要程序员自己手动添加相应方法
//下面resolveInstanceMethod里面就动态添加setter和getter方法
@dynamic name;


- (id)init{
    
    self = [super init];
    if (self) {
        _companyModel = [[CompanyModel alloc] init];
    }
    
    return self;
}


+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"resolveInstanceMethod");
    
    NSString *selStr = NSStringFromSelector(sel);
    if ([selStr isEqualToString:@"name"]) {
        class_addMethod(self, sel, (IMP)nameGetter, "@@:");
        return YES;
    }
    if ([selStr isEqualToString:@"setName:"]) {
        class_addMethod(self, sel, (IMP)nameSetter, "v@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
//
////下面不会打印日志
//+(BOOL)resolveClassMethod:(SEL)sel{
//    NSLog(@"resolveClassMethod");
//    return [super resolveClassMethod:sel];
//}
//
void nameSetter(id self, SEL cmd, id value){
    NSString *fullName = value;
    NSArray *nameArray = [fullName componentsSeparatedByString:@" "];
    PersonModel *model = (PersonModel *)self;
    model.firstName = nameArray[0];
    model.lastName  = nameArray[1];
}

id nameGetter(id self, SEL cmd){
    
    PersonModel *model = (PersonModel *)self;
    NSMutableString *name = [[NSMutableString alloc] init];
    if (nil != model.firstName) {
        [name appendString:model.firstName];
        [name appendString:@" "];
    }
    if (nil != model.lastName) {
        [name appendString:model.lastName];
    }
    return name;
}


- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    NSString *selStr = NSStringFromSelector(aSelector);
    if ([selStr isEqualToString:@"companyName"]) {
        return self.companyModel;
    }else{
        return [super forwardingTargetForSelector:aSelector];
    }
}


//这个方法必须有，否则也是奔溃
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
//    NSMethodSignature *sig = nil;
//    NSString *selStr = NSStringFromSelector(aSelector);
//    if ([selStr isEqualToString:@"deptName"]) {
//        //此处返回的sig是方法forwardInvocation的参数anInvocation中的methodSignature
//        //只要选择器名称一致就ok，@selector(deptName:)和@selector(deptName) 是一样的
//        sig = [self.companyModel methodSignatureForSelector:@selector(deptName:)];
//    }else{
//        sig = [super methodSignatureForSelector:aSelector];
//    }
//    return sig;
    if(aSelector == @selector(deptName))
    {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];//这样竟然也是可以的
    }
    return nil;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
    NSString *selStr = NSStringFromSelector(anInvocation.selector);
    if ([selStr isEqualToString:@"deptName"]) {
        //有点不是很明白，target和选择器都指定了，为何一定要实现methodSignatureForSelector方法呢？？？
        [anInvocation setTarget:self.companyModel];
        [anInvocation setSelector:@selector(huoxia)];
//        BOOL hasCompanyName = NO;
//        //第零个和第一个参数是target和sel
//        [anInvocation setArgument:&hasCompanyName atIndex:2];
        [anInvocation retainArguments];
        [anInvocation invoke];
    }else{
        [super forwardInvocation:anInvocation];
    }
}

@end
