###
# 1对1的对象关系组件
###
# User: acer
# Date: 13-7-6
# Time: 下午4:50
# To change this template use File | Settings | File Templates.、、

logger = require 'logger'
moment = require 'moment'

# MySQL 接受时间格式
TIME_FORMAT = "YYYY-MM-DD HH:mm:ss"

One2One =
  #数据库表命
  _dbTable:null
  #数据库的主键名
  _primaryKey : 'id'
  #INSERT or UPDATE {true:INSERT,false:UPDATE}
  _isUpsert : false
  #查询页数 TODO 分页查询逻辑目前先由外部程序自行完成，即直接更新@_limit值
  _pages : 0
  #limit 起始数 TODO 分页查询逻辑目前先由外部程序自行完成，即直接更新@_limit值
  _start:0
  #limit 需要导出的数量 TODO 分页查询逻辑目前先由外部程序自行完成，即直接更新@_limit值
  _rows:1
  #limit
  _limit : [0,1]

  # 查询条件
  ### 格式[{
    join: 'AND' or 'OR' or 'IN' or ''
    column: '列名'
    condition ：‘=’ or 'like'
    val: 'value'
   }...]
  ###
  _extraCondition: []

  ###
  # 排序方式
    格式[{
      column:'列名'
      types: 'ASC' or 'DESC'
  }...]
  ###
  _extraOrder : []

  # 是否为可更新或插入的模型
#  _isUpsert: false

  #设置表名的方法
  table:(dbTable)->
    if dbTable
      @_dbTable = dbTable

  # 设置主键的方法
  primaryKey: (args...) ->
    unless arguments.length
      return @_primaryKey
    else if arguments.length == 1
      @_primaryKey = args[0]
    else
      @_primaryKey = args

  #需要查询的数据字段
  # 格式：[clum1,clum2...]
  selectColumn : (selectColumn) ->
    @_selectColumn= selectColumn

  #需要更新和插入的字段和数据
  # 格式：{clum1:val1,clum2:val2...}
  upsertValues : (upsertValues) ->
    @_upsertValues = upsertValues

  #limit设置 TODO 错误数据是否需要验证？
  limit: (limit=1) ->
    unless arguments.length then @_limit else @_limit = limit

  #查询条件参数设置
  extraCondition: (condition) ->
    @_extraCondition = condition

  #排序方式
  extraOrder:(order) ->
    @_extraOrder = order

  #生成SELECT SQL语句
  createSelectSQL : (isCount = false) ->
    return null unless @_dbTable
    sql = 'SELECT'
    unless @_selectColumn? and Array.isArray(@_selectColumn) and @_selectColumn.length
      if isCount
        sql = sql.concat " COUNT(#{@_primaryKey})"
      else
        sql = sql.concat " *"
    else
      for index,column of @_selectColumn
        sql = sql.concat " `#{column}`"
        sql = sql.concat "," if index < @_selectColumn.length-1

    sql = sql.concat " FROM `#{@_dbTable}`"
    if @_extraCondition? and Array.isArray(@_extraCondition) and @_extraCondition.length
      sql = sql.concat " WHERE"
      for val in @_extraCondition
        sql = sql.concat " #{val.join} `#{val.column}` #{val.condition} #{val.val}"

    if @_extraOrder? and Array.isArray(@_extraOrder) and @_extraOrder.length
      sql = sql.concat " ORDER BY"
      for index2, val of @_extraOrder
        sql = sql.concat " `#{val.column}` #{val.types}"
        sql = sql.concat "," if index2 < @_extraOrder.length-1
    sql = sql.concat " LIMIT #{@_limit[0]},#{@_limit[1]};"
    return sql

  #生成INSERT UPDATE SQL 语句
  createUpsertSQL : (isUpsert = false)->
    return null unless @_dbTable and @_upsertValues
    columns = []
    values = []
    if isUpsert
      for key,val of @_upsertValues
#        console.log "val:#{val} key:#{key}"
        columns.push "`#{key}`"
        values.push @_filterModelForMySQL(val)
      sql = "INSERT INTO `#{@_dbTable}` (#{columns.toString()}) VALUES(#{values.toString()});"
      return sql
    else
      sql = "UPDATE `#{@_dbTable}` SET"
      for  key, val of @_upsertValues
        columns.push " `#{key}`"
        values.push @_filterModelForMySQL(val)
      unless columns.length == values.length
        throw new Error(" columns number is #{columns.length} values number is #{values.length}")
      for index,key of columns
        sql = sql.concat " #{key} = #{values[index]}"
        if index <= @_upsertValues.length-1
          sql = sql.concat ","

      if @_extraCondition? and Array.isArray(@_extraCondition) and @_extraCondition.length
        sql = sql.concat " WHERE"
        for val in @_extraCondition
          sql = sql.concat " #{val.join} `#{val.column}` #{val.condition} #{@_filterModelForMySQL(val.val)}"
      return sql.concat(";")

  # 对模型数据进行验证
  _filterModelForMySQL: (value) ->
    if typeof(value) == 'string'
#      logger.log "[one2one::142]: ssssssssssssssssssssssssssssssssssssssss"
      value = escape value
    else if typeof(value) == 'number'
#      logger.log "[one2one::145]: nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
      value = parseInt value, 10
    else if (value instanceof Date)
#      logger.log "[one2one::146]: dddddddddddddddddddddddd"
      value = @_filterValueAsDateForMySQL value
    return "'#{value}'"

  # 将日期对象转换为 MySQL 格式的字符串
  _filterValueAsDateForMySQL: (value) ->
#    return ""
    return "#{moment(value).format TIME_FORMAT}"

## Exports
module.exports = One2One
#do ->
#  console.log "aaaaaaaaaaaaaaaaaaaaaaaaaa"
##  o2o = new One2One()
#  console.dir One2One
#  o2o = new One2One()
#  console.dir o2o
#  console.dir o2o._limit

