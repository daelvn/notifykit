--> # notifykit
--> Lua notification helper library.
-- By daelvn
-- 08.05.2019
import NotificationService, showNotification, finalizeService from require "notifykit"
import parseNotification, compileNotification                 from require "notifykit.file"

--> # notifykit-run
--> Executable to run notifications from a certain folder.

HOME            = os.getenv"HOME" or "/root"
NOTIFYKIT_DIR   = (os.getenv"NOTIFYKIT_DIR") or "#{HOME}/.local/share/notifykit"
NOTIFYKIT_DIR ..= "/"

--> # fileExists
--> Checks whether a file exists.
--> https://stackoverflow.com/a/4991602
fileExists = (file) ->
  if f = io.open file, "r"
    f\close!
    return true
  false

-- CLI
argl = {...}
if #argl < 1
  print "notifykit-run <notification>"
  print "notifykit-run requires arguments."
  os.exit!
else
  notif = argl[1]
  error "File #{NOTIFYKIT_DIR}#{notif}.notif.txt not found." unless fileExists NOTIFYKIT_DIR .. notif .. ".notif.txt"
  local contents
  with io.open NOTIFYKIT_DIR..notif..".notif.txt", r
    contents = \read "*a"
    \close!
  --
  NotificationService notif
  showNotification compileNotification parseNotification contents
