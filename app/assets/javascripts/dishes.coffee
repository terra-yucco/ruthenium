# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.add-volume-btn').click ->
    number_field = $(this).parent().find('input[type=number]')
    current_volume = parseFloat(number_field.val())
    number_field.val(current_volume + 1)
