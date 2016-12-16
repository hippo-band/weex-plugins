//
//  WXGCanvasModule.m
//  Pods
//
//  Created by 兵长 on 16/8/16.
//
//

#import "WXGCanvasModule.h"
#import "WXGCanvasComponent.h"
#import <GCanvas/GCVCommon.h>
#import <GCanvas/GCanvasPlugin.h>
#import <WeexSDK/WXComponentManager.h>


@interface WXGCanvasModule()<GLKViewDelegate>
@property(nonatomic, weak) WXGCanvasComponent *gcanvasComponent;
@property(nonatomic, strong) NSString* componentRel;
@property(nonatomic, strong) GCanvasPlugin* gcanvasPlugin;
@end



@implementation WXGCanvasModule

@synthesize weexInstance;

- (void)dealloc
{
    [[GCVCommon sharedInstance] clearLoadImageDict];
}


WX_EXPORT_METHOD(@selector(getDeviceInfo:callback:));
- (void)getDeviceInfo:(NSDictionary *)args callback:(WXModuleCallback)callback{
    callback(@{@"result":@"success", @"data":@{@"platform":@"iOS"}});
}

WX_EXPORT_METHOD(@selector(enable:callback:));
- (void)enable:(NSDictionary *)args callback:(WXModuleCallback)callback{
    GCVLOG_METHOD(@"args=%@", args);
    if (!args || !args[@"componentId"]){
        callback(@{@"result":@"fail", @"errorMsg":@"input args is error."});
        return;
    }
    self.componentRel = args[@"componentId"];//由于component的初始化可能比module慢，所以只在第一次使用时在对component进行初始化处理
    
    self.gcanvasPlugin = [[GCanvasPlugin alloc] init];
    callback(@{@"result":@"success"});
}

WX_EXPORT_METHOD(@selector(render:));
- (void)render:(NSDictionary *)commands {
    GCVLOG_METHOD(@"commands=%@, gcanvasComponent=%@", commands, self.gcanvasComponent);
    
    [self.gcanvasPlugin addCommands:commands];
    [self execCommand];
}



//预加载image，便于后续渲染时可以同步执行
WX_EXPORT_METHOD(@selector(preLoadImage:callback:));
- (void)preLoadImage:(NSDictionary *)args callback:(WXModuleCallback)callback{
    
    GCVLOG_METHOD(@" start...");
    
    [[GCVCommon sharedInstance] addPreLoadImage:args[@"commands"] completion:^(GCVImageCache *imageCache) {
        [self execCommand];
    }];
}

//预加载image，便于后续渲染时可以同步执行
WX_EXPORT_METHOD(@selector(setContextType:));
- (void)setContextType:(NSDictionary *)args{
}

- (WXGCanvasComponent *)gcanvasComponent{
    if (!_gcanvasComponent){
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        WXPerformBlockOnComponentThread(^{
            _gcanvasComponent = (WXGCanvasComponent *)[self.weexInstance componentForRef:self.componentRel];
            GCVLOG_METHOD(@" _gcanvasComponent=%@", _gcanvasComponent);
            if (_gcanvasComponent && [_gcanvasComponent isKindOfClass:[WXGCanvasComponent class]]){
                _gcanvasComponent.glkview.delegate = self;
            }
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }
    return _gcanvasComponent;
}


- (void)execCommand{
    GCVLOG_METHOD(@" start... self.gcanvasComponent=%@", self.gcanvasComponent);
    if (self.gcanvasComponent){
        if ([_gcanvasComponent isKindOfClass:[WXGCanvasComponent class]]){//若类型正确，则执行display。不增加的话，直接丢弃命令。
            
            GCVLOG_METHOD(@" call glkView display");
            [self.gcanvasComponent.glkview display];
        }else{
            [self.gcanvasPlugin removeCommands];
        }
        
    }else{
        [self performSelector:@selector(execCommand) withObject:nil afterDelay:0.05f];//由于启动速度不一致的原因，第一次执行时未必能拿到对应的component，所以这样增加一个重试机制，每50ms重试一次。最多重试N次。（其实这里理论上不会出现一直重试的可能 ，应该若传入的是一个不存在的component，则会在js层之间报错了。）
    }
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect {
    GCVLOG_METHOD(@"rect=(%.2f, %.2f) * (%.2f, %.2f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    if(!self.gcanvasComponent.glkview.context){
        return;
    }
    [EAGLContext setCurrentContext:self.gcanvasComponent.glkview.context];
    
    
    if (!CGRectEqualToRect(self.gcanvasComponent.componetFrame, CGRectZero)){
        
        [self.gcanvasPlugin setFrame:self.gcanvasComponent.componetFrame];
        self.gcanvasComponent.componetFrame = CGRectZero;
    }
    
//    glClearColor(0, 0, 1, 0.5);
//    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.gcanvasPlugin execCommands];
}


@end



