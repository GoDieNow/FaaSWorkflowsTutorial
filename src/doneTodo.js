// Function: doneTodo
//
// The following function moves the ToDo selected under the Done-tag.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

function main(params) {

    var data = params.data;

    var todo = "";

    if (data.todo[params.action.done]) {

        todo = data.todo[params.action.done];
        delete data.todo[params.action.done];

    } else if (data.wip[params.action.done]) {

        todo = data.wip[params.action.done];
        delete data.wip[params.action.done];

    } else {

        return params;

    }

    data.done[params.action.done] = todo;

    return Object.assign(params,
        { "data": data }
    );
};