$(function() {
    //webSocket
    var pusher = new Pusher('95b419d449b8e83152e5', {
        cluster: 'eu',
        encrypted: true
    });

    //channel for creating list
    var channelCreateList = pusher.subscribe('CreateList');
    channelCreateList.bind('list', function(data) {
        $('#lists_list' + data.model.userId + ' tbody').append('<tr id ="list' +data.model.id +'"><td>' + data.model.name + '</td><td> <a href="/lists/user/' + data.model.userId + '/' + data.model.id+ '">Link to tasks</a> </td></tr>');
    });
    //channel for deleting list
    var channelDestroyList = pusher.subscribe('DestroyList');
    channelDestroyList.bind('list', function(data) {
        $('#lists_list' + data.model.userId + ' tbody tr#list'+ data.model.id).remove();
    });
    //channel for updating list
    var channeUpdateList = pusher.subscribe('UpdateList');
    channeUpdateList.bind('list', function (data) {
        $('#lists_list'+ data.model.userId +' tbody tr#list'+ data.model.id+ ' td').remove();
        $('#lists_list'+ data.model.userId +' tbody tr#list'+ data.model.id).append('<td>' + data.model.name + '</td><td> <a href="/lists/user/' + data.model.userId + '/' + data.model.id+ '">Link to tasks</a> </td></tr>');
    });
});
