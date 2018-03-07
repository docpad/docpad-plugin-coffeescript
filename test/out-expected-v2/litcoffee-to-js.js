(function() {
  // The **Scope** class regulates lexical scoping within CoffeeScript. As you
  // generate code, you create a tree of scopes in the same shape as the nested
  // function bodies. Each scope knows about the variables declared within it,
  // and has a reference to its parent enclosing scope. In this way, we know which
  // variables are new and need to be declared with `var`, and which are shared
  // with external scopes.

  // Import the helpers we plan to use.
  var a;

  a = require('./helpers');

}).call(this);
