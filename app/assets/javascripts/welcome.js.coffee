# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#search_statistics_record')
  .bind 'ajax:beforeSend', (event, data) ->
    $('#data').html('<p>Processing...</p>')
  .bind 'ajax:success', (event, data) ->
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
    htmlcode += '<th>開始アドレス</th>'
    htmlcode += '<th>アドレス数</th>'
    htmlcode += '<th>国コード</th>'
    htmlcode += '<th>地域</th>'
    htmlcode += '<th>国名</th>'
    htmlcode += '<th>タイプ</th>'
    htmlcode += '<th>ステータス</th>'
    htmlcode += '<th>管轄</th>'
    htmlcode += '<th>APNIC払出日</th>'
    htmlcode += '</tr>'
    for row, i in data
      htmlcode += '<tr>'
      htmlcode += "<td>#{row.input_value}</td>"
      htmlcode += "<td>#{row.start}</td>"
      htmlcode += "<td>#{row.value}</td>"
      htmlcode += "<td>#{row.cc}</td>"
      htmlcode += "<td>#{row.area}</td>"
      if row.country.length > 0
        htmlcode += "<td><img alt=\"flag\" src=\"/assets/flags/shiny/24/#{row.country}.png\" />#{row.country}(#{row.country_ja})</td>"
      else
        htmlcode += "<td>#{row.country}</td>"
      htmlcode += "<td>#{row.data_type}</td>"
      htmlcode += "<td>#{row.status}</td>"
      htmlcode += "<td>#{row.registry}</td>"
      htmlcode += "<td>#{row.date}</td>"
      htmlcode += '</tr>'
    htmlcode += '</table>'
    $('#data').html(htmlcode)
  else
    $('#data').html('<p>No Data.</p>')
