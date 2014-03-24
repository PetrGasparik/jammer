$(function() {
    $("#investment_search").change(function() {
        $.get($("#investment_search").attr("action"), $("#investment_search").serialize(), null, "script");
        return false;
    });
    $("#investment_search").keyup(function() {
        $.get($("#investment_search").attr("action"), $("#investment_search").serialize(), null, "script");
        return false;
    });
});