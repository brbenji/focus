::  additional types for potentail expansion
::  +$  ease  @dr  :: def ~s4 before focus begins, a delay on begin
::  +$  name  @t
::
|%
+$  focus  @dr
+$  wrap  @ud  :: signal before time ends
+$  reps  @ud
+$  rest  @dr
+$  wrep  @ud  :: wrap for the rest periods
+$  gruv  [=focus =wrap =reps =rest =wrep]
::
+$  display  ?(%form %help %clock)
+$  mode  ?(%fin %rest %focus)
+$  begin  ?
::
+$  command
  $%  [%maneuver =gruv =display =begin]
      [%pause ?]
      [%cont ?]
  ==
::
+$  update
  $%  command
      [%blank def=gruv]
  ==
::
+$  then  [@da @da]
+$  prev-cmd  ?(%maneuver %pause %cont %fresh)
+$  state-0  [%0 =then groove=gruv =prev-cmd =display =mode]
+$  state-1  [%1 =then groove=gruv =prev-cmd =display =mode =begin]
::  state for rudder, a copy of +.state-0
::
+$  tack  [=then groove=gruv =prev-cmd =display =mode =begin]
--
