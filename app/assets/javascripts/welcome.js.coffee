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
  
  $('#search_statistics_record').submit ->
    $('#country_dialog').dialog('close')
  
  countryDialog()

countryDialog = ->
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

keywordLink = ->
  words = $('#statistics_record_start_addr').val().split(',')
  for word, i in words
    words[i] = jQuery.trim(word)
  words = jQuery.unique(words)
  html = ''
  if words.length > 0
    html = '<dl id="keywordLinks"><dt>Keyword Links :: </dt>'
    for word in words
      html += "<dd><a href=\"\#word#{word}\">#{word}</a></dd>"
    html += '</dl>'
  return html

writeData = (data) ->
  cnt = 0
  bkeyword = ''
  if data.length > 0
    html = '<table id="sirdtable">'
    html += '<thead>'
    html += '<tr>'
    html += '<th data-sort="string" rowspan=\"2\">Keyword</th>'
    html += '<th colspan=\"3\">Address</th>'
    html += '<th colspan=\"4\">Country</th>'
    html += '<th data-sort="string" rowspan=\"2\">Registy</th>'
    html += '</tr>'
    html += '<tr>'
    html += '<th data-sort="string">Address</th>'
    html += '<th data-sort="string">Prefix</th>'
    html += '<th data-sort="string">Type</th>'
    html += '<th>Flag</th>'
    html += '<th data-sort="string">Code</th>'
    html += '<th data-sort="string">Name</th>'
    html += '<th data-sort="string">Area</th>'
    html += '</tr>'
    html += '</thead>'
    html += '<tbody>'
    for row, i in data
      if bkeyword == row.input_value
        keywordId = ''
      else
        keywordId = "id=\"word#{row.input_value}\""
        bkeyword = row.input_value
      regInfo = "Status:&nbsp;#{row.status}<br />"
      regInfo += "Date:&nbsp;#{row.date}"
      addrInfo = "From:&nbsp;#{row.start_addr}<br />"
      addrInfo += "To:&nbsp;#{row.end_addr}<br />"
      addrInfo += "Count: #{row.value}"
      
      html += "<tr #{keywordId}>"
      html += "<td>#{row.input_value}</td>"
      html += "<td title=\"#{addrInfo}\">#{row.start_addr}</td>"
      html += "<td style=\"text-align:right;\" title=\"#{addrInfo}\">#{row.prefix}</td>"
      html += "<td>#{row.data_type}</td>"
      if row.country != null && row.country.length > 0
        html += "<td><img alt=\"\" src=\"/assets/flags/shiny/24/#{row.flag_filename}.png\" /></td>"
        html += "<td>#{row.cc}</td>"
        html += "<td>#{row.country}(#{row.country_ja})</td>"
        html += "<td>#{row.area}</td>"
      else
        html += "<td></td>"
        html += "<td>#{row.cc}</td>"
        html += "<td></td>"
        html += "<td>#{row.area}</td>"
      html += "<td title=\"#{regInfo}\">#{row.registry}</td>"
      html += '</tr>'
      ++cnt
    html += '</tbody>'
    html += '</table>'
    cntHtml = '<p>検索結果:&nbsp;' + cnt.toString().replace(/^(-?\d+)(\d{3})/, "$1,$2") + '&nbsp;件</p>'
    $('#data').html(cntHtml + keywordLink() + html)
    $('#sirdtable').stupidtable()
  else
    $('#data').html('<p>No Data.</p>')
