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
    writeResult(data)
  # .bind 'ajax:error', (event, data) ->
  #   alert 'ajax:error'
  # .bind 'ajax:complete', (event, data) ->
  #   alert 'ajax:complete'
  
  $('#search_statistics_record').submit ->
    $('#country_dialog').dialog('close')
  
  $('#search_reset').click ->
    $('#statistics_record_start_addr').focus()
  
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
    position: [100, 220]
  $('[name=country_add]:input').click ->
    code = $(this).parent().children('input[type="hidden"]').val()
    types = ''
    $('input[name=addr_type]:checked').map ->
      types += ':' + $(this).val()
    if $('#statistics_record_start_addr').val().length == 0
      $('#statistics_record_start_addr').val(code + types)
    else
      $('#statistics_record_start_addr').val($('#statistics_record_start_addr').val() + ', ' + code + types)

writeResult = (data) ->
  if data.length > 0
    # 検索結果
    html = '<table id="sirdtable"><thead>'
    html += resultHeader()
    html += '</thead><tbody id="sirtable_body">'
    rows = resultRows(data)
    html += rows.join('')
    html += '</tbody></table>'
    # 結果件数
    cntHtml = '<p>検索結果:&nbsp;' + rows.length.toString().replace(/^(-?\d+)(\d{3})/, "$1,$2") + '&nbsp;件&nbsp;'
    cntHtml += '<input type="button" id="ipt_ipv4block" name="ipt_ipv4block" value="IPv4アドレスをブロック" title="検索結果のIPv4アドレスを全てブロックするレシピを生成する。" /></p>'
    # iptables向け処理ボタン
    iptHtml = '<div id="iptable_dialog"><p>検索結果のIPv4アドレスを全てブロックするレシピ</p><textarea id="ipt_command"></textarea></div>'
    # 結合して書き出し
    $('#data').html(cntHtml + keywordLink() + iptHtml + html)
    $('#sirdtable').stupidtable()
    # キーワードリンククリックイベント処理
    keywordLinkClick()
    iptableDialog()
  else
    $('#data').html('<p>No Data.</p>')

resultHeader = ->
  html = '<tr>'
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
  return html

resultRows = (data) ->
  rows = new Array
  bkeyword = ''
  for row in data
    html = ''
    if bkeyword == row.input_value
      keywordName = ''
    else
      keywordName = 'name="keywordPoint"'
      bkeyword = row.input_value
    regInfo = "Status:&nbsp;#{row.status}<br />"
    regInfo += "Date:&nbsp;#{row.date}"
    addrInfo = "From:&nbsp;#{row.start_addr}<br />"
    addrInfo += "To:&nbsp;#{row.end_addr}<br />"
    addrInfo += "Count: #{row.value}"
    
    html += '<tr>'
    html += "<td class=\"col_keyword\" #{keywordName}>#{row.input_value}</td>"
    html += "<td class=\"col_address\" title=\"#{addrInfo}\">#{row.start_addr}</td>"
    html += "<td class=\"col_prefix\" style=\"text-align:right;\" title=\"#{addrInfo}\">#{row.prefix}</td>"
    html += "<td class=\"col_type\">#{row.data_type}</td>"
    if row.country != null && row.country.length > 0
      html += "<td class=\"col_flag\" ><img alt=\"\" src=\"/assets/flags/shiny/24/#{row.flag_filename}.png\" /></td>"
      html += "<td class=\"col_country_code\">#{row.cc}</td>"
      html += "<td class=\"col_country\">#{row.country}(#{row.country_ja})</td>"
      html += "<td class=\"col_area\">#{row.area}</td>"
    else
      html += '<td class=\"col_flag\"></td>'
      html += "<td class=\"col_country_code\">#{row.cc}</td>"
      html += '<td class=\"col_country\"></td>'
      html += "<td class=\"col_area\">#{row.area}</td>"
    html += "<td class=\"col_registry\" title=\"#{regInfo}\">#{row.registry}</td>"
    html += '</tr>'
    rows.push(html)
  return rows

keywordLink = ->
  words = $('#statistics_record_start_addr').val().split(',')
  for word, i in words
    words[i] = jQuery.trim(word)
  words = jQuery.unique(words)
  html = ''
  if words.length > 0
    html = '<dl id="keywordLinks"><dt>Keyword Links :: </dt>'
    for word in words
      html += "<dd class=\"keywordLink\">#{word}</dd>"
    html += '</dl>'
  return html

keywordLinkClick = ->
  $('#keywordLinks > .keywordLink').click ->
    point = $('[name=keywordPoint]:contains("' + $(this).text() + '")').offset().top
    $('html,body').animate({scrollTop: point}, 'fast')

iptableDialog = ->
  iptableDialogClick()
  $('#iptable_dialog').dialog
    autoOpen: false,
    modal: false,
    title: 'Command for iptables',
    height: 300,
    width: 550,
    position: [50, 220]

iptableDialogClick = ->
  $('#ipt_ipv4block').click ->
    command = ''
    $('#sirtable_body > tr').each ->
      if $(this).children('.col_type').text() == 'ipv4'
        command += "iptables -A INPUT -s #{$(this).children('.col_address').text()}/#{$(this).children('.col_prefix').text()} -j DROP ;\n"
    $('#ipt_command').val(command)
    $('#iptable_dialog').dialog('open')
