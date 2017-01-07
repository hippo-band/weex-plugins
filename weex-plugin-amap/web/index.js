'use strict'

const defaultAttr = {
  zoom: 11,
  resizeEnable: true,
}

// prototype methods.
const proto = {
  create () {
    const node = document.createElement('div');
    this.mapwrap = document.createElement('div');
    this.mapwrap.id = 'map' + (new Date()).getTime().toString().substring(9,3) + parseInt(Math.random() * 10000);
  
    this.mapwrap.append(document.createTextNode('高德地图加载中...'));
    var lib = document.createElement('script');
    lib.src = 'http://webapi.amap.com/maps?v=1.3';
    lib.addEventListener('load',function() {
      window.maploaded = true;
    })
    this.mapwrap.append(lib);
    node.appendChild(this.mapwrap);
    this.ready();
    return this.mapwrap;
  },
  ready () {
    let self = this;
    console.log(self);
    let intval = window.setInterval(function() {
      if(window.AMap) {
        self.map = new AMap.Map(self.mapwrap.id, {
          center:[117.000923,36.675807],
          zoom:11
        });
        AMap.plugin(['AMap.ToolBar'],() => {
          self.map.addControl(new AMap.ToolBar());
        });
        clearInterval(intval);
      }  
    },100);    
  }
  
}



const attr = {
  value (val) {
    this.value = val
    this.inner.textContent = `Hello ${val}!`
  },
  geolocation(val) {
    let self = this;
    if(val) {
      console.log(val);
      
    }   
  }
}

// style setters.
const style = {
  
}

// event config.
const event = {
  
}

function init (Weex) {
  const Component = Weex.Component
  const extend = Weex.utils.extend

  function Amap (data) {
    Component.call(this, data)
  }

  Amap.prototype = Object.create(Component.prototype);
  extend(Amap.prototype, proto)
  extend(Amap.prototype, { attr })
  extend(Amap.prototype, {
    style: extend(Object.create(Component.prototype.style), style)
  })
  extend(Amap.prototype, { event });

  Weex.registerComponent('weex-amap', Amap);
}

export default { init }