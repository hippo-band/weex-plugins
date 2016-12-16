//
//  WXGCanvasComponent.h
//  Pods
//
//  Created by 兵长 on 16/8/16.
//
//

#import <UIKit/UIKit.h>
#import <GCanvas/GCanvasPlugin.h>
#import <WeexSDK/WXComponent.h>

@interface WXGCanvasComponent : WXComponent


@property(nonatomic, strong) GCanvasPlugin* gcanvasPlugin;
@property(nonatomic, strong) GLKView* glkview;

@property(nonatomic, assign) CGRect componetFrame;
@end
