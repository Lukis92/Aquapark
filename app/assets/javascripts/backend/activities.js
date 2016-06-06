jQuery(function() {
  return $(".calendar-day").on("click", function() {
    var date;
    date = $(this).data("date");
    return location.href = "backend/activities/[id]=" + id;
  });
});
