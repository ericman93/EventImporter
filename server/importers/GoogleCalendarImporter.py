from CalendarImporter import CalendarImporter
from apiclient import discovery
from oauth2client import client
import httplib2
import datetime
from flask import session

class GoogleCalendarImporter(CalendarImporter):
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

