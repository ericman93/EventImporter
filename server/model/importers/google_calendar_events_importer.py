from sqlalchemy import Column, Integer, String, func, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from database import Base, db_session
from apiclient import discovery
from oauth2client import client
import httplib2
import datetime
from model.importers.events_importer import EventsImporter

class GoogleCalendarEventsImporter(EventsImporter):
	__tablename__ = 'gmail_event_importer'

	id = Column(Integer, ForeignKey('events_importer.id'), primary_key=True)
	refresh_token = Column(String)
	token = Column(String)
	toekn_expiration_date = Column(DateTime)

	def getEventsFromServer(self, user):
		# get google credentials from user
		credentials = client.OAuth2Credentials.from_json(session['credentials'])

		http_auth = credentials.authorize(httplib2.Http())
		calendar_service = discovery.build('calendar', 'v3', http_auth)
		
		now = datetime.datetime.utcnow().isoformat() + 'Z' # 'Z' indicates UTC time
		events = calendar_service.events().list(calendarId='primary', timeMin=now, maxResults=10, singleEvents=True, orderBy='startTime').execute()

		return events

	def parseEventsToModel(self, events):
		return events

	__mapper_args__ = {
        'polymorphic_identity':'gmail_event_importer',
    }