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
::
+$  command
  $%  [%begin =gruv]
      [%pause ?]
      [%cont ?]
      [%mod mod=gruv]  :: for changing wrap, rest, rewarp on the fly
      [%nav =display]
  ==
::
+$  update
  $%  command
      [%blank def=gruv]
  ==
::
+$  then  [@da @da]
+$  prev-cmd  ?(%begin %pause %cont %fresh)
::  state for rudder, a copy of +.state-0
::
+$  tack  [=then groove=gruv =prev-cmd =display =mode]
--
