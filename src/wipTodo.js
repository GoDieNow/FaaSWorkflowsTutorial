// Function: wipTodo
//
// The following function moves the ToDo selected under the WiP-tag.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

function main(params) {

    var data = params.data;

    var todo = "";

    if (data.todo[params.action.wip]) {

        todo = data.todo[params.action.wip];
        delete data.todo[params.action.wip];

    } else if (data.done[params.action.wip]) {

        todo = data.done[params.action.wip];
        delete data.done[params.action.wip];

    } else {

        return params;

    }

    if (!data.wip) {
        data.wip = {};
    }

    data.wip[params.action.wip] = todo;

    return { "data": data };
};
