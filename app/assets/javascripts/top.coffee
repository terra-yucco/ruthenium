# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 野菜の英語名
veg_list = new Array

# 野菜の名前（日本語）
label_list = new Array

# 手持ちの野菜
data_list = new Array

# 手持ちの野菜
for vegetable_stock in gon.vegetable_stocks
  veg_list.push(vegetable_stock[0])
  label_list.push(vegetable_stock[1])
  data_list.push(vegetable_stock[2])

# グラフ
myChart = null

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

check_celebrate = ->
  # 一致した数
  match_count = 0
  # 不一致
  miss_match = false
  for veg_name, i in veg_list
    current_veg_count = parseFloat(myChart.data.datasets[0].data[i])
    will_veg_count = parseFloat(myChart.data.datasets[1].data[i])
    if will_veg_count == current_veg_count
      if will_veg_count != 0
        match_count = match_count + 1
    else
      miss_match = true

  # 暫定表示
  if !miss_match && 0 < match_count
    window.scroll(0,0)
    setTimeout((-> alert(match_count + "個の野菜が一致しました！")),
      500
    )

@check_changed = ->
  will_list = get_will_list()
  myChart.data.datasets[1].data = will_list
  myChart.update()

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
          suggestedMax: 5)
