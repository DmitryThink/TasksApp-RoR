$(function() {
    //webSocket
    var pusher = new Pusher('95b419d449b8e83152e5', {
        cluster: 'eu',
        encrypted: true
    });

    //channel for creating task
    var channelCreateTask = pusher.subscribe('CreateTask');
    channelCreateTask.bind('task', function(data) {
        var s = '';
        if(data.model.checked) s = ' checked="checked"';
        $('#tasks_list' + data.model.userId + ' tbody').append('<tr id = "task' +data.model.id +'"><td>' + data.model.name + '</td><td>' + data.model.description + '</td><td>' +
            '<input id="checkbox_list" disabled="disabled" type="checkbox" value="1" '+ s + ' name="task[checked]"></td></tr>');
    });
    //channel for deleting task
    var channelDestroyTask = pusher.subscribe('DestroyTask');
    channelDestroyTask.bind('task', function(data) {
        $('#tasks_list' + data.model.userId + ' tbody tr#task'+ data.model.id).remove();
    });
    //channel for updating task
    var channeUpdateTask= pusher.subscribe('UpdateTask');
    channeUpdateTask.bind('task', function (data) {
        var s = '';
        if(data.model.checked) s = ' checked="checked"';
        $('#tasks_list'+ data.model.userId +' tbody tr#task'+ data.model.id+ ' td').remove();
        $('#tasks_list'+ data.model.userId +' tbody tr#task'+ data.model.id).append('<td>' + data.model.name + '</td><td>' + data.model.description + '</td><td>' +
            '<input id="checkbox_list" disabled="disabled" type="checkbox" value="1" '+ s + ' name="task[checked]"></td></tr>');
    });
});

