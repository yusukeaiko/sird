# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#statistics_record_start_addr').focus()

$ ->
  $('#search_statistics_record')
  .bind 'ajax:beforeSend', (event, data) ->
    $('#data').html('<div class="circle_outside"></div><div class="circle_inside"></div>')
  .bind 'ajax:success', (event, data) ->
    writeData(data)
  # .bind 'ajax:error', (event, data) ->
  #   alert 'ajax:error'
  # .bind 'ajax:complete', (event, data) ->
  #   alert 'ajax:complete'
  
  $('#select_country').click ->
    $('#country_dialog').dialog('open')
  $('#country_dialog').dialog
    autoOpen: false,
    modal: false,
    title: 'カントリーコード選択',
    height: 300,
    width: 550,
    position: [50, 200]
  
  $('[name=country_add]:input').click ->
    code = $(this).parent().children('input[type="hidden"]').val()
    types = ''
    $('input[name=addr_type]:checked').map ->
      types += ':' + $(this).val()
    if $('#statistics_record_start_addr').val().length == 0
      $('#statistics_record_start_addr').val(code + types)
    else
      $('#statistics_record_start_addr').val($('#statistics_record_start_addr').val() + ', ' + code + types)
  
  $('#search_statistics_record').submit ->
    $('#country_dialog').dialog('close')

writeData = (data) ->
  cnt = 0
  if data.length > 0
    htmlcode = '<table id="sirdtable">'
    htmlcode += '<thead>'
    htmlcode += '<tr>'
    htmlcode += '<th data-sort="string">Keyword</th>'
    htmlcode += '<th data-sort="string">Addr:From</th>'
    htmlcode += '<th data-sort="string">Addr:To</th>'
    htmlcode += '<th data-sort="integer">ブロック</th>'
    htmlcode += '<th data-sort="integer">アドレス数</th>'
    htmlcode += '<th data-sort="string">国コード</th>'
    htmlcode += '<th data-sort="string">地域</th>'
    htmlcode += '<th data-sort="string">国旗</th>'
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
      htmlcode += "<td>#{row.start_addr}</td>"
      htmlcode += "<td>#{row.end_addr}</td>"
      htmlcode += "<td style=\"text-align:right;\">#{row.block}</td>"
      htmlcode += "<td style=\"text-align:right;\">#{row.value}</td>"
      htmlcode += "<td>#{row.cc}</td>"
      htmlcode += "<td>#{row.area}</td>"
      if row.country != null && row.country.length > 0
        htmlcode += "<td><img alt=\"\" src=\"/assets/flags/shiny/24/#{row.flag_filename}.png\" /></td>"
        htmlcode += "<td>#{row.country}(#{row.country_ja})</td>"
      else
        htmlcode += "<td></td>"
        htmlcode += "<td></td>"
      htmlcode += "<td>#{row.data_type}</td>"
      htmlcode += "<td>#{row.status}</td>"
      htmlcode += "<td>#{row.registry}</td>"
      htmlcode += "<td>#{row.date}</td>"
      htmlcode += '</tr>'
      ++cnt
    htmlcode += '</tbody>'
    htmlcode += '</table>'
    cntHtmlCode = '<p>検索結果:&nbsp;' + cnt.toString().replace(/^(-?\d+)(\d{3})/, "$1,$2") + '&nbsp;件</p>'
    $('#data').html(cntHtmlCode + htmlcode)
    $('#sirdtable').stupidtable()
  else
    $('#data').html('<p>No Data.</p>')
