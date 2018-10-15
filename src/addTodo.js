// Function: addTodo
//
// The following function adds the new ToDo under the ToDos-tag.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

function main(params) {

    var data = params.data;

    if (!data.todo) {
        data.todo = {};
    }

    data.todo[params.data.count] = params.action.add;

    data.count = parseInt(params.data.count, 10) + 1;

    return { "data": data };
};
