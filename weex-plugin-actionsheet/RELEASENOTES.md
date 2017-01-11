#### ActionSheet
* 名字
 - actionSheet
* 类型
 - module
* 平台
 - 三端
* api
   1. 调用actionSheet
      - create(dictionary options)   调用actionSheet
          - options:actionSheet数据源(dictionary)<br />
            items：actionSheet数据源(array)
      - callback(options) 选择完成按钮确认回调
         - options:返回的选择结果(dictionary)<br />
         result:结果三种类型 success,cancel,error (string)<br />
         data:选择的值(string)<br />
         message:选择信息'ok','error info'(sting)

