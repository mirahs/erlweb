function msg_yn(msg) {
    msg = msg ? msg : '提示:删除将无法恢复!你确认要删除吗?';
    const i = window.prompt(msg, '请在这里输入:yes 确认操作');
    return i === 'yes';
}

function request($, url, data = {}, callback) {
    $.ajax({
        url: url
        ,data: data
        ,dataType: 'text',

        beforeSend: function() {
            layer.load(2, {
                shade:[0.5, "#333"]
            });
        },
        success: function(res) {
            callback(res, null);
        },
        error: function(xhr) {
            callback(null, xhr);
        },
        complete: function() {
            //关掉loading
            layer.closeAll("loading");
        },
    });
}
