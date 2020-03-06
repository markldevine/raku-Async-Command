unit        class Async::Command::Result:api<0.1.0>:auth<Mark Devine (mark@markdevine.com)>;

has Str     @.command;
has Int     $.exit-code = 1;
has Str     $.stderr-results is required;
has Str     $.stdout-results is required;
has Real    $.time-out = 0;
has Bool    $.timed-out = False;
has Str     $.unique-id;

=finish
