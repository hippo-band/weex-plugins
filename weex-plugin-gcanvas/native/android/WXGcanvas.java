package com.alibaba.weex.extend.component;


import android.content.Context;
import android.opengl.GLSurfaceView;

import com.taobao.gcanvas.GCanvas;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.common.Component;
import com.taobao.weex.dom.WXDomObject;
import com.taobao.weex.ui.ComponentCreator;
import com.taobao.weex.ui.component.WXComponent;
import com.taobao.weex.ui.component.WXVContainer;


import java.lang.reflect.InvocationTargetException;


@Component(lazyload = false)
public class WXGcanvas extends WXComponent<GLSurfaceView> {


    public static class Creator implements ComponentCreator {
        public WXComponent createInstance(WXSDKInstance instance, WXDomObject node, WXVContainer parent, boolean lazy) throws IllegalAccessException, InvocationTargetException, InstantiationException {
            return new com.alibaba.weex.extend.component.WXGcanvas(instance, node, parent, lazy);
        }
    }


    @Deprecated
    public WXGcanvas(WXSDKInstance instance, WXDomObject dom, WXVContainer parent, String instanceId, boolean isLazy) {
        this(instance, dom, parent, isLazy);
    }

    public WXGcanvas(WXSDKInstance instance, WXDomObject node,
                     WXVContainer parent, boolean lazy) {
        super(instance, node, parent, lazy);
    }

    @Override
    protected GLSurfaceView initComponentHostView(Context context) {


        WXGCanvasGLSurfaceView view = new WXGCanvasGLSurfaceView(getContext(), null);

        registerActivityStateListener();
        return view;
    }


    @Override
    public void onActivityDestroy() {

        if (GCanvas.fastCanvas != null) {
            GCanvas.fastCanvas.onDestroy();
            GCanvas.fastCanvas = null;
        }

    }


}





