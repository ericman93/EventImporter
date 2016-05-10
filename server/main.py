from flask import Flask, jsonify
from flask import jsonify

from importers.CalendarImporter import CalendarImporter
from importers.GoogleCalendarImporter import GoogleCalendarImporter

from controllers.userController import users_api
from controllers.oauth2callbacksController import oauth_api

app = Flask("scheddy")
app.secret_key = 'super secret key'

app.register_blueprint(users_api)
app.register_blueprint(oauth_api)

@app.route('/test')
def test():
	importer = GoogleCalendarImporter()
	res = importer.getEvents({})
	
	return jsonify(res)

app.run(debug=True)	