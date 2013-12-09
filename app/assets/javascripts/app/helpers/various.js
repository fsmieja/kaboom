Handlebars.registerHelper('link', function(text, url, title, cass) {
  return new Handlebars.SafeString(
    "<a href='" + url + "' class='"+ cass + "' title='"+ title + "'>" + text + "</a>"
  );
});

Handlebars.registerHelper('concat', function(str1, str2) {
  return new Handlebars.SafeString(
    "'"+ str1 + " " + str2 + "'"
  );
});