# Description 

# Created with Project 
# User  YuanXiangDong
# Date  13-7-4
# To change this template use File | Settings | File Templates.

fs = require 'fs'
http = require 'http'
https = require('https');

options = {
  host:'192.168.90.241',
  port:'8088',
  method:'GET'
  path: 'https://docs.google.com/spreadsheet/pub?key=0Ap0bfNc2zisXdDlOUmxYRUpDRXR5bmdRckJKMWtuSUE&single=true&gid=0&range=B2%3AC9999&output=txt'
#  path : 'http://baidu.com'
}
urls = "https://docs.google.com/spreadsheet/pub?key=0Ap0bfNc2zisXdDlOUmxYRUpDRXR5bmdRckJKMWtuSUE&single=true&gid=0&range=B2%3AC9999&output=txt"
url = "http://baidu.com"

#try
#  fs.readFile 'https://docs.google.com/spreadsheet/pub?key=0Ap0bfNc2zisXdDlOUmxYRUpDRXR5bmdRckJKMWtuSUE&single=true&gid=0&range=B2%3AC9999&output=txt'
#    ,(err,data) ->
#      console.dir data
#catch e
#  console.err e

#http.get options, (res) ->
#  res.on 'data', (data) ->
#    console.log("data here = " + data)
#https.get(urls, (res) ->
#  console.dir res
#  console.log("Got response: " + res.statusCode);
#  res.on 'data',(data) ->
#    console.dir data.toString()
#).on('error', (e) ->
#  console.log("Got error: " + e.message);
#)

req = http.get(options, (res) ->
    console.log("statusCode: ", res.statusCode)
    console.log("headers: ", res.headers)
    res.on 'data', (d) ->
      console.log d.toString()
      process.stdout.write(d)
).on('error',(e)->
  console.error "error: "+ e.message
)
req.end()


#http = require('http')
#
#opt = {
#  host:'192.168.90.241',
#  port:'8088',
#  method:'POST',#这里是发送的方法
#  path:'https://docs.google.com/spreadsheet/pub?key=0Ap0bfNc2zisXdDlOUmxYRUpDRXR5bmdRckJKMWtuSUE&single=true&gid=0&range=B2%3AC9999&output=txt',#这里是访问的路径
#  headers:{
#    #这里放期望发送出去的请求头
#  }
#}
#
#req = http.request(opt, (res) ->
#  console.log("Got response: " + res.statusCode)
#  res.on('data',(d) ->
#    body += d
#  ).on('end', ()->
#    console.log(res.headers)
#    console.log(body)
#  )
#).on('error', (e) ->
#  console.log("Got error: " + e.message)
#  console.log( e.stack )
#)
#
#req.end();
