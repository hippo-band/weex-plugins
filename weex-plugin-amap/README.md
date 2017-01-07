# weex-plugin-amap

一款高德地图weex插件，支持定位，缩放等地图常用操作

### 快速开始

``` bash
weexpack plugin add weex-plugin-amap
```

编辑你的weex文件

``` we
<template>
  <div class="container">
      <weex-amap class="map" geolocation="true" toolbar="true"></weex-amap>
  </div>
</template>

<style>
  .map{
    width:100%;
    height: 300;
    background-color: #000;
  }
</style>

<script>
  module.exports = {
    data: {
        
    }
  }
</script>
```

### 方法

+ setCenter(x,y) 指定地图的中心点 

+ setZoomEnable() 设置用户是否缩放 true/false

+ getGeolocation 获取用户定位信息 return Object

+ addMarker 用户自行标记




