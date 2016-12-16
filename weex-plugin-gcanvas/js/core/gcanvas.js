var GBridge = require("./gutil").GBridge;
var GLog = require("./gutil").GLog;
//var GContextWebGL = require('./gwebgl');
var GContext2D = require('./gcontext2d');

///////////////////////////////
var GSupport = {};
GSupport.renderMode = 0;// 0--RENDERMODE_WHEN_DIRTY, 1--RENDERMODE_CONTINUOUSLY
GSupport.hybridLayerType = -1;// 0--LAYER_TYPE_NONE 1--LAYER_TYPE_SOFTWARE 2--LAYER_TYPE_HARDWARE. change hybrid layer type from LAYER_TYPE_SOFTWARE to unset, avoid block when use html5 audio.
GSupport.checkType = 0;// 0--all support, 1--white list check
GSupport.nativeVer = 0;
GSupport.defaultHiQualityMode = true; // false-- normal true--hiQuality
GSupport.supportScroll = false;
GSupport.newCanvasMode = false;             //true: GCanvasView in Webview
GSupport.sameLevel = false; //newCanvasMode = true && true: GCanvasView and Webview is same level;
GSupport.clearColor = "white";
GSupport.WHITE_LIST = [
    model_check = [
        function(info) {return info.MODEL == 'GT-I9300';},
        function(info) {return info.MODEL == 'GT-I9500';},
        function(info) {return info.MODEL == 'GT-N7108';},
        function(info) {return info.MODEL == 'HIKe 848A';},
        function(info) {return info.MODEL == 'HTC 601e';},
        function(info) {return info.MODEL == 'HUAWEI C8813';},
        function(info) {return info.MODEL == 'Lenovo K900';},
        function(info) {return info.MODEL == 'M351';},
        function(info) {return info.MODEL == 'M51w';},
        function(info) {return info.MODEL == 'MI 3';},
        function(info) {return info.MODEL == 'MI 3W';},
        function(info) {return info.MODEL == 'SM-G9006V';},
        function(info) {return info.MODEL == 'SM-N9006';}
    ],
    version_check = [
        function(info) {GLog.d("info.OS_RELEASE=" + info.OS_RELEASE); return false;},
        function(info) {return (info.OS_RELEASE >= '4.1.0')&&( info.OS_RELEASE <= '4.4.2');}
    ]
];


GSupport.checkList = function(successFunc, failureFunc){
    var checkType = GSupport.checkType;
    GLog.d("[checkList] checkType:" + checkType);
    if (1 == checkType) {//white list check
        var whitelist = GSupport.WHITE_LIST;
        var length = whitelist.length;
        for (var i = 0; i < length; i++) {
            var lenSub = whitelist[i].length;
            var found = false;
            for (var j = 0; j < lenSub; j++){
                if (whitelist[i][j](GDeviceInfo)) {
                    found = true;
                    break;
                }
            }
            if (!found){ // unfound in white list
                GLog.d("the device is not supported, " + GDeviceInfo.MODEL);
                failureFunc&&failureFunc();
                return;
            }
        }
    }
    successFunc&&successFunc();
};
///////////////////////////////

var GDeviceInfo = {};
var _context = null;
var _context_type = 0;//0--2d;1--webgl
///////////////////////////////

var GCanvasPlatform = 2;//0--H5;1--iOS;2--Android

var GCanvas = {
    start: function (ref, succ, fail) {
        GLog.d('gcanvas#start=====>>>');

        //bind canvas
        var config = [];
        config.push(GSupport.renderMode);
        config.push(GSupport.hybridLayerType);
        config.push(GSupport.supportScroll);
        config.push(GSupport.newCanvasMode);
        config.push(1);//compatible. 1 will call GCanvasJNI.getAllParameter("gcanvas");
        config.push(GSupport.clearColor);
        config.push(GSupport.sameLevel);
        GBridge.callEnable(ref,config,function(e){

        });
        //get device
        GBridge.getDeviceInfo(function(e){//这里是异步操作

          GCanvasPlatform = 2;
          succ();
          /*
            if(e && e.result === 'success'){
                if (e.data && e.data.platform == "iOS"){
                    GCanvasPlatform = 1;
                    succ();
                }else{
                    var info = JSON.parse(e.data);
                    if(info.GCANVASLIBENABLE && info.IS_AVAILABLE){
                        GDeviceInfo = info;
                        //检查
                        GSupport.checkList(succ,fail);
                    }else{
                        fail&&fail();
                    }
                }
            }else{
                fail&&fail();
            }
            */
        });

    },
    getContext: function (contextID) {

        if (_context){
            return _context;//unsupport change type after create
        }

         if (contextID.match(/webgl/i)){
            if (!_context) {
                _context = new GContextWebGL();
            }
            _context_type = 1;
        }else{
            _context = new GContext2D();
            _context_type = 0;
        }


        //GCanvas._toNative(null, null, 'GCanvas', 'setContextType', [this._context_type]);
        GBridge.setContextType(_context_type);
        return _context;
    },

    disable: function(){
        GBridge.callDisable();
    }
};
module.exports = GCanvas;
