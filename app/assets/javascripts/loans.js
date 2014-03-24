$(function() {
    $("#loan_search").change(function() {
        $.get($("#loan_search").attr("action"), $("#loan_search").serialize(), null, "script");
        return false;
    });
    $("#loan_search").keyup(function() {
        $.get($("#loan_search").attr("action"), $("#loan_search").serialize(), null, "script");
        return false;
    });
});