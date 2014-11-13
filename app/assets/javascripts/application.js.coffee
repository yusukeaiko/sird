# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap-sprockets
#= require stupidtable.min
#= require_tree .
$(document).ready( ->
  select_country_dialog()
)

select_country_dialog = ->
  $('#country_modal').on('shown.bs.modal', (e) ->
    $('[name="country_add"]').click( ->
      code = $(this).parent().children('input[type="hidden"]').val()
      types = ''
      $('input[name=addr_type]:checked').map( ->
        types += ':' + $(this).val()
      )
      if $('#statistics_record_start_addr').val().length == 0
        $('#statistics_record_start_addr').val(code + types)
      else
        $('#statistics_record_start_addr').val($('#statistics_record_start_addr').val() + ', ' + code + types)
    )
  )

