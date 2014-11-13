# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#search_statistics_record')
    .on('ajax:beforeSend', (event, data) ->
      $('#data').append($('<div>').addClass('circle_outside'))
      $('#data').append($('<div>').addClass('circle_inside'))
    )
    .on('ajax:success', (event, data) ->
      $('#data').html('')
      writeResult(data)
    )

writeResult = (data) ->
  if data.length > 0
    # 検索結果
    table = $('<table>').attr('id', 'sirdtable').addClass('table').addClass('table-striped')
    thead = resultHeader()
    tbody = resultRows(data)
    table = table.append(thead).append(tbody)
    # 結果件数
    data_num = Object.keys(data).length.toString().replace(/^(-?\d+)(\d{3})/, "$1,$2")
    result_dl = $('<dl>').attr('id', 'keywordLinks')
    result_dl = result_dl.append($('<dt>').text("検索結果: #{data_num} 件"))
    result_dl = keywordLink(result_dl)
    # iptables向け処理ボタン
    iptable = $('<div>')
    iptable = iptable.append($('<input>').attr('type', 'button').attr('id', 'ipt_ipv4block').addClass('btn btn-default').attr('name', 'ipt_ipv4block').attr('title', '検索結果のIPv4アドレスを全てブロックするiptablesのレシピを生成する。').val('IPv4アドレスをブロック'))
    #iptable = iptable.append($('<div>').attr('id', 'iptable_dialog').append($('<p>').text('検索結果のIPv4アドレスを全てブロックするレシピ')).append($('textarea').attr('id', 'ipt_command')))
    # 結合して書き出し
    $('#data').append(result_dl).append(iptable).append(table)
    $('#sirdtable').stupidtable()
    # キーワードリンククリックイベント処理
    keywordLinkClick()
    iptableDialog()
  else
    $('#data').html('<p>No Data.</p>')

resultHeader = ->
  tr = $('<tr>')
  tr = tr.append($('<th>').attr('data-sort', 'string').html('Keyword <span class="glyphicon glyphicon-sort" aria-hidden="true"></span>'))
  tr = tr.append($('<th>').attr('data-sort', 'string').html('Address <span class="glyphicon glyphicon-sort" aria-hidden="true"></span>'))
  tr = tr.append($('<th>').attr('data-sort', 'int').html('Addr Prefix <span class="glyphicon glyphicon-sort" aria-hidden="true"></span>'))
  tr = tr.append($('<th>').attr('data-sort', 'string').html('Addr Type <span class="glyphicon glyphicon-sort" aria-hidden="true"></span>'))
  tr = tr.append($('<th>').attr('data-sort', 'string').html('Area <span class="glyphicon glyphicon-sort" aria-hidden="true"></span>'))
  tr = tr.append($('<th>').attr('data-sort', 'string').html('Country Code <span class="glyphicon glyphicon-sort" aria-hidden="true"></span>'))
  tr = tr.append($('<th>').text('Flag'))
  tr = tr.append($('<th>').attr('data-sort', 'string').html('Country Name <span class="glyphicon glyphicon-sort" aria-hidden="true"></span>'))
  tr = tr.append($('<th>').attr('data-sort', 'string').html('Registry <span class="glyphicon glyphicon-sort" aria-hidden="true"></span>'))
  return $('<thead>').append(tr)

resultRows = (data) ->
  tbody = $('<tbody>').attr('id', 'sirtable_body')
  bkeyword = ''
  for row in data
    regInfo  = "Status:#{row.status} "
    regInfo += "Date:#{row.date}"
    addrInfo  = "From:#{row.start_addr} "
    addrInfo += "To:#{row.end_addr} "
    addrInfo += "Count:#{row.value}"
    tr = $('<tr>')
    if bkeyword == row.input_value
      tr = tr.append($('<td>').addClass('col_keyword').text(row.input_value))
    else
      tr = tr.append($('<td>').addClass('col_keyword').attr('name', 'keywordPoint').text(row.input_value))
      bkeyword = row.input_value
    tr = tr.append($('<td>').addClass('col_address').attr('title', addrInfo).text(row.start_addr))
    tr = tr.append($('<td>').addClass('col_prefix').addClass('test-right').attr('title', addrInfo).text(row.prefix))
    tr = tr.append($('<td>').addClass('col_type').text(row.data_type))
    if row.country != null && row.country.length > 0
      tr = tr.append($('<td>').addClass('col_area').text(row.area))
      tr = tr.append($('<td>').addClass('col_country_code').text(row.cc))
      tr = tr.append($('<td>').addClass('col_flag').append($('<img>').attr('alt', '').attr('src', "/assets/flags/shiny/24/#{row.flag_filename}.png")))
      tr = tr.append($('<td>').addClass('col_country').text("#{row.country}(#{row.country_ja})"))
    else
      tr = tr.append($('<td>').addClass('col_area').text(row.area))
      tr = tr.append($('<td>').addClass('col_country_code').text(row.cc))
      tr = tr.append($('<td>').addClass('col_flag'))
      tr = tr.append($('<td>').addClass('col_country'))
    tr = tr.append($('<td>').addClass('col_registory').attr('title', regInfo).text(row.registry))
    tbody = tbody.append(tr)
  return tbody

keywordLink = (result_dl) ->
  words = $('#statistics_record_start_addr').val().split(',')
  for word, i in words
    words[i] = jQuery.trim(word)
  words = jQuery.unique(words)
  if words.length > 0
    for word in words
      result_dl = result_dl.append($('<dd>').addClass('keywordLink').text(word))
  return result_dl

keywordLinkClick = ->
  $('#keywordLinks > .keywordLink').click ->
    console.log('aaaaaaaaaaa')
    point = $('[name=keywordPoint]:contains("' + $(this).text() + '")').offset().top
    $('html,body').animate({scrollTop: point}, 'fast')

iptableDialog = ->
  $('#ipt_ipv4block').click ->
    command = ''
    $('#sirtable_body > tr').each ->
      if $(this).children('.col_type').text() == 'ipv4'
        command += "iptables -A INPUT -s #{$(this).children('.col_address').text()}/#{$(this).children('.col_prefix').text()} -j DROP ;\n"
    $('#iptv4_command').val(command)
    $('#iptables_ipv4_modal').modal('show')

iptableDialogClick = ->
