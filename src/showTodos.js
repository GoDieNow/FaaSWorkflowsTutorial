// Function: showTodos
//
// The following function sends the state of the previous operation (if
// available) and a copy of the actual data.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

function main(params) {

    return Object.assign(
        { "data": params.data },
        { "result": params.result },
        { "error": params.error }
    );

};
