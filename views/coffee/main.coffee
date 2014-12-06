$ ->
  $("textarea").autosize()
  $(".new-task").focus()

  $(".content").on('keyup', ->
    content = $(@).val()
    previous = $(@).data("previous")
    if content != previous
      $(@).parent().addClass("has-warning")
    else
      $(@).parent().removeClass("has-warning")
  )

  $(".content").on('blur', ->
    content = $(@).val()
    previous = $(@).data("previous")
    if content != previous
      $.ajax {
        url: $(@).data("id"),
        method: 'PATCH',
        data: $.param({content: $(@).val()}),
        success: =>
          $(@).data("previous", $(@).val())
          $(@).parent().removeClass("has-warning")
      }
  )
