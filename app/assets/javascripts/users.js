$(function() {
  $("#user_search").change(function() {
      $.get($("#user_search").attr("action"), $("#user_search").serialize(), null, "script");
      return false;
  });
    $("#user_search").keyup(function() {
        $.get($("#user_search").attr("action"), $("#user_search").serialize(), null, "script");
        return false;
    });
});