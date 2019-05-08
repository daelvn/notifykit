local NotificationService, showNotification, finalizeService
do
  local _obj_0 = require("notifykit")
  NotificationService, showNotification, finalizeService = _obj_0.NotificationService, _obj_0.showNotification, _obj_0.finalizeService
end
local parseNotification, compileNotification
do
  local _obj_0 = require("notifykit.file")
  parseNotification, compileNotification = _obj_0.parseNotification, _obj_0.compileNotification
end
local HOME = os.getenv("HOME") or "/root"
local NOTIFYKIT_DIR = (os.getenv("NOTIFYKIT_DIR")) or tostring(HOME) .. "/.local/share/notifykit"
NOTIFYKIT_DIR = NOTIFYKIT_DIR .. "/"
local fileExists
fileExists = function(file)
  do
    local f = io.open(file, "r")
    if f then
      f:close()
      return true
    end
  end
  return false
end
local argl = {
  ...
}
if #argl < 1 then
  print("notifykit-run <notification>")
  print("notifykit-run requires arguments.")
  return os.exit()
else
  local notif = argl[1]
  if not (fileExists(NOTIFYKIT_DIR .. notif .. ".notif.txt")) then
    error("File " .. tostring(NOTIFYKIT_DIR) .. tostring(notif) .. ".notif.txt not found.")
  end
  local contents
  do
    local _with_0 = io.open(NOTIFYKIT_DIR .. notif .. ".notif.txt", r)
    contents = _with_0:read("*a")
    _with_0:close()
  end
  NotificationService(notif)
  return showNotification(compileNotification(parseNotification(contents)))
end
