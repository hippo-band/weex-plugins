package com.alibaba.weex.extend.component;


import android.content.Context;

import com.taobao.gcanvas.GCanvas;
import com.taobao.gcanvas.GLog;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.common.Component;
import com.taobao.weex.dom.WXDomObject;
import com.taobao.weex.ui.ComponentCreator;
import com.taobao.weex.ui.component.WXComponent;
import com.taobao.weex.ui.component.WXVContainer;
import com.taobao.weex.ui.module.GcanvasModule;


import java.lang.reflect.InvocationTargetException;


@Component(lazyload = false)
public class WXGcanvasComponent extends WXComponent<WXGCanvasGLSurfaceView> {

    public static class Creator implements ComponentCreator {
        @Override
        public WXComponent createInstance(WXSDKInstance wxsdkInstance, WXDomObject wxDomObject, WXVContainer wxvContainer) throws IllegalAccessException, InvocationTargetException, InstantiationException {
            return new com.alibaba.weex.extend.component.WXGcanvasComponent(wxsdkInstance, wxDomObject, wxvContainer, false);
        }
    }


    @Deprecated
    public WXGcanvasComponent(WXSDKInstance instance, WXDomObject dom, WXVContainer parent, String instanceId, boolean isLazy) {
        this(instance, dom, parent, isLazy);
    }

    public WXGcanvasComponent(WXSDKInstance instance, WXDomObject node,
                              WXVContainer parent, boolean lazy) {
        super(instance, node, parent, lazy);
    }

    @Override
    protected WXGCanvasGLSurfaceView initComponentHostView(Context context) {

        registerActivityStateListener();

        WXGCanvasGLSurfaceView view = new WXGCanvasGLSurfaceView(context, null);

        return view;
    }


    @Override
    public void onActivityDestroy() {

        if (GCanvas.fastCanvas != null) {

            GCanvas.fastCanvas.onDestroy();
            GCanvas.fastCanvas = null;
        }

        GcanvasModule.sRef = null;
        
    }


}





