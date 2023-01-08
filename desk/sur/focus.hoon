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
+$  then  [@da @da]
::  these type unions are for ^- and applying %- to data, from within a
::  gate?
::
+$  display  ?(%form %help %clock %enter)
+$  mode  ?(%fin %rest %focus)
+$  prev-cmd  ?(%begin %pause %cont %fresh)
+$  begin  ?
+$  state-p  [=display =mode =prev-cmd =begin]
::
++  displayify
  |=  incoming=@tas
  %-  display  incoming
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
::  state for rudder, a copy of +.state-0
::
+$  tack  [groove=gruv then state-p]
--
