class CalendarImporter(object):
	def getEvents(self, user):
		serverEvents = self.getEventsFromServer(user)
		return self.parseEventsToModel(serverEvents)

	def getEventsFromServer(self, user):
		return NotImplemented

	def parseEventsToModel(self, events):
		return NotImplemented

