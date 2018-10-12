// Function: getTodos
//
// The following function handles the retrieving of the data from the storage.
// In this case we are using JSONbin.io as storage.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

var request = require("request");

var bin = "REPLACE_ME";

function main(params) {

    var options = {
        url: "https://api.jsonbin.io/b/"+bin+"/latest",
        json: true
    };

    return new Promise(function(resolve, reject) {
        request(options, function(err, resp) {

            if (err) {
                reject({error: err})
            }

            resolve(Object.assign(params,
                { "data": resp.body }
            ));
        });
    });

};
