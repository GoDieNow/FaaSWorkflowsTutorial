// Function: addTodo
//
// The following function adds the new ToDo under the ToDos-tag.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

function main(params) {

    var data = params.data;

    // In case the todo-list is empty (or just doesn't exists)
    if (!data.todo) {
        data.todo = {};
    }

    data.todo[params.data.count] = params.action.add;

    data.count = parseInt(params.data.count, 10) + 1;

    return { "data": data };
};
