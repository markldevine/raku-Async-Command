Async::Command::Multi
=====================
`Async::Command::Multi` executes multiple `Async::Command` instances.

Synopsis
========

```raku
    use Async::Command::Multi;

    my %command;
    %command<ngroups_max> = </bin/cat /proc/sys/kernel/ngroups_max>;
    %command<uptime>      = </usr/bin/uptime>;
    ...
    %command<commandN> = </bin/commandN --cN>;

    my $command-manager = Async::Command::Multi.new(:%command, :2time-out, :4batch);
    $command-manager.sow;                   # start promises
    
    # do other things...
    
    my %result = $command-manager.reap;     # await promises

    # examine $*OUT from each successfully Kept promise
    for %result.keys -> $key {
        printf("[%s] %s:\n", !%result{$key}.exit-code ?? '+' !! '-', $key);
        .say for %result{$key}.stdout-results;
    }
```

Methods
=======

new()
-----

    :%command

_keys_ are arbitrary and utilized by `Async::Command` to maintain associations.

_values_ are independent commands to execute. Absolute paths are encouraged.

    :$time-out

Optional global timer for each promise, in Real seconds. No individual promise
should take longer than this number of Real seconds to complete its thread.
'0' indicates no time out.

    :$batch

Promise throttle. Default = 16. Mutable for subsequent re-runs.

sow()
-----

Method `sow()` starts multiple Async::Command instances (promises).

reap()
------

Method `reap()` awaits all sown promises and returns a hash of `Async::Command::Result` objects.

Example
=======

_Given_

```raku
    #!/usr/bin/env raku
    use Async::Command::Multi;
    my %command;
    %command<ctools> = <ssh ctools uname -n>;
    %command<jtools> = <ssh jtools notarealcommand>;
    dd $ = Async::Command::Multi.new(:%command, :1time-out).sow.reap;
```

_Output_

    Hash $ = ${
        :ctools(Async::Command::Result.new(
            command => ["ssh", "ctools", "uname", "-n"],
            exit-code => 0,
            stdout-results => "CTUNIXVMADMINPv\n",
            stderr-results => "",
            time-out => 1,
            timed-out => Bool::False,
            unique-id => "ctools")),
        :jtools(Async::Command::Result.new(
            command => ["ssh", "jtools", "notarealcommand"],
            exit-code => 127,
            stdout-results => "",
            stderr-results => "sh: notarealcommand: command not found\n",
            time-out => 1,
            timed-out => Bool::False,
            unique-id => "jtools"))
    }
