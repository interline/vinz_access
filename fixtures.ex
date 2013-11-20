group("test group", "this is just a test group")
right("global foo rights", "foo", [ :create, :read ])
right("test group foo rights", "foo", "test group", [ :create, :read ])
filter("test group bar filter", "bar", "test group", "boo.name == :baz", [ :create, :read ])