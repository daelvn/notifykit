local lgi = require("lgi")
local Notify = lgi.Notify
local NotificationService
NotificationService = function(serviceName)
  if serviceName == nil then
    serviceName = "notifykit"
  end
  return Notify.init(serviceName)
end
local isServiceInitialized
isServiceInitialized = function()
  return Notify.is_initted()
end
local serviceName
serviceName = function()
  return Notify.get_app_name(service)
end
local setServiceName
setServiceName = function(name)
  return Notify.set_app_name(name)
end
local finalizeService
finalizeService = function()
  if isServiceInitialized(service) then
    return Notify.uninit(service)
  end
end
local NativeNotification
NativeNotification = function(summary, body, icon)
  if summary == nil then
    summary = "notifykit"
  end
  if body == nil then
    body = ""
  end
  if icon == nil then
    icon = "dialog-information"
  end
  return Notify.Notification.new(summary, body, icon)
end
local NOTIFY_EXPIRES_DEFAULT = -1
local NOTIFY_EXPIRES_NEVER = 0
local showNativeNotification
showNativeNotification = function(notification)
  return Notify.Notification.show(notification)
end
local setTimeout
setTimeout = function(notification, timeout)
  return Notify.Notification.set_timeout(notification, timeout)
end
local setCategory
setCategory = function(notification, category)
  return Notify.Notification.set_category(notification, category)
end
local NOTIFY_URGENCY_LOW = 0
local NOTIFY_URGENCY_NORMAL = 1
local NOTIFY_URGENCY_CRITICAL = 2
local setUrgency
setUrgency = function(notification, urgency)
  return Notify.Notification.set_urgency(notification, urgency)
end
local closeNativeNotification
closeNativeNotification = function(notification)
  return Notify.Notification.close(notification)
end
local Notification
Notification = function(summary, body, icon, timeout, urgency, category)
  if summary == nil then
    summary = "notifykit"
  end
  if body == nil then
    body = ""
  end
  if icon == nil then
    icon = "dialog-information"
  end
  if timeout == nil then
    timeout = NOTIFY_EXPIRES_DEFAULT
  end
  if urgency == nil then
    urgency = NOTIFY_URGENCY_NORMAL
  end
  if category == nil then
    category = "notifykit"
  end
  return {
    summary = summary,
    body = body,
    icon = icon,
    timeout = timeout,
    urgency = urgency,
    category = category
  }
end
local group
group = function(...)
  local notifl = {
    ...
  }
  return {
    summary = "NOMODIFY",
    body = "NOMODIFY",
    icon = "NOMODIFY",
    timeout = "NOMODIFY",
    urgency = "NOMODIFY",
    category = "NOMODIFY",
    _group = true,
    _notifl = notifl
  }
end
local unpackGroup
unpackGroup = function(gr)
  if gr.summary ~= "NOMODIFY" then
    local _list_0 = gr._notifl
    for _index_0 = 1, #_list_0 do
      local notif = _list_0[_index_0]
      notif.summary = gr.summary
    end
  end
  if gr.body ~= "NOMODIFY" then
    local _list_0 = gr._notifl
    for _index_0 = 1, #_list_0 do
      local notif = _list_0[_index_0]
      notif.body = gr.body
    end
  end
  if gr.icon ~= "NOMODIFY" then
    local _list_0 = gr._notifl
    for _index_0 = 1, #_list_0 do
      local notif = _list_0[_index_0]
      notif.icon = gr.icon
    end
  end
  if gr.timeout ~= "NOMODIFY" then
    local _list_0 = gr._notifl
    for _index_0 = 1, #_list_0 do
      local notif = _list_0[_index_0]
      notif.timeout = gr.timeout
    end
  end
  if gr.urgency ~= "NOMODIFY" then
    local _list_0 = gr._notifl
    for _index_0 = 1, #_list_0 do
      local notif = _list_0[_index_0]
      notif.urgency = gr.urgency
    end
  end
  if gr.category ~= "NOMODIFY" then
    local _list_0 = gr._notifl
    for _index_0 = 1, #_list_0 do
      local notif = _list_0[_index_0]
      notif.category = gr.category
    end
  end
  return gr._notifl
end
local unpackGroupRaw
unpackGroupRaw = function(gr)
  return gr._notifl
end
local showGroup
showGroup = function(gr)
  if not (gr._group) then
    error("The argument passed to showGroup is not a group")
  end
  local unpacked = unpackGroup(gr)
  local native
  do
    local _accum_0 = { }
    local _len_0 = 1
    for notif in unpacked do
      _accum_0[_len_0] = NativeNotification(notif.summary, notif.body, notif.icon)
      _len_0 = _len_0 + 1
    end
    native = _accum_0
  end
  for i, notif in ipairs(native) do
    setCategory(notif, unpacked[i].category)
    setTimeout(notif, unpacked[i].timeout)
    setUrgency(notif, unpacked[i].urgency)
    showNativeNotification(notif)
  end
end
local showNotification
showNotification = function(notification)
  if notification._group then
    return showGroup(notification)
  else
    local native = NativeNotification(notification.summary, notification.body, notification.icon)
    setCategory(native, notification.category or "notifykit")
    setTimeout(native, notification.timeout or NOTIFY_EXPIRES_DEFAULT)
    setUrgency(native, notification.urgency or NOTIFY_URGENCY_NORMAL)
    return showNativeNotification(native)
  end
end
return {
  NotificationService = NotificationService,
  isServiceInitialized = isServiceInitialized,
  serviceName = serviceName,
  setServiceName = setServiceName,
  finalizeService = finalizeService,
  NativeNotification = NativeNotification,
  showNativeNotification = showNativeNotification,
  closeNativeNotification = closeNativeNotification,
  setTimeout = setTimeout,
  setUrgency = setUrgency,
  setCategory = setCategory,
  NOTIFY_URGENCY_LOW = NOTIFY_URGENCY_LOW,
  NOTIFY_URGENCY_NORMAL = NOTIFY_URGENCY_NORMAL,
  NOTIFY_URGENCY_CRITICAL = NOTIFY_URGENCY_CRITICAL,
  NOTIFY_EXPIRES_DEFAULT = NOTIFY_EXPIRES_DEFAULT,
  NOTIFY_EXPIRES_NEVER = NOTIFY_EXPIRES_NEVER,
  Notification = Notification,
  group = group,
  unpackGroup = unpackGroup,
  unpackGroupRaw = unpackGroupRaw,
  showGroup = showGroup,
  showNotification = showNotification
}
