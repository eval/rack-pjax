$(function() {
  if ($.cookie('pjax') == "true")
    $(':checkbox').prop('checked', true)
  else
    $(':checkbox').prop('checked', false)

  if ( !$(':checkbox').prop('checked') )
    $.fn.pjax = $.noop

  $(':checkbox').change(function() {
    if ( $.pjax == $.noop ) {
      $(this).prop('checked', false)
      return alert( "Sorry, your browser doesn't support pjax :(" )
    }

    if ( $(this).prop('checked') )
      $.cookie('pjax', true)
    else
      $.cookie('pjax', null)

    window.location = location.href
  })
});
