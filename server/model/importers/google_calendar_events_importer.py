from sqlalchemy import Column, Integer, String, func, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from database import Base, db_session
from model.importers.events_importer import EventsImporter

class GoogleCalendarEventsImporter(EventsImporter):
	__tablename__ = 'gmail_event_importer'

	id = Column(Integer, ForeignKey('events_importer.id'), primary_key=True)
	refresh_token = Column(String)
	token = Column(String)
	toekn_expiration_date = Column(DateTime)

	__mapper_args__ = {
        'polymorphic_identity':'gmail_event_importer',
    }