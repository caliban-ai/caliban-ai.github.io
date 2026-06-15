// Injects a consistent cross-site banner at the top of every caliban-ai page.
// Shared across the hub and all project sites via the theme checkout step.
(function () {
  var HUB = "https://caliban-ai.github.io/";
  var links = [
    ["caliban-ai", HUB],
    ["caliban", HUB + "caliban/"],
    ["prospero", HUB + "prospero/"],
    ["gonzalo", HUB + "gonzalo/"],
    ["updates", HUB + "updates/index.html"],
  ];
  var bar = document.createElement("div");
  bar.className = "caliban-ai-banner";
  links.forEach(function (l, i) {
    var a = document.createElement("a");
    a.textContent = l[0];
    a.href = l[1];
    bar.appendChild(a);
    if (i === 0) {
      var s = document.createElement("span");
      s.className = "spacer";
      bar.appendChild(s);
    }
  });
  document.body.insertBefore(bar, document.body.firstChild);
})();
