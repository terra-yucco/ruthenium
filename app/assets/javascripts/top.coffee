# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 野菜の英語名
veg_list = new Array

# 野菜の名前（日本語）
label_list = new Array

# 手持ちの野菜
data_list = new Array

# 配列に値を追加
for vegetable_stock in gon.vegetable_stocks
  veg_list.push(vegetable_stock[0])
  label_list.push(vegetable_stock[1])
  data_list.push(vegetable_stock[2])

# グラフ
myChart = null

# 数字(number)を小数点以下の有効桁数(digit)で四捨五入した数値を返す
format_froat = (number, digit) ->
  pow = Math.pow(10, digit)
  return parseFloat(Math.round(number * pow) / pow).toFixed(digit)

# 使い予定の野菜の数リストを取得
get_will_list = ->
  will_list = new Array
  for veg_name in veg_list
    vegs = document.querySelectorAll('[data-' + veg_name + ']')
    veg_count = 0
    for veg in vegs
      checkbox = veg.parentNode.parentNode.previousElementSibling.firstElementChild.firstElementChild
      if checkbox.checked
        veg_count += parseFloat(veg.dataset[veg_name])
    will_list.push(veg_count)
  return will_list

# 野菜の数の一致をチェックして、一致していたらお祝いを表示
check_celebrate = ->
  # 一致した数
  match_count = 0
  # 不一致
  miss_match = false
  for veg_name, i in veg_list
    current_veg_count = parseFloat(myChart.data.datasets[0].data[i])
    will_veg_count = parseFloat(myChart.data.datasets[1].data[i])
    # 小数点以下1桁目を有効数字として判定
    if format_froat(will_veg_count, 1) == format_froat(current_veg_count, 1)
      if will_veg_count != 0
        match_count = match_count + 1
    else
      miss_match = true

  if !miss_match && 0 < match_count
    window.scroll(0,0)
    $("#puzzveg_rank").text(match_count)
    $('#modal_celebrate').modal('show')

# 選択した人数(selected_serving)を各レシピに反映
apply_serving = (selected_serving) ->
  for veg_name in veg_list
    vegs = document.querySelectorAll('[data-original-' + veg_name + ']')
    for veg in vegs
      original_serving = $(veg).closest('table').attr('data-original-serving')
      original_veg_count = parseFloat($(veg).attr('data-original-' + veg_name))
      veg_count = original_veg_count * selected_serving / original_serving
      veg_count = format_froat(veg_count, 2)
      $(veg).attr('data-' + veg_name, veg_count)
      $(veg).find('.veg-count').text(veg_count)
  $('.serving-number').text(selected_serving)

# チャートを更新
update_chart = ->
  will_list = get_will_list()
  myChart.data.datasets[1].data = will_list
  myChart.update()

@serving_changed =->
  selected_serving = $('[name=nannninnbunn]').val()
  unless selected_serving == ""
    apply_serving(selected_serving)
    update_chart()
    check_celebrate()

@check_changed = ->
  update_chart()
  check_celebrate()

@show_chart = ->
  ctx = document.getElementById("myChart")
  ctx = document.getElementById("myChart").getContext("2d")
  ctx = $("#myChart")

  # 使う予定の野菜
  will_list = get_will_list()

  myChart = new Chart(ctx,
    type: 'radar',
    data:
      labels: label_list,
      datasets: [{
        label: '手持ちの野菜',
        backgroundColor: 'rgba(255, 99, 132, 0.2)',
        borderColor: 'rgba(255,99,132,1)',
        borderWidth: 1,
        data: data_list,
      }
      {
        label: '使う予定の野菜',
        backgroundColor: 'rgba(153, 102, 255, 0.2)',
        borderColor: 'rgba(153, 102, 255, 1)',
        borderWidth: 1,
        data: will_list,
      }]
    options:
      scale:
        ticks:
          min: 0, 
          suggestedMax: 5)
