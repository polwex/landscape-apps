/-  d=diary, g=groups, ha=hark
/-  meta
/-  e=epic
/+  default-agent, verb, dbug
/+  not=notes
/+  qup=quips
/+  diary-json
/+  epos-lib=saga
^-  agent:gall
=>
  |%
  ++  okay  `epic:e`0
  +$  card  card:agent:gall
  +$  current-state
    $:  %0
        =shelf:d
        voc=(map [flag:d time] (unit said:d))
    ==
  --
=|  current-state
=*  state  -
=< 
  %+  verb  &
  %-  agent:dbug
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %|) bowl)
      cor   ~(. +> [bowl ~])
  ++  on-init  
    ^-  (quip card _this)
    =^  cards  state
      abet:init:cor
    [cards this]
  ::
  ++  on-save  !>([state okay])
  ++  on-load
    |=  =vase
    ^-  (quip card _this)
    =^  cards  state
      abet:(load:cor vase)
    [cards this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    =^  cards  state
      abet:(poke:cor mark vase)
    [cards this]
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    =^  cards  state
      abet:(watch:cor path)
    [cards this]
  ::
  ++  on-peek   peek:cor
  ::
  ++  on-leave   on-leave:def
  ++  on-fail    on-fail:def
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card _this)
    =^  cards  state
      abet:(agent:cor wire sign)
    [cards this]
  ++  on-arvo
    |=  [=wire sign=sign-arvo]
    ^-  (quip card _this)
    =^  cards  state
      abet:(arvo:cor wire sign)
    [cards this]
  --
|_  [=bowl:gall cards=(list card)]
+*  epos  ~(. epos-lib [bowl %diary-update okay])
++  abet  [(flop cards) state]
++  cor   .
++  emit  |=(=card cor(cards [card cards]))
++  emil  |=(caz=(list card) cor(cards (welp (flop caz) cards)))
++  give  |=(=gift:agent:gall (emit %give gift))
++  init
  ^+  cor
  watch-groups
++  mar
  |%
  ++  act  `mark`(rap 3 %diary-action '-' (scot %ud okay) ~)
  ++  upd  `mark`(rap 3 %diary-update '-' (scot %ud okay) ~)
  --
++  load
  |=  =vase
  |^  ^+  cor
  =/  maybe-old=(each [p=versioned-state q=epic:e] tang)
  (mule |.(!<([versioned-state epic:e] vase)))
  =/  [old=versioned-state cool=epic:e bad=?]
    ::  XX only save when epic changes
    ?.  ?=(%| -.maybe-old)  [p q &]:p.maybe-old
    =;  [sta=versioned-state ba=?]  [sta okay ba]
    =-  %+  fall  -  ~&  >  %bad-load  [state &]
    (mole |.([!<(versioned-state vase) |]))
  =.  state  old
  =.  cor
    (emil (drop load:epos))
  =/  diaries  ~(tap in ~(key by shelf))
  |-
  ?~  diaries
    cor
  =.  cor
    di-abet:di-upgrade:(di-abed:di-core i.diaries)
  $(diaries t.diaries)
  ::
  +$  versioned-state  $%(current-state)
  --
::
++  watch-epic
  |=  her=ship
  ^+  cor
  =/  =wire  /epic
  =/  =dock  [her dap.bowl]
  ?:  (~(has by wex.bowl) [wire dock])
    cor
  (emit %pass wire %agent [her dap.bowl] %watch /epic)
::
++  take-epic
  |=  =sign:agent:gall
  ^+  cor
  ?+    -.sign  cor
      %kick
    (watch-epic src.bowl)
  ::
      %fact
    ?.  =(%epic p.cage.sign)
      ~&  '!!! weird fact on /epic'
      cor
    =+  !<(=epic:e q.cage.sign)
    ?.  =(epic okay)
      cor
    ~&  >>  "good news everyone!"
    %+  roll  ~(tap by shelf)
    |=  [[=flag:g =diary:d] out=_cor]
    ?.  =(src.bowl p.flag)
      out
    di-abet:(di-take-epic:(di-abed:di-core:out flag) epic)
  ::
      %watch-ack
    %.  cor
    ?~  p.sign  same
    (slog leaf/"weird watch nack" u.p.sign)
  ==
