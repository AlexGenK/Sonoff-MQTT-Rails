# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  Highcharts.setOptions lang:
    shortMonths: [
      'Январь'
      'Февраль'
      'Март'
      'Апрель'
      'Май'
      'Июнь'
      'Июль'
      'Август'
      'Сентябрь'
      'Октябрь'
      'Ноябрь'
      'Декабрь'
    ]
    weekdays: [
      'Вс.'
      'Пн.'
      'Вт.'
      'Ср.'
      'Чт.'
      'Пт.'
      'Сб.'
    ]
  $('#startTimeID').datetimepicker locale: 'ru'
  $('#endTimeID').datetimepicker
    useCurrent: false
    locale: 'ru'
  $('#startTimeID').on 'change.datetimepicker', (e) ->
    $('#endTimeID').datetimepicker 'minDate', e.date
    return
  $('#endTimeID').on 'change.datetimepicker', (e) ->
    $('#startTimeID').datetimepicker 'maxDate', e.date
    return
  $('#startTimeID').bind 'click', ->
    $('#optionsPeriod2').click()
    return
  $('#endTimeID').bind 'click', ->
    $('#optionsPeriod2').click()
    return
  return