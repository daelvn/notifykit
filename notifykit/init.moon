--> # notifykit
--> Lua notification helper library.
-- By daelvn
-- 08.05.2019
lgi  = require "lgi"

--> Start the notif lib
Notify = lgi.Notify

--> # NotificationService
--> Initializes lgi.Notify
NotificationService = (serviceName="notifykit") -> Notify.init serviceName

--> ## isServiceInitialized
--> Checks if a notification service is initialized.
isServiceInitialized = -> Notify.is_initted!

--> ## serviceName
--> Returns the service name.
serviceName = -> Notify.get_app_name service

--> ## setServiceName
--> Sets the service name.
setServiceName = (name) -> Notify.set_app_name name

--> ## finalizeService
--> Finalizes the notification service.
finalizeService = -> Notify.uninit service if isServiceInitialized service

--> # NativeNotification
--> Creates a new lgi.Notify notification. [Icon
--> list.](https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html)
NativeNotification = (summary="notifykit", body="", icon="dialog-information") -> Notify.Notification.new summary, body, icon

--> ## NOTIFY_EXPIRES_DEFAULT
--> Default expiration time on a notification.
NOTIFY_EXPIRES_DEFAULT = -1

--> ## NOTIFY_EXPIRES_NEVER
--> The notification never expires.
NOTIFY_EXPIRES_NEVER = 0

--> ## showNativeNotification
--> Tells the service to display a notification.
showNativeNotification = (notification) -> Notify.Notification.show notification

--> ## setTimeout
--> Sets the timeout for a notification. Pass [NOTIFY_EXPIRES_DEFAULT](#NOTIFY_EXPIRES_DEFAULT) for the default
--> expiration time and [NOTIFY_EXPIRES_NEVER](#NOTIFY_EXPIRES_NEVER) for it to never expire. The timeout may be ignored
--> by the server.
setTimeout = (notification, timeout) -> Notify.Notification.set_timeout notification, timeout

--> ## setCategory
--> Sets the category of this notification. This can be used by the notification server to filter or display the data in a certain way.
setCategory = (notification, category) -> Notify.Notification.set_category notification, category

--> ## NOTIFY_URGENCY_LOW
NOTIFY_URGENCY_LOW = 0

--> ## NOTIFY_URGENCY_NORMAL
NOTIFY_URGENCY_NORMAL = 1

--> ## NOTIFY_URGENCY_CRITICAL
NOTIFY_URGENCY_CRITICAL = 2

--> ## setUrgency
--> Sets the urgency level of this notification.
setUrgency = (notification, urgency) -> Notify.Notification.set_urgency notification, urgency

--> ## closeNativeNotification
--> Closes a notification.
closeNativeNotification = (notification) -> Notify.Notification.close notification

--> # Notification
--> Creates a new Lua notification, designed for easier handling.
Notification = (
    summary="notifykit",
    body="",
    icon="dialog-information",
    timeout=NOTIFY_EXPIRES_DEFAULT,
    urgency=NOTIFY_URGENCY_NORMAL,
    category="notifykit"
  ) ->
    { :summary, :body, :icon, :timeout, :urgency, :category }

--> ## group
--> Groups several Notifications into a single one. Operating on this table will modify the notifications at display
--> time.
group = (...) ->
  notifl = {...}
  {
    summary:  "NOMODIFY"
    body:     "NOMODIFY"
    icon:     "NOMODIFY"
    timeout:  "NOMODIFY"
    urgency:  "NOMODIFY"
    category: "NOMODIFY"
    _group:   true
    _notifl:  notifl
  }

--> ## unpackGroup
--> Returns all the notifications in a group, modifying them if the parameters in the group were modified.
unpackGroup = (gr) ->
  if gr.summary  != "NOMODIFY"
    for notif in *gr._notifl do notif.summary  = gr.summary
  if gr.body     != "NOMODIFY"
    for notif in *gr._notifl do notif.body     = gr.body
  if gr.icon     != "NOMODIFY"
    for notif in *gr._notifl do notif.icon     = gr.icon
  if gr.timeout  != "NOMODIFY"
    for notif in *gr._notifl do notif.timeout  = gr.timeout
  if gr.urgency  != "NOMODIFY"
    for notif in *gr._notifl do notif.urgency  = gr.urgency
  if gr.category != "NOMODIFY"
    for notif in *gr._notifl do notif.category = gr.category
  gr._notifl

--> ## unpackGroupRaw
--> Returns all the notifications in a group as they were passed.
unpackGroupRaw = (gr) -> gr._notifl

--> ## showGroup
--> Converts a group of Notifications into NativeNotifications and tells the service to display them.
--> You should use [showNotification](#showNotification) instead, this is specifically for groups.
showGroup = (gr) ->
  error "The argument passed to showGroup is not a group" unless gr._group
  unpacked = unpackGroup gr
  native   = [NativeNotification notif.summary, notif.body, notif.icon for notif in unpacked]
  for i, notif in ipairs native
    setCategory notif, unpacked[i].category
    setTimeout  notif, unpacked[i].timeout
    setUrgency  notif, unpacked[i].urgency
    --
    showNativeNotification notif

--> ## showNotification
--> Converts the Notification into a NativeNotification and tells the service to display it.
showNotification = (notification) ->
  if notification._group
    showGroup notification
  else
    native = NativeNotification notification.summary, notification.body, notification.icon
    setCategory native, notification.category or "notifykit"
    setTimeout  native, notification.timeout  or NOTIFY_EXPIRES_DEFAULT
    setUrgency  native, notification.urgency  or NOTIFY_URGENCY_NORMAL
    --
    showNativeNotification  native

{
  :NotificationService, :isServiceInitialized, :serviceName, :setServiceName, :finalizeService
  :NativeNotification,  :showNativeNotification, :closeNativeNotification, :setTimeout, :setUrgency, :setCategory
  :NOTIFY_URGENCY_LOW, :NOTIFY_URGENCY_NORMAL, :NOTIFY_URGENCY_CRITICAL
  :NOTIFY_EXPIRES_DEFAULT, :NOTIFY_EXPIRES_NEVER
  :Notification, :group, :unpackGroup, :unpackGroupRaw, :showGroup, :showNotification
}