::
++  watch-groups
  ^+  cor
  (emit %pass /groups %agent [our.bowl %groups] %watch /groups)
::
++  poke
  |=  [=mark =vase]
  |^  ^+  cor 
  ?+    mark  ~|(bad-poke/mark !!)
      ?(%flag %channel-join)
    =+  !<(=flag:d vase)
    ?<  =(our.bowl p.flag)
    (join flag)
  ::
      %diary-leave
    =+  !<(=leave:d vase)
    ?<  =(our.bowl p.leave)  :: cannot leave chat we host
    di-abet:di-leave:(di-abed:di-core leave)
  ::
      %diary-create
    =+  !<(req=create:d vase)
    (create req)
  ::
      ?(%diary-action-0 %diary-action)
    =+  !<(=action:d vase)
    =.  p.q.action  now.bowl
    =/  diary-core  (di-abed:di-core p.action)
    ?:  =(p.p.action our.bowl)
      di-abet:(di-update:diary-core q.action)
    di-abet:(di-proxy:diary-core q.action)
  ::
      %diary-remark-action
    =+  !<(act=remark-action:d vase)
    di-abet:(di-remark-diff:(di-abed:di-core p.act) q.act)
  ==
  ++  join
    |=  =flag:d
    ^+  cor
    =.  shelf  (~(put by shelf) flag *diary:d)
    di-abet:(di-join:di-core flag)
  ::
  ++  create
    |=  req=create:d
    |^  ^+  cor
    ~_  leaf+"Create failed: check group permissions"
      ?>  can-nest
      ?>  ((sane %tas) name.req)
      =/  =flag:d  [our.bowl name.req]
      =|  =diary:d
      =/  =perm:d  [writers.req group.req]
      =.  perm.diary  perm
      =.  net.diary  [%pub ~]
      =.  shelf  (~(put by shelf) flag diary)
      di-abet:(di-init:(di-abed:di-core flag) req)
    ::  +can-nest: does group exist, are we allowed
    ::
    ++  can-nest
      ^-  ?
      =/  gop  (~(got by groups) group.req)
      %-  ~(any in bloc.gop)
      ~(has in sects:(~(got by fleet.gop) our.bowl))
    ::  +groups:
    ::
    ::  this has to be duplicated because
    ::  +di-groups-scry does not allow me
    ::  to properly adjust for a possible
    ::  group.
    ::
    ++  groups
      .^  groups:g
        %gx
        /(scot %p our.bowl)/groups/(scot %da now.bowl)/groups/noun
      ==
    --
  --
++  watch
  |=  =(pole knot)
  ^+  cor
  ?+    pole  ~|(bad-watch-path/pole !!)
      [%briefs ~]  ?>(from-self cor)
      [%ui ~]      ?>(from-self cor)
    ::
      [%epic ~]    (give %fact ~ epic+!>(okay))
    ::
      [%diary ship=@ name=@ rest=*]
    =/  =ship  (slav %p ship.pole)
    di-abet:(di-watch:(di-abed:di-core ship name.pole) rest.pole)
    ::
      [%said host=@ name=@ %note time=@ ~]
    =/  host=ship   (slav %p host.pole)
    =/  =flag:d     [host name.pole]
    =/  =time       (slav %ud time.pole)
    (watch-said flag time)
  ==
::
++  watch-said
  |=  [=flag:d =time]
  ?.  (~(has by shelf) flag)
    (proxy-said flag time)
  di-abet:(di-said:(di-abed:di-core flag) time)
++  said-wire
  |=  [=flag:d =time]
  ^-  wire
  /said/(scot %p p.flag)/[q.flag]/note/(scot %ud time)
