from sqlalchemy import Column, Integer, String, func, ForeignKey
from sqlalchemy.orm import relationship
from database import Base, db_session

class EventsImporter(Base):
	__tablename__ = 'events_importer'

	id = Column(Integer, primary_key=True, autoincrement=True)
	type = Column(String)
	user_id = Column(Integer, ForeignKey('users.id'))
	user = relationship("User", back_populates="events_importers")

	__mapper_args__ = {
        'polymorphic_identity':'events_importer',
        'polymorphic_on': type
    }

	def getEvents(self, user):
		serverEvents = self.getEventsFromServer(user)
		return self.parseEventsToModel(serverEvents)

	def getEventsFromServer(self, user):
		return NotImplemented

	def parseEventsToModel(self, events):
		return NotImplemented

from model.importers.google_calendar_events_importer import GoogleCalendarEventsImporter	