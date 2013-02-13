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
    htmlcode += '<th data-sort="string" rowspan=\"2\">Keyword</th>'
    htmlcode += '<th colspan=\"3\">Address</th>'
    htmlcode += '<th colspan=\"4\">Country</th>'
    htmlcode += '<th data-sort="string" rowspan=\"2\">Registy</th>'
    htmlcode += '</tr>'
    htmlcode += '<tr>'
    htmlcode += '<th data-sort="string">Address</th>'
    htmlcode += '<th data-sort="string">Prefix</th>'
    htmlcode += '<th data-sort="string">Type</th>'
    htmlcode += '<th>Flag</th>'
    htmlcode += '<th data-sort="string">Code</th>'
    htmlcode += '<th data-sort="string">Name</th>'
    htmlcode += '<th data-sort="string">Area</th>'
    htmlcode += '</tr>'
    htmlcode += '</thead>'
    htmlcode += '<tbody>'
    for row, i in data
      regInfo = "Status:&nbsp;#{row.status}<br />"
      regInfo += "Date:&nbsp;#{row.date}"
      addrInfo = "From:&nbsp;#{row.start_addr}<br />"
      addrInfo += "To:&nbsp;#{row.end_addr}<br />"
      addrInfo += "Count: #{row.value}"
      
      htmlcode += '<tr>'
      htmlcode += "<td>#{row.input_value}</td>"
      htmlcode += "<td title=\"#{addrInfo}\">#{row.start_addr}</td>"
      htmlcode += "<td style=\"text-align:right;\" title=\"#{addrInfo}\">#{row.prefix}</td>"
      htmlcode += "<td>#{row.data_type}</td>"
      if row.country != null && row.country.length > 0
        htmlcode += "<td><img alt=\"\" src=\"/assets/flags/shiny/24/#{row.flag_filename}.png\" /></td>"
        htmlcode += "<td>#{row.cc}</td>"
        htmlcode += "<td>#{row.country}(#{row.country_ja})</td>"
        htmlcode += "<td>#{row.area}</td>"
      else
        htmlcode += "<td></td>"
        htmlcode += "<td>#{row.cc}</td>"
        htmlcode += "<td></td>"
        htmlcode += "<td>#{row.area}</td>"
      htmlcode += "<td title=\"#{regInfo}\">#{row.registry}</td>"
      htmlcode += '</tr>'
      ++cnt
    htmlcode += '</tbody>'
    htmlcode += '</table>'
    cntHtmlCode = '<p>検索結果:&nbsp;' + cnt.toString().replace(/^(-?\d+)(\d{3})/, "$1,$2") + '&nbsp;件</p>'
    $('#data').html(cntHtmlCode + htmlcode)
    $('#sirdtable').stupidtable()
  else
    $('#data').html('<p>No Data.</p>')