::
++  take-said
  |=  [=flag:d =time =sign:agent:gall]
  ^+  cor
  ?+    -.sign  !!
      %watch-ack
    %.  cor
    ?~  p.sign  same
    (slog leaf/"Preview failed" u.p.sign)
  ::
      %kick
    ?:  (~(has by voc) [flag time])
      cor  :: subscription ended politely
    (proxy-said flag time)
  ::
      %fact
    =.  cor
      (give %fact ~[(said-wire flag time)] cage.sign)
    ?+    p.cage.sign  ~|(funny-mark/p.cage.sign !!)
        %diary-said
      =+  !<(=said:d q.cage.sign)
      =.  voc  (~(put by voc) [flag time] `said)
      cor
    ::
        %diary-denied
      =.  voc  (~(put by voc) [flag time] ~)
      cor
    ==
  ==
::
++  proxy-said
  |=  [=flag:d =time]
  =/  =dock  [p.flag dap.bowl]
  =/  wire  (said-wire flag time)
  =/  =card  [%pass wire %agent dock %watch wire]
  (emit card)
::
++  agent
  |=  [=(pole knot) =sign:agent:gall]
  ^+  cor
  ?+    pole  ~|(bad-agent-wire/pole !!)
      ~  cor
  ::
      [%epic ~]  (take-epic sign)
  ::
      [%hark ~]
    ?>  ?=(%poke-ack -.sign)
    ?~  p.sign  cor
    %-  (slog leaf/"Failed to hark" u.p.sign)
    cor
  ::
      [%diary ship=@ name=@ rest=*]
    =/  =ship  (slav %p ship.pole)
    di-abet:(di-agent:(di-abed:di-core ship name.pole) rest.pole sign)
  ::
      [%said host=@ name=@ %note time=@ ~]
    =/  host=ship   (slav %p host.pole)
    =/  =flag:d     [host name.pole]
    =/  id=time     (slav %ud time.pole)
    (take-said flag id sign)
  ::
      [%groups ~]
    ?+    -.sign  !!
      %kick  watch-groups
    ::
        %watch-ack
      ?~  p.sign
       (give %fact ~ epic+!>(okay))
      =/  =tank
        leaf/"Failed groups subscription in {<dap.bowl>}, unexpected"
      ((slog tank u.p.sign) cor)
    ::
        %fact
      ?.  =(%group-action-0 p.cage.sign)  cor
      (take-groups !<(=action:g q.cage.sign))
    ==
  ==
++  take-groups
  |=  =action:g
  =/  affected=(list flag:d)
    %+  murn  ~(tap by shelf)
    |=  [=flag:d =diary:d]
    ?.  =(p.action group.perm.diary)  ~
    `flag
  ?+    q.q.action  cor
      [%fleet * %del ~]
    ~&  'revoke perms for'
    %+  roll  affected
    |=  [=flag:d co=_cor]
    ^+  cor
    %+  roll  ~(tap in p.q.q.action)
    |=  [=ship ci=_cor]
    ^+  cor
    =/  di  (di-abed:di-core:ci flag)
    di-abet:(di-revoke:di ship)
  ::
      [%fleet * %del-sects *]
    ~&  'recheck permissions'
    %+  roll  affected
    |=  [=flag:d co=_cor]
    =/  di  (di-abed:di-core:co flag)
    di-abet:di-recheck:di
  ::
      [%channel * %del-sects *]
    ~&  'recheck permissions'
    %+  roll  affected
    |=  [=flag:d co=_cor]
    =/  di  (di-abed:di-core:co flag)
    di-abet:di-recheck:di
  ==
::
++  arvo
  |=  [=wire sign=sign-arvo]
  ^+  cor
  ~&  arvo/wire
  cor
++  peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  [~ ~]
  ::
    [%x %shelf ~]  ``shelf+!>(shelf)
  ::
      [%x %diary @ @ *]
    =/  =ship  (slav %p i.t.t.path)
    =*  name   i.t.t.t.path
    (di-peek:(di-abed:di-core ship name) t.t.t.t.path)
    ::
      [%x %briefs ~]
    =-  ``diary-briefs+!>(-)
    ^-  briefs:d
    %-  ~(gas by *briefs:d)
    %+  turn  ~(tap in ~(key by shelf))
    |=  =flag:d
    :-  flag
    di-brief:(di-abed:di-core flag)
  ==
::
++  give-brief
  |=  [=flag:d =brief:briefs:d]
  (give %fact ~[/briefs] diary-brief-update+!>([flag brief]))
::
++  pass-hark
  |=  [all=? desk=? =yarn:ha]
  ^-  card
  =/  =wire  /hark
  =/  =dock  [our.bowl %hark]
  =/  =cage  hark-action+!>([%add-yarn all desk yarn])
  [%pass wire %agent dock %poke cage]
++  spin
  |=  [=rope:ha con=(list content:ha) wer=path but=(unit button:ha)]
  ^-  yarn:ha
  =/  id  (end [7 1] (shax eny.bowl))
  [id rope now.bowl con wer but]
++  from-self  =(our src):bowl
++  di-core
  |_  [=flag:d =diary:d gone=_|]
  +*  di-notes  ~(. not notes.diary)
  ++  di-core  .
  ::  TODO: archive??
  ++  di-abet  
    %_  cor
        shelf  
      ?:(gone (~(del by shelf) flag) (~(put by shelf) flag diary))
    ==
  ++  di-abed
    |=  f=flag:d
    di-core(flag f, diary (~(got by shelf) f))
  ++  di-area  `path`/diary/(scot %p p.flag)/[q.flag]
  ++  di-spin
    |=  [rest=path con=(list content:ha) but=(unit button:ha)]
    =*  group  group.perm.diary
    =/  =nest:g  [dap.bowl flag]
    =/  rope  [`group `nest q.byk.bowl (welp /(scot %p p.flag)/[q.flag] rest)]
    =/  link  
      (welp /groups/(scot %p p.group)/[q.group]/channels/diary/(scot %p p.flag)/[q.flag] rest)
    (spin rope con link but)
  ::
  ++  di-said
    |=  =time
    |^  ^+  di-core
    ?.  (di-can-read src.bowl)
      (give-kick diary-denied+!>(~))
    =/  [* =note:d]  (got:di-notes time)
    =/  =outline:d  (trace:di-notes note)
    %+  give-kick  %diary-said
    !>  ^-  said:d
    [flag outline]
    ++  give-kick
      |=  =cage
      =.  cor  (give %fact ~ cage)
      =.  cor  (give %kick ~ ~)
      di-core
    --
  ::
  ++  di-upgrade
    ^+  di-core
    ?.  ?=(%sub -.net.diary)
      di-core
    ?.  ?=(%dex -.saga.net.diary)
      di-core
    ?.  =(okay ver.saga.net.diary)
      ~&  future-shock/[ver.saga.net.diary flag]
      di-core
    =>  .(saga.net.diary `saga:e`saga.net.diary)
    di-make-chi
  ::
  ++  di-make-lev
    ?.  ?=(%sub -.net.diary)
      di-core
    =.  saga.net.diary  lev/~
    =.  cor  (watch-epic p.flag)
    di-core
  ::
  ++  di-make-chi
    ?.  ?=(%sub -.net.diary)
      di-core
    =.  saga.net.diary  chi/~
    di-safe-sub
  ::
  ++  di-safe-sub
    ?:  (~(has by wex.bowl) [(snoc di-area %updates) p.flag dap.bowl])
      di-core
    di-sub
  ::
  ++  di-watch
    |=  =path
    ^+  di-core
    ?+    path  !!
      [%updates *]    (di-pub t.path)
      [%ui ~]         ?>(from-self di-core)
      [%ui %notes ~]  ?>(from-self di-core)
    ::
    ==
  ++  di-pass
    |%
    ++  add-channel
      |=  req=create:d
      =/  =dock      [p.group.req %groups]
      =/  =nest:g    [dap.bowl flag]
      =/  =channel:g  
        =,(req [[title description '' ''] now.bowl %default | readers])
      =/  =action:g  [group.req now.bowl %channel nest %add channel]
      =/  =cage      group-action-0+!>(action)
      =/  =wire      (snoc di-area %create)
      =/  =card
        [%pass di-area %agent dock %poke cage]
      =.  cor
        (emit card)
      di-core
    --
  ++  di-init
    |=  req=create:d
    =/  =perm:d  [writers.req group.req]
    =.  cor
      (give-brief flag di-brief)
    =.  di-core  (di-update now.bowl %create perm)
    (add-channel:di-pass req)
  ::
  ++  di-agent
    |=  [=wire =sign:agent:gall]
    ^+  di-core
    ?+  wire  !!
        ~  :: noop wire, should only send pokes
      di-core
    ::
        [%updates ~]
      (di-take-update sign)
    ::
        [%create ~]
      ?>  ?=(%poke-ack -.sign)
      %.  di-core  :: TODO rollback creation if poke fails?
      ?~  p.sign  same
      (slog leaf/"poke failed" u.p.sign)
    ==
  ::
  ++  di-brief  (brief:di-notes our.bowl last-read.remark.diary)
  ::
  ++  di-peek
    |=  =(pole knot)
    ^-  (unit (unit cage))
    ?+  pole  [~ ~]
        [%notes rest=*]  (peek:di-notes rest.pole)
        [%perm ~]        ``diary-perm+!>(perm.diary)
    ==
  ::
  ++  di-revoke
    |=  her=ship
    %+  roll  ~(tap in di-subscriptions)
    |=  [[=ship =path] he=_di-core]
    ?.  =(ship her)  he
    he(cor (emit %give %kick ~[path] `ship))
  ::
  ++  di-recheck
    %+  roll  ~(tap in di-subscriptions)
    |=  [[=ship =path] di=_di-core]
    ?:  (di-can-read:di ship)  di
    di(cor (emit %give %kick ~[path] `ship))
  ::
  ++  di-take-epic
    |=  her=epic:e
    ^+  di-core
    ?>  ?=(%sub -.net.diary)
    ?:  =(her okay)
      di-core
    ?:  (gth her okay)
      =.  saga.net.diary  dex+her
      di-core
    di-make-lev
 ::
 ++  di-take-update
    |=  =sign:agent:gall
    ^+  di-core
    ?+    -.sign  di-core
        %kick
      ?>  ?=(%sub -.net.diary)
      ?:  =(%chi -.saga.net.diary)  di-sub
      di-core
    ::
        %watch-ack
      =.  net.diary  [%sub src.bowl & [%chi ~]]
      ?~  p.sign  di-core
      %-  (slog leaf/"Failed subscription" u.p.sign)
      =.  gone  &
      di-core
    ::
        %fact
      =*  cage  cage.sign 
      ?+  p.cage  (di-odd-update p.cage)
        %epic                             (di-take-epic !<(epic:e q.cage))
        ?(%diary-logs %diary-logs-0)      (di-apply-logs !<(log:d q.cage))
        ?(%diary-update %diary-update-0)  (di-update !<(update:d q.cage))
      ==
    ==
  ::
  ++  di-odd-update
    |=  =mark
    ?.  (is-old:epos mark)
      di-core
    ?.  ?=(%sub -.net.diary)
      di-core
    di-make-lev
  ::
  ++  di-proxy
    |=  =update:d
    ^+  di-core
    ?>  di-can-write
    =/  =dock  [p.flag dap.bowl]
    =/  =cage  [act:mar !>([flag update])]
    =.  cor
      (emit %pass di-area %agent dock %poke cage)
    di-core
  ::
  ++  di-groups-scry
    =*  group  group.perm.diary
    /(scot %p our.bowl)/groups/(scot %da now.bowl)/groups/(scot %p p.group)/[q.group]
  ::
  ++  di-can-write
    ?:  =(p.flag src.bowl)  &
    =/  =path
      %+  welp  di-groups-scry
      /fleet/(scot %p src.bowl)/vessel/noun
    =+  .^(=vessel:fleet:g %gx path)
    ?:  =(~ writers.perm.diary)  &
    !=(~ (~(int in writers.perm.diary) sects.vessel))
  ::
  ++  di-can-read
    |=  her=ship
    =/  =path
      %+  welp  di-groups-scry
      /channel/[dap.bowl]/(scot %p p.flag)/[q.flag]/can-read/(scot %p her)/loob
    .^(? %gx path)
  ::
  ++  di-pub
    |=  =path
    ^+  di-core
    ?>  (di-can-read src.bowl)
    =/  =log:d
      ?~  path  log.diary
      =/  =time  (slav %da i.path)
      (lot:log-on:d log.diary `time ~)
    =/  =cage  diary-logs+!>(log)
    =.  cor  (give %fact ~ cage)
    di-core
  ::
  ++  di-sub
    ^+  di-core
    =/  tim=(unit time)
      (bind (ram:log-on:d log.diary) head)
    =/  base=wire  (snoc di-area %updates)
    =/  =path 
      %+  weld  base
      ?~  tim  ~
      /(scot %da u.tim)
    =/  =card
      [%pass base %agent [p.flag dap.bowl] %watch path]
    =.  cor  (emit card)
    di-core
  ++  di-join
    |=  f=flag:d
    ^+  di-core
    =.  shelf  (~(put by shelf) f *diary:d)
    =.  di-core  (di-abed f)
    =.  cor  (give-brief flag di-brief)
    di-sub
  ::
  ++  di-leave
    =/  =dock  [p.flag dap.bowl]
    =/  =wire  (snoc di-area %updates)
    =.  cor  (emit %pass wire %agent dock %leave ~)
    =.  cor  (emit %give %fact ~[/briefs] diary-leave+!>(flag))
    =.  gone  &
    di-core
  ::
  ++  di-apply-logs
    |=  =log:d
    ^+  di-core
    =/  updates=(list update:d)
      (tap:log-on:d log)
    %+  roll  updates
    |=  [=update:d di=_di-core]
    (di-update:di update)
  ::
  ++  di-subscriptions
    %+  roll  ~(val by sup.bowl)
    |=  [[=ship =path] out=(set [ship path])]
    ?.  =((scag 4 path) (snoc di-area %updates))
      out
    (~(put in out) [ship path])
  ::
  ++  di-give-updates
    |=  [=time d=diff:d]
    ^+  di-core
    =/  paths=(set path)
      %-  ~(gas in *(set path))
      (turn ~(tap in di-subscriptions) tail)
    =.  paths  (~(put in paths) (snoc di-area %ui))
    =.  cor  (give %fact ~[/ui] act:mar !>([flag [time d]]))
    =/  cag=cage  [upd:mar !>([time d])]
    =.  cor
      (give %fact ~(tap in paths) cag)
    di-core
  ::
  ++  di-remark-diff
    |=  diff=remark-diff:d
    ^+  di-core
    =.  cor
      (give %fact ~[(snoc di-area %ui)] diary-remark-action+!>([flag diff]))
    =.  remark.diary
      ?-  -.diff
        %watch    remark.diary(watching &)
        %unwatch  remark.diary(watching |)
        %read-at  !!
      ::
          %read
      =/  [=time =note:d]  (need (ram:on:notes:d notes.diary))
      remark.diary(last-read `@da`(add time 1))  ::  greater than last
      ==
    =.  cor
      (give-brief flag di-brief)
    di-core
  ::
  ++  di-update
    |=  [=time dif=diff:d]
    ?>  di-can-write
    ^+  di-core
    =.  log.diary
      (put:log-on:d log.diary time dif)
    =.  di-core
      (di-give-updates time dif)
    ?-    -.dif
        %notes
      =.  notes.diary  (reduce:di-notes time p.dif)
      =.  cor  (give-brief flag di-brief)
      =/  cons=(list (list content:ha))
        (hark:di-notes our.bowl p.dif)
      =.  cor
        %-  emil
        %+  turn  cons
        |=  cs=(list content:ha)
        (pass-hark & & (di-spin /note/(rsh 4 (scot %ui p.p.dif)) cs ~))
      di-core
    ::
        %add-sects
      =*  p  perm.diary
      =.  writers.p  (~(uni in writers.p) p.dif)
      di-core
    ::
        %del-sects
      =*  p  perm.diary
      =.  writers.p  (~(dif in writers.p) p.dif)
      di-core
    ::
        %create
      =.  perm.diary  p.dif
      di-core
    ::
        %sort
      =.  sort.diary  p.dif
      di-core
    ::
        %view
      =.  view.diary  p.dif
      di-core
    ==
  --
--
