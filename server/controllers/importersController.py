from flask import Blueprint, request, jsonify
from oauth2client import client
from model.user import User
from database import db_session
	
from model.importers.google_calendar_events_importer import GoogleCalendarEventsImporter

importers_api = Blueprint('importers_controller', __name__, url_prefix='/importer')

@importers_api.route('/', methods=['GET'])
def get_self_importers():
	return jsonify({
		'importers': ['Google']
	});

@importers_api.route('/google', methods=['POST'])
def create_google_importer():
	return jsonify({
		'res' : 'hi'
	})