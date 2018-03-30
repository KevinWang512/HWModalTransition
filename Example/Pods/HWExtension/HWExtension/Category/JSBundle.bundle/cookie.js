// 获取cookies
function __native_injection_getCookies()
{
    var cookies = decodeURI(document.cookie).split(";");
    return cookies;
}

// 获取cookie
function __native_injection_getCookie(name)
{
    var arr,reg = new RegExp("(^| )" + encodeURI(name) + "=([^;]*)(;|$)");
    if(arr = document.cookie.match(reg))
        return decodeURI(arr[2]);
    else
        return undefine;
}

// 写cookie
function __native_injection_setCookie(name, value, seconds)
{
    var exp = new Date();
    exp.setTime(exp.getTime() + seconds * 1000);
    document.cookie = encodeURI(name) + "=" + encodeURI(value) + ";expires=" + exp.toGMTString();
}

// 删除cookie
function __native_injection_deleteCookie(name)
{
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval = __native_injection_getCookie(name);
    if(cval != null)
        document.cookie = encodeURI(name) + "=" + cval + ";expires=" + exp.toGMTString();
}

// 删除所有cookie
function __native_injection_deleteAllCookies()
{
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    
    var keys = document.cookie.match(/[^ =;]+(?=\=)/g);
    
    if (keys.length)
    {
        for (var i = keys.length; i >=0; i--)
            document.cookie = keys[i] + "=0;expires=" + exp.toGMTString();
    }
}
