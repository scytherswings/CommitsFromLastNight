# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

divsToHide = document.getElementsByClassName('pagination')
i = 0
while i < divsToHide.length
  divsToHide[i].style.visibility = 'hidden'
  i++

$('div.inner').replaceWith '<h2>That\'s all folks!</h2>'
