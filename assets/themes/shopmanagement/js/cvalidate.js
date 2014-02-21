if (! document.getElementById) {
    if (document.all) {
        document.getElementById = function () {
            if (typeof document.all[arguments[0]] != "undefined") {
                return document.all[arguments[0]];
            }
            else {
                return null;
            }
        };
    }
    else {
        if (document.layers) {
            document.getElementById = function () {
                if (typeof document[arguments[0]] != "undefined") {
                    return document[arguments[0]];
                }
                else {
                    return null;
                }
            };
        }
    }
}
function trimAll(a) {
    while (a.substring(0, 1) == " ") {
        a = a.substring(1, a.length);
    }
    while (a.substring(a.length - 1, a.length) == " ") {
        a = a.substring(0, a.length - 1);
    }
    return a;
}
function validateForm(g) {
    var n = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i;
    var b = /^\d\d\/\d\d\/\d\d\d\d$/;
    var m = /^\-?\d+$/;
    var F = /^[a-zA-Z ]+$/;
    var C = /^\w+$/;
    var h = /^\-?\d+(\.\d+)?$/;
    var J = /^https?\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?$/;
    var k = document.forms[g];
    var o = new Array();
    var y = "";
    var E = "";
    var d = 0;
    var q = "";
    var w = "";
    var r = "";
    var c = "";
    var l = "";

    for (var O = 0; O < k.elements.length; O ++) {
        o = k.elements[O].className.split(" ");

        if (o[0] == "required" || o[0] == "REQUIRED") {
            d ++;
            c = k.elements[O];
            q = k.elements[O].type;

            if (k.elements[O].getAttribute("name")) {
                y = k.elements[O].getAttribute("name");
            }

            if (k.elements[O].getAttribute("title")) {
                r = k.elements[O].getAttribute("title");
            }

            if (! r) {
                r = y;
            }

            w = k.elements[O].value;
            E = o[1];

            for (var G = 0; G < 99; G ++) {
                if (o[G] == "min") {
                    var A = o[parseInt(G, 10) + 1];
                }
                else {
                    if (o[G] == "max") {
                        var e = o[parseInt(G, 10) + 1];
                    }
                    else {
                        if (o[G] == "match") {
                            var t = o[parseInt(G, 10) + 1];
                            var x = w;
                            var v = r;
                            var Q = c;
                        }
                        else {
                            if (o[G] == "regex") {
                                var f = o[parseInt(G, 10) + 1];
                            }
                            else {
                                if (o[G] == "length") {
                                    var u = o[parseInt(G, 10) + 1];
                                }
                            }
                        }
                    }
                }
            }

            if (t != "" && y == t) {
                var M = w;
                var D = r;

                if (trimAll(x) != "" && trimAll(M) != "") {
                    if (x.length < A && A > 0 && Q.className.indexOf("min") != - 1) {
                        Q.style.borderColor = "#FF0000";
                        l += "-->  " + v + " - should be at least " + A + " characters long\n";
                    }
                    else {
                        if (x.length > e && e > 0 && Q.className.indexOf("max") != - 1) {
                            Q.style.borderColor = "#FF0000";
                            l += "-->  " + v + " - should be at most " + e + " characters long\n";
                        }
                        else {
                            if (x != M) {
                                Q.style.borderColor = "#FF0000";
                                l += "-->  " + v + " - and " + D + "  must MATCH\n";
                            }
                            else {
                                Q.style.borderColor = "#00FF00";
                            }
                        }
                    }
                }
            }

            switch (E) {
                case"regex":
                    if (trimAll(w) == "") {
                        c.style.borderColor = "#FF0000";
                        l += "-->  " + r + " - REQUIRED\n";
                    }
                    else {
                        if (c.className.indexOf("regex") != - 1) {
                            var B = (new RegExp(f)).exec(w);
                            if (B == null) {
                                c.style.borderColor = "#FF0000";
                                l += "-->  " + r + " - should be in correct format\n";
                            }
                            else {
                                c.style.borderColor = "#00FF00";
                            }
                        }
                        else {
                            c.style.borderColor = "#00FF00";
                        }
                    }
                    break;
                case"alpha":
                    if (trimAll(w) == "") {
                        c.style.borderColor = "#FF0000";
                        l += "-->  " + r + " - REQUIRED\n";
                    }
                    else {
                        if (! C.test(w)) {
                            c.style.borderColor = "#FF0000";
                            l += "-->  " + r + " - should be ALPHA characters\n";
                        }
                        else {
                            if (w.length > u && c.className.indexOf("length") != - 1) {
                                c.style.borderColor = "#FF0000";
                                l += "-->  " + r + " - should not exceed " + u + " characters\n";
                            }
                            else {
                                c.style.borderColor = "#00FF00";
                            }
                        }
                    }
                    break;
                case"text":
                    if (trimAll(w) == "") {
                        c.style.borderColor = "#FF0000";
                        l += "-->  " + r + " - REQUIRED\n";
                    }
                    else {
                        if (! F.test(w)) {
                            c.style.borderColor = "#FF0000";
                            l += "-->  " + r + " - should only contain A-Z characters\n";
                        }
                        else {
                            if (w.length > u && c.className.indexOf("length") != - 1) {
                                c.style.borderColor = "#FF0000";
                                l += "-->  " + r + " - should not exceed " + u + " characters\n";
                            }
                            else {
                                c.style.borderColor = "#00FF00";
                            }
                        }
                    }
                    break;
                case"email":
                    if (trimAll(w) == "") {
                        c.style.borderColor = "#FF0000";
                        l += "-->  " + r + " - REQUIRED\n";
                    }
                    else {
                        if (! n.test(w)) {
                            c.style.borderColor = "#FF0000";
                            l += "-->  " + r + " - should be in valid EMAIL format\n";
                        }
                        else {
                            if (w.length > u && c.className.indexOf("length") != - 1) {
                                c.style.borderColor = "#FF0000";
                                l += "-->  " + r + " - should not exceed " + u + " characters\n";
                            }
                            else {
                                c.style.borderColor = "#00FF00";
                            }
                        }
                    }
                    break;
                case"date":
                    if (trimAll(w) == "") {
                        c.style.borderColor = "#FF0000";
                        l += "-->  " + r + " - REQUIRED\n";
                    }
                    else {
                        if (! b.test(w)) {
                            c.style.borderColor = "#FF0000";
                            l += "-->  " + r + " - should be in DD/MM/YYYY format\n";
                        }
                        else {
                            if (w.length > u && c.className.indexOf("length") != - 1) {
                                c.style.borderColor = "#FF0000";
                                l += "-->  " + r + " - should not exceed " + u + " characters\n";
                            }
                            else {
                                c.style.borderColor = "#00FF00";
                            }
                        }
                    }
                    break;
                case"number":
                    if (trimAll(w) == "") {
                        c.style.borderColor = "#FF0000";
                        l += "-->  " + r + " - REQUIRED\n";
                    }
                    else {
                        if (! m.test(w)) {
                            c.style.borderColor = "#FF0000";
                            l += "-->  " + r + " - should contain only NUMBERS\n";
                        }
                        else {
                            if (parseInt(w, 10) < parseInt(A, 10) && parseInt(A,
                               10) > 0 && c.className.indexOf("min") != - 1) {
                                c.style.borderColor = "#FF0000";
                                l += "-->  " + r + " - should be at least " + A + "\n";
                            }
                            else {
                                if (parseInt(w, 10) > parseInt(e, 10) && parseInt(e,
                                   10) > 0 && c.className.indexOf("max") != - 1) {
                                    c.style.borderColor = "#FF0000";
                                    l += "-->  " + r + " - should be at most " + e + "\n";
                                }
                                else {
                                    c.style.borderColor = "#00FF00";
                                }
                            }
                        }
                    }
                    break;
                case"decimal":
                    if (trimAll(w) == "") {
                        c.style.borderColor = "#FF0000";
                        l += "-->  " + r + " - REQUIRED\n";
                    }
                    else {
                        if (! h.test(w)) {
                            c.style.borderColor = "#FF0000";
                            l += "-->  " + r + " - should contain only DECIMAL NUMBER\n";
                        }
                        else {
                            if (parseInt(w, 10) < parseInt(A, 10) && parseInt(A,
                               10) > 0 && c.className.indexOf("min") != - 1) {
                                c.style.borderColor = "#FF0000";
                                l += "-->  " + r + " - should be at least " + A + "\n";
                            }
                            else {
                                if (parseInt(w, 10) > parseInt(e, 10) && parseInt(e,
                                   10) > 0 && c.className.indexOf("max") != - 1) {
                                    c.style.borderColor = "#FF0000";
                                    l += "-->  " + r + " - should be at most " + e + "\n";
                                }
                                else {
                                    c.style.borderColor = "#00FF00";
                                }
                            }
                        }
                    }
                    break;
                case"web":
                    if (trimAll(w) == "") {
                        c.style.borderColor = "#FF0000";
                        l += "-->  " + r + " - REQUIRED\n";
                    }
                    else {
                        if (! J.test(w)) {
                            c.style.borderColor = "#FF0000";
                            l += "-->  " + r + " - should be in URL format\n";
                        }
                        else {
                            if (w.length > u && c.className.indexOf("length") != - 1) {
                                c.style.borderColor = "#FF0000";
                                l += "-->  " + r + " - should not exceed " + u + " characters\n";
                            }
                            else {
                                c.style.borderColor = "#00FF00";
                            }
                        }
                    }
                    break;
                default:
                    if (q == "checkbox") {
                        if (! c.checked) {
                            l += "-->  " + r + " - REQUIRED\n";
                        }
                    }
                    else {
                        if (trimAll(w) == "") {
                            c.style.borderColor = "#FF0000";
                            l += "-->  " + r + " - REQUIRED\n";
                        }
                        else {
                            if (q != "radio") {
                                c.style.borderColor = "#00FF00";
                            }
                        }
                    }
                    break;
            }
        }
    }

    var H = "";
    var s = "";
    var K = new Array();
    var P = new Array();
    var I = "";

    for (var N = 0; N < k.elements.length; N ++) {
        arr_vtype2 = k.elements[N].className.split(" ");

        if (arr_vtype2[0] == "required") {
            if (k.elements[N].type == "radio") {
                if (! k.elements[N].checked) {
                    if (I.indexOf(k.elements[N].getAttribute("title")) == - 1) {
                        k.elements[N].style.borderColor = "#FF0000";
                        I += "-->  " + k.elements[N].getAttribute("title") + " - REQUIRED\n";
                    }
                }
                else {
                    if (k.elements[N].checked) {
                        s += "|" + k.elements[N].getAttribute("title");
                        H += "|" + k.elements[N].getAttribute("name");
                    }
                }
            }
        }
    }

    K = H.split("|");
    P = s.split("|");

    for (var L in K) {
        I = I.replace("-->  " + P[L] + " - REQUIRED\n", "");
    }

    if (I) {
        l += I;
    }

    if (l) {
        var a = "----------------------------------------------";
        alert("You failed to correctly fill in your form:\n" + a + "\n" + l + a + "\nPlease re-enter and submit again!");
        return false;
    }
    else {
        return true;
    }
}
function getViewportSize() {
    var a = [0, 0];

    if (typeof window.innerWidth != "undefined") {
        a = [window.innerWidth, window.innerHeight];
    }
    else {
        if (typeof document.documentElement != "undefined" && typeof document.documentElement.clientWidth != "undefined" && document.documentElement.clientWidth != 0) {
            a = [document.documentElement.clientWidth, document.documentElement.clientHeight];
        }
        else {
            a = [document.getElementsByTagName("body")[0].clientWidth,
                document.getElementsByTagName("body")[0].clientHeight];
        }
    }

    return a;
}
function getPageDimensions() {
    var a = document.getElementsByTagName("body")[0];
    var d = 0;
    var b = 0;
    var c = 0;
    var f = 0;
    var e = [0, 0];

    if (typeof document.documentElement != "undefined" && typeof document.documentElement.scrollWidth != "undefined") {
        e[0] = document.documentElement.scrollWidth;
        e[1] = document.documentElement.scrollHeight;
    }

    d = a.offsetWidth;
    b = a.offsetHeight;
    c = a.scrollWidth;
    f = a.scrollHeight;

    if (d > e[0]) {
        e[0] = d;
    }
    if (b > e[1]) {
        e[1] = b;
    }
    if (c > e[0]) {
        e[0] = c;
    }
    if (f > e[1]) {
        e[1] = f;
    }

    return e;
}
function getScrollingPosition() {
    var a = [0, 0];

    if (typeof window.pageYOffset != "undefined") {
        a = [window.pageXOffset, window.pageYOffset];
    }
    else {
        if (typeof document.documentElement.scrollTop != "undefined" && document.documentElement.scrollTop > 0 || document.documentElement.scrollLeft > 0) {
            a = [document.documentElement.scrollLeft, document.documentElement.scrollTop];
        }
        else {
            if (typeof document.body.scrollTop != "undefined") {
                a = [document.body.scrollLeft, document.body.scrollTop];
            }
        }
    }

    return a;
}
function identifyBrowser() {
    var c = navigator.userAgent.toLowerCase();

    if (typeof navigator.vendor != "undefined" && navigator.vendor == "KDE" && typeof window.sidebar != "undefined") {
        return"kde";
    }
    else {
        if (typeof window.opera != "undefined") {
            var a = parseFloat(c.replace(/.*opera[\/ ]([^ $]+).*/, "$1"));
            if (a >= 7) {
                return"opera7";
            }
            else {
                if (a >= 5) {
                    return"opera5";
                }
            }
            return false;
        }
        else {
            if (typeof document.all != "undefined") {
                if (typeof document.getElementById != "undefined") {
                    var b = c.replace(/.*ms(ie[\/ ][^ $]+).*/, "$1").replace(/ /, "");
                    if (typeof document.uniqueID != "undefined") {
                        if (b.indexOf("5.5") != - 1) {
                            return b.replace(/(.*5\.5).*/, "$1");
                        }
                        else {
                            return b.replace(/(.*)\..*/, "$1");
                        }
                    }
                    else {
                        return"ie5mac";
                    }
                }
                return false;
            }
            else {
                if (typeof document.getElementById != "undefined") {
                    if (navigator.vendor.indexOf("Apple Computer, Inc.") != - 1) {
                        if (typeof window.XMLHttpRequest != "undefined") {
                            return"safari1.2";
                        }
                        return"safari1";
                    }
                    else {
                        if (c.indexOf("gecko") != - 1) {
                            return"mozilla";
                        }
                    }
                }
            }
        }
    }

    return false;
}