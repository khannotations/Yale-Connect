$(document).ready ->
  $(".chzn-select").chosen()
  # $("#fbmodal").modal("show")
  $("#fbtooltip").popover({
    animation: true,
    placement: "right",
    title: "Why the Book rocks",
    content: "With Facebook, you can control whether you meet friends, strangers, or both. It gives you a better handle on your privacy, more options, and helps ensure you make lasting connections. ",
    delay: {
      show: 0,
      hide: 200
    }
  })
  $("body").ajaxError( () ->
    $("#error").html("An error occurred -- try refreshing the page. If the problem persists, please contact the webmaster or try again later :(").parents(".alert").slideDown("fast")
  ).click( () ->
    $(".alert").slideUp("fast")
  )

  $("#major").keydown( (e) ->
    if(e.which == 13) 
      $(this).blur()
      e.preventDefault()
  ).blur( () -> 
    major_post($(this).html())
  )

  true

major_post = (text) ->
  $.post("/major", {major: text}, (data) ->
    console.log(data)
    if(data.status == "fail")
      error(data.message)
      $("#major").html("Undecided")
    else if(data.status == "success")
      success(data.message)
  )
  true

success = (msg) ->
  $("#success").html(msg).parents(".alert").slideDown("fast")
  true

error = (msg) -> 
  $("#error").html(msg).parents(".alert").slideDown("fast")
  true