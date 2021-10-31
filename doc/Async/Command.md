Async::Command
==============
Run an individual command asynchronously.

[Async::Command::Multi](https://github.com/markldevine/raku-Async-Command/blob/main/doc/Async/Command/Multi.md) for parallelism.

[Async::Command::Result](https://github.com/markldevine/raku-Async-Command/blob/main/doc/Async/Command/Result.md) to view the output data structure of Async::Command.

Synopsis
--------

One-liner: output the STDOUT of a simple command

```
    user@AREA51:~> raku -M Async::Command -e 'Async::Command.new(:command</usr/bin/uname -n>).run.stdout-results.print;'
    AREA51
```

In a Raku file

```raku
    #!/usr/bin/env raku
    use Async::Command;
    my Async::Command $cmd .= new(:command('/usr/bin/sleep', '.01'), :time-out(.001));
    my $result = $cmd.run;
```
    #    .Async::Command::Result @0
    #    ├ @.command = [2][Str] @1
    #    │ ├ 0 = /usr/bin/sleep.Str
    #    │ └ 1 = .01.Str
    #    ├ $.attempts = 1   
    #    ├ $.exit-code = 1
    #    ├ $.stderr-results = 
    #    │   [timed out]
    #    │   .Str
    #    ├ $.stdout-results = .Str
    #    ├ $.time-out = 0.001 (1/1000).Rat
    #    ├ $.timed-out = True
    #    └ $.unique-id = Nil
```raku
    # reuse the same command again with a new time out
    $result = $cmd.run(:time-out(.1));
```
    #    .Async::Command::Result @0
    #    ├ @.command = [2][Str] @1
    #    │ ├ 0 = /usr/bin/sleep.Str
    #    │ └ 1 = .01.Str
    #    ├ $.attempts = 1   
    #    ├ $.exit-code = 0   
    #    ├ $.stderr-results = .Str
    #    ├ $.stdout-results = .Str
    #    ├ $.time-out = 0.1 (1/10).Rat
    #    ├ $.timed-out = False
    #    └ $.unique-id = Nil

Description
===========
Aync::Command will
  - execute & manage the specified command in a promise
  - enforce a time out (optionally)
  - retry on failure (optionally)
  - delay in between retry attempts (optionally)
  - capture all results in an [Async::Command::Result](https://github.com/markldevine/raku-Async-Command/blob/main/doc/Async/Command/Result.md) object

Methods
=======

new()
-----

    :@command
    
Required List or Array of the command and arguments. Absolute paths are encouraged.
    
    :$time-out
    
Optional persistent time-out in Real seconds. '0' indicates no time out.

run()
-----

    :$time-out
    
Optional time-out override in Real seconds. Useful for re-running the command with different time out value.

    :$attempts
    
Optional retry attempts maximum.

    :$delay
    
Optional delay interval between retry attempts.

Examples
========
An example script that runs a curl command

```raku
    use Async::Command;

    my @command = [
                    'curl',
                    '-H', 'Content-Type:application/json',
                    '-d', '{"user":"myuserid","password":"mYpAsSwOrD!"}',
                    '-X', ' POST',
                    '-k',
                    '-s',
                    'https://10.20.30.40/api/get_token',
                 ];

    my $json-token = Async::Command.new(:@command, :time-out(2.5), :2attempts, :delay(.1)).run.stdout-results;
```
