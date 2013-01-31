# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#statistics_record_start').focus()

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
    htmlcode = '<table id="sirdtable">'
    htmlcode += '<thead>'
    htmlcode += '<tr>'
    htmlcode += '<th data-sort="string">入力値</th>'
    htmlcode += '<th data-sort="string">開始アドレス</th>'
    htmlcode += '<th data-sort="integer">アドレス数</th>'
    htmlcode += '<th data-sort="string">国コード</th>'
    htmlcode += '<th data-sort="string">地域</th>'
    htmlcode += '<th data-sort="string">国名</th>'
    htmlcode += '<th data-sort="string">タイプ</th>'
    htmlcode += '<th data-sort="string">ステータス</th>'
    htmlcode += '<th data-sort="string">レジストラ</th>'
    htmlcode += '<th data-sort="string">レジストラ払出日</th>'
    htmlcode += '</tr>'
    htmlcode += '</thead>'
    htmlcode += '<tbody>'
    for row, i in data
      htmlcode += '<tr>'
      htmlcode += "<td>#{row.input_value}</td>"
      htmlcode += "<td>#{row.start}</td>"
      htmlcode += "<td style=\"text-align:right;\">#{row.value}</td>"
      htmlcode += "<td>#{row.cc}</td>"
      htmlcode += "<td>#{row.area}</td>"
      if row.country != null && row.country.length > 0
        htmlcode += "<td><div style=\"width:24px;\"><img alt=\"\" src=\"/assets/flags/shiny/24/#{row.country.replace(' ','-')}.png\" /></div>#{row.country}(#{row.country_ja})</td>"
      else
        htmlcode += "<td>#{row.country}</td>"
      htmlcode += "<td>#{row.data_type}</td>"
      htmlcode += "<td>#{row.status}</td>"
      htmlcode += "<td>#{row.registry}</td>"
      htmlcode += "<td>#{row.date}</td>"
      htmlcode += '</tr>'
    htmlcode += '</tbody>'
    htmlcode += '</table>'
    $('#data').html(htmlcode)
    $('#sirdtable').stupidtable()
  else
    $('#data').html('<p>No Data.</p>')
