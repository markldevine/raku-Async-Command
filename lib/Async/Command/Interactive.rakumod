unit    class       Async::Command::Interactive:api<1>:auth<Mark Devine (mark@markdevine.com)>;

subset  CSpec       where * ~~ List|Array;

has     CSpec       @.command-base is required;
has     $process    = Proc::Async.new(:w, :o, :e, @command-base);

=finish

    - Each subsequent @.command-base ~ $command needs it's own:
        - stdout.tap (read-routine, quit block)
        - stderr.tap (error-printer)
    - Once all taps are established, start the process
    - for the $command (owner of particular taps)
        - await .write($command)
        - let the particular

    * the stdout tap's read routine must given/when based on the output, therefore we need a way to know which parse routine will be dispatched...

$process.stdout.lines.tap(-> $v { $*OUT.put: $v }, quit => { say 'caught exception ' ~ .^name });
$process.stderr.lines.tap(-> $v { $*ERR.put: "Error:  $v" });

my $process-promise = $process.start;

    $process.write(Buf.new("select * from STGPOOLS\n".encode));
    await Promise.allof(@write-promises);
    @write-promises         = ();
}

$process.close-stdin;
await $process-promise;

=finish
