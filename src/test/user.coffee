# Created in project .
# User: acer
# Date: 13-7-7
# Time: 下午2:45
# To change this template use File | Settings | File Templates.

logger = require "logger"
_ = require "underscore"
One2One = require '../mixin/one2one'


class User
  _.extend this, One2One
  @table('user')
  @selectColumn(['id','name','phone'])
  @limit([0,10])

  @selectById = (condition,order,limit) ->
    @extraCondition(condition)
    @extraOrder(order)
    @limit(limit) if limit
    sql = @createSelectSQL(true)
    logger.log "[user:selectById:31]: sql:#{sql}"

  @insertOne = (values,condition) ->
    @upsertValues(values)
    @extraCondition(condition)
    sql = @createUpsertSQL(true)
    logger.log "[user::34]: sql:#{sql}"

  @updateOne = (values,condition) ->
    @upsertValues(values)
    @extraCondition(condition)
    sql = @createUpsertSQL()
    logger.log "[user::34]: sql:#{sql}"

module.exports = User

#do ->
#  console.dir exports.User
#  console.log User.selectById
#  User.selectById(20)