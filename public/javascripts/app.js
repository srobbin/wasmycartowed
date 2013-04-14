$(function () {
  // Provide some feedback when submitting the form
  $("form").submit(function () {
    $(this).find("button").text("Searching...");
  });
});