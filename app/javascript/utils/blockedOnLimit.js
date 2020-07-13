document.addEventListener("turbolinks:load", function () {
  $(document).ready(function () {
    $("#plan_blocked_on_limit").change(function () {
      if (this.checked) {
        $(".hide_when_blocked_on_limit").attr("hidden", true);
      } else {
        $(".hide_when_blocked_on_limit").attr("hidden", false);
      }
    });
  });
});
