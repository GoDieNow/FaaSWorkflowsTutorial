// Function: updateTodos
//
// The following function updates the actual data to the storage place.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

var request = require("request");

var bin = "REPLACE_ME";
var init = {
    "todo": {
        "2": "Finish the ToDo App!"
    },
    "wip": {
        "1": "Attend the FaaS Workflows Tutorial!"
    },
    "done": {
        "0": "Create the initial test-ToDo :)"
    },
    "count": "3"
};

function main(params) {
    var options = {
        url:"https://api.jsonbin.io/b/"+bin,
        method: "PUT",
        headers: "Content-Type: application/json",
        json: params.data || init
    };
    return new Promise(function(resolve, reject) {
        request(options, function(err, resp) {
            if (err) {
                Object.assign(params,
                    { "error": "Failed! We were not able to update!" }
                )
            }
            resolve(
                Object.assign(params,
                    { "result": "Done! ToDo's updated!" }
                )
            );
        });
    });
};
