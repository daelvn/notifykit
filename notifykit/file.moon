--> # notifykit
--> Lua notification helper library.
-- By daelvn
-- 08.05.2019
import Notification, group from require "notifykit"

--> # notifykit.file
--> Parses .notif.txt files.

--> ## Syntax
--> NotifyKit's .notif.txt syntax is column-based. So as long as everything is separated with spaces, you're fine.
--> Lines starting with ; are ignored (comments). If there's more than one notification definition in the file, it will
--> be loaded as a notification group. To live an empty space, use `/`.
--> ### Urgency
--> Urgency can be defined with a number (0-2) or with a word (low, normal, critical).
--> ### Timeout
--> Timeout only allows numbers, except for "default" (-1) or "never" (0).
--> ```
--> ; NotifyKit .notif.txt file
--> ;URGENCY  TIMEOUT  CATEGORY  ICON                  SUMMARY    BODY
--> normal    never    notifykit dialog-information    notifykit  This is the body for your notification!
--> 1         0        ntkit     /                     ntkit      body
--> ```
--> This syntax allows for notifications being defined just as:
--> ```
--> 0 0 notifykit dialog-information   notifykit Notification Body!
--> ```

--> # split
split = (sep, plain=false) -> (str, max) ->
  assert sep != ''
  assert (max == nil) or (max >= 1)
  res = {}
  if str\len! > 0
    max         or= -1
    field, start  = 1, 1
    first, last   = str\find sep, start, plain
    while first and max != 0
      res[field]  = str\sub start, first-1
      field      += 1
      start       = last + 1
      first, last = str\find sep, start, plain
      max        -= 1
    res[field]    = str\sub start
  res
splitSpaces = split " +"

--> # lines
--> [Thanks stackoverflow](https://stackoverflow.com/a/19329565).
lines = (text) ->
  if (text\sub -1) != "\n" then text ..= "\n"
  return text\gmatch "(.-)\n"

--> # parseNotification
--> Parses the .notif.txt format.
parseNotification = (text) ->
  helper = (line) ->
    fields = splitSpaces line
    toBody = table.concat [word for i, word in ipairs fields when i > 6], " "

    { urgency, timeout, category, icon, summary, body } = splitSpaces line
    --
    body ..= " " .. toBody
    --
    sl = (x) -> x == "/"
    urgency  = "1"                  if sl urgency
    timeout  = "-1"                 if sl timeout
    category = "notifykit"          if sl category
    icon     = "dialog-information" if sl icon
    summary  = "notifykit"          if sl summary
    body     = ""                   if sl body
    --
    switch urgency
      when "low"      then urgency = "0"
      when "normal"   then urgency = "1"
      when "critical" then urgency = "2"
    switch timeout
      when "default"  then timeout = "-1"
      when "never"    then timeout = "0"
    --
    urgency = tonumber urgency
    timeout = tonumber timeout
    --
    return { :urgency, :timeout, :category, :icon, :summary, :body }
  notifl = [helper line for line in lines text when not line\match "^;"]
  if #notifl < 1
    error "Invalid file."
  notifl

--> # compileNotification
--> Returns a Notification or group of Notifications.
compileNotification = (notifl) ->
  notifl = [Notification n.summary, n.body, n.icon, n.timeout, n.urgency, n.category for n in *notifl]
  if #notifl == 1
    return notifl[1]
  else
    unpack or= table.unpack
    return group unpack notifl

{ :parseNotification, :compileNotification }
