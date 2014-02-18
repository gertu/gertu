exports.dateToString = (date) ->
  date.getFullYear()             + "-" +
  twoDigits(date.getMonth() + 1) + "-" +
  twoDigits(date.getDate())      + "-" +
  twoDigits(date.getHours())     +
  twoDigits(date.getMinutes())   +
  twoDigits(date.getSeconds())

twoDigits = (i) ->
  (if (i < 10) then "0" + i else "" + i)


exports.slugify = (text) ->
  accents =
    a: /\u00e1/g
    e: /u00e9/g
    i: /\u00ed/g
    o: /\u00f3/g
    u: /\u00fa/g
    n: /\u00f1/g

  slug = text.toString().toLowerCase()

  for i of accents
    slug = slug.replace(accents[i], i)

  slug
    .replace(/\s+/g, "-")         # Replace spaces with -
    .replace(/[^\w\-]+/g, "")     # Remove all non-word chars
    .replace(/\-\-+/g, "-")       # Replace multiple - with single -
    .replace(/^-+/, "")           # Trim - from start of text
    .replace /-+$/, ""            # Trim - from end of text


exports.shopRating = (rating) ->
  ratings =
    1 : -0.5
    2 : -0.3
    3 : -0.2
    4 : -0.1
    5 : 0
    6 : 0.1
    7 : 0.2
    8 : 0.3
    9 : 0.4
    10: 0.5

  convertedRating = ratings[rating]