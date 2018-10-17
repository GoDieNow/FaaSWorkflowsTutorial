//
// The following code is intended to be joined to all the *.js common functions
// files in order to make them work within the nodejs enviroment within Fission.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

module.exports = async function (input) {

    const body = input.request.body;

    var result = await main(body);

    return {
        status: 200,
        body: result || { "error": "Something went wrong ma'am"},
        headers: {
            'Content-Type': 'application/json'
        }
    };

}
