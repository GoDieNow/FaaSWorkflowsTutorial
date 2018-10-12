// Function: delTodo
//
// The following function deletes the ToDo selected wherever it is...
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

function main(params) {

    var data = params.data;

    // KISS principle ¯\_(ツ)_/¯
    delete data.todo[params.action.del];
    delete data.wip[params.action.del];
    delete data.done[params.action.del];

    return Object.assign(params,
        { "data": data }
    );
};
