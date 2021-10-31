Async::Command::Result
======================

Encapsulates the results of a completed [Async::Command](https://github.com/markldevine/raku-Async-Command/blob/main/doc/Async/Command.md) run().

Attributes
----------

_command_

- The executed command that produced the result.

_attempts_

- The actual number of execution attempts.

_exit-code_

- e last exit code returned from the command.

_stderr-results_

- e STDERR stream from the command.

_stdout-results_

- e STDOUT stream from the command.

_time-out_

- e timer that constrained the command's execution opportunity.

_timed-out_

- flag that indicates whether or not the command completed within the prescribed time interval. If timed-out is true, execution was aborted.

_unique-id_

-  arbitrary identifier that is typically used to track the command from the original caller's perspective (used internally by [Async::Command::Multi](https://github.com/markldevine/raku-Async-Command/blob/main/doc/Async/Command/Multi.md))
