function msg_yn(msg) {
    msg = msg ? msg : '提示：删除将无法恢复！你确认要删除吗？';
    const i = window.prompt(msg, '请在这里输入 yes 确认操作');
    return i === 'yes';
}

function request(jquery, url, data = {}, callback, type = 'get') {
    jquery.ajax({
        url: url,
        data: data,
        dataType: 'text',
        type: type,

        beforeSend: function () {
            layer.load(2, {
                shade:[0.5, "#333"]
            });
        },
        success: function (res) {
            callback(res, null);
        },
        error: function (xhr) {
            callback(null, xhr);
        },
        complete: function () {
            layer.closeAll("loading");
        },
    });
}
