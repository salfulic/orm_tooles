# Created in project .
# User: acer
# Date: 13-7-7
# Time: 下午2:32
# To change this template use File | Settings | File Templates.

User = require './user'

do ->
#  console.dir User
  condition = [
    {'join':"",'column':'id','condition':'=','val':15}
  ]
  order = [{column:'id',types:'DESC'}]
  User.selectById(condition,order)

  values = {'id':1,'name':'Tom','phone':'18902931923',"create_at":new Date()}
  condition = [
    {'join':"",'column':'id','condition':'=','val':1}
  ]
  User.insertOne(values,condition)
#  console.log (new Date() instanceof Date)
  User.updateOne(values,condition)