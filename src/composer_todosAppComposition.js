//
// The following piece of code describes the composition of functions needed
// by IBM Composer to create the app for the example.
//
// Author: Diego Martin (October 2018)
//
////////////////////////////////////////////////////////////////////////////////

composer.sequence('FWTt/getTodos',
    composer.if(params => (!!params.action) && (params.action.constructor === Object),
        composer.sequence(
            composer.if(params => params.action.add || params.action.del,
                composer.if(params => params.action.add,
                    'FWTt/addTodo',
                    'FWTt/delTodo'
                ),
                composer.if(params => params.action.wip,
                    'FWTt/wipTodo',
                    'FWTt/doneTodo'
                )
            ),
            'FWTt/updateTodos'
        ),
        composer.empty()
    ),
    'FWTt/showTodos'
);
