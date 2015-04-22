connection {
	jdbcStr = "jdbc:mysql://127.0.0.1:3306/kaboom"
	user = "kaboom"
	pwd = "kaboom"
}
notegenerator {
       pretend = false
}
bus {
    maxQueueLength = 10
    urlQueueName = "urlQueue"
    notifyQueueName = "notifyQueue"
    persistQueueName = "persistQueue"
    purgeNotify = true
    purgePersist = true
    purgeUrlsPost = true
    purgeNotificationPost = false
    purgePersistPost = true
    updateWorkerPeriod = 60
}
 
