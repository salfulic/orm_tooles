###
# 1对n的对象关系组件
###
# Created in project .
# User: acer
# Date: 13-7-9
# Time: 下午10:59
# To change this template use File | Settings | File Templates.

logger = require 'logger'
One2One = require './one2one'
_ = require "underscore"

One2Many = _.extend {}, One2One,
  #一对多的对应关系默认不限制查询数量
  _limit : [0,0]

module.exports = One2Many

do ->
#  console.log "aaaaaaaaaaaaaaaaaaaaaaaaaa"
  console.dir One2Many
#  console.log "bbbbbbbbbbbbbbbbbbbbbbbbbbb"
