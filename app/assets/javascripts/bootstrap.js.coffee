jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

$(document).delegate '*[data-toggle="lightbox"]', 'click', (event) ->
  event.preventDefault()
  $(this).ekkoLightbox()
  return