# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search_apnic_record')
  # .bind 'ajax:beforeSend', (event, data) ->
  #   alert 'ajax:beforeSend'
  .bind 'ajax:success', (event, data) ->
    # alert 'ajax:success'
    writeData(data)
  # .bind 'ajax:error', (event, data) ->
  #   alert 'ajax:error'
  # .bind 'ajax:complete', (event, data) ->
  #   alert 'ajax:complete'

writeData = (data) ->
  if data.length > 0
    htmlcode = '<table>'
    htmlcode += '<tr>'
    htmlcode += '<th>入力値</th>'
    htmlcode += '<th>国コード</th>'
    htmlcode += '<th>地域</th>'
    htmlcode += '<th>国</th>'
    htmlcode += '<th>タイプ</th>'
    htmlcode += '<th>ステータス</th>'
    htmlcode += '<th>IP開始番号</th>'
    htmlcode += '<th>IPアドレス数</th>'
    htmlcode += '<th>APNIC払出日</th>'
    htmlcode += '</tr>'
    for row, i in data
      htmlcode += '<tr>'
      htmlcode += "<td>#{row.input_value}</td>"
      htmlcode += "<td>#{row.cc}</td>"
      htmlcode += "<td>#{row.area}</td>"
      htmlcode += "<td>#{row.country}</td>"
      htmlcode += "<td>#{row.data_type}</td>"
      htmlcode += "<td>#{row.status}</td>"
      htmlcode += "<td>#{row.start}</td>"
      htmlcode += "<td>#{row.value}</td>"
      htmlcode += "<td>#{row.date}</td>"
      htmlcode += '</tr>'
    htmlcode += '</table>'
    $('#apnic_records').html(htmlcode)
