$(document).ready ->

  # Make chzn boxes.
  $(".chzn-select").chosen()
  # $("#fbmodal").modal("show")

  # Facebook modal for the first time
  $("#fbtooltip").popover({
    animation: true,
    placement: "right",
    title: "Why the Book rocks",
    content: "With Facebook, you can control whether you meet friends, strangers, or both. \
It gives you a better handle on your privacy, more options, and increases your chances of making lasting connections.",
    delay: {
      show: 0,
      hide: 200
    },
    trigger: "hover"
  })
  $("#points").popover({
      title: "Points",
      content: "You win points every time you complete a meal—\
try to get the most of your classmates!",
      trigger: "hover"
    })

  # Stupid tooltip test on CAS login button on splash page
  $("[rel='tooltip']").tooltip({
    placement: "right",
    title: "CAS login"
  })

  # Any ajax error in the body is handled the same way
  $("body").ajaxError( () ->
    msg = "An error occurred -- try refreshing the page. \
    If the problem persists, please contact the webmaster or try again later :("
    $("#error").notice(msg)
  )
  # On click, hide alerts
  $("body").click( () ->
    $(".alert").slideUp("fast")
  )
  
  # Function for inline changing the major.
  old_major = ""
  $("#major").focus(() ->
      old_major = $("#major").html()
    ).keydown( (e) ->
      if(e.which == 13) 
        $(this).blur() # blur, triggering the next handler
        e.preventDefault()
    ).blur( () -> 
      new_major = $.trim($(this).html().replace(/&nbsp;/g, ""))
      if(old_major != new_major)
        post_major(new_major)
      else
        $(this).html(new_major)
    )

  true

# Post the major
post_major = (text) ->
  $.post("/major", {major: text}, (data) ->
    if(data.status == "fail")
      $("#error").notice(data.message)
      $("#major").html("Undecided")
    else if(data.status == "success")
      $("#success").notice(data.message)
  )
  true
