$(document).ready ->
  $(".chzn-select").chosen();

  $("body").ajaxError( () ->
    $("#error").html("An error occurred -- try refreshing the page. If the problem persists, please contact the webmaster or try again later :(").parents(".alert").slideDown("fast")
  )