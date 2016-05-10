from flask import url_for, session, redirect, request, Blueprint, jsonify
from oauth2client import client
from apiclient import discovery
import httplib2
import os

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

oauth_api = Blueprint('oauth_controller', __name__, url_prefix='/oauth')

@oauth_api.route('/google/<action>')
def getGoogleCalendarRequest(action):
    if 'credentials' not in session:
        return redirect(url_for('oauth_controller.google'+action.title()+'Callback'))

    credentials = client.OAuth2Credentials.from_json(session['credentials'])
    
    if credentials.access_token_expired:
        return redirect(url_for('oauth_controller.google'+action.title()+'Callback'))
    else:
        return session['credentials'] #jsonify(events)

@oauth_api.route('/googleCallback')
def googleLoginCallback():
    flow = client.flow_from_clientsecrets(
        APP_ROOT+'\client_id.json',
        scope='https://www.googleapis.com/auth/plus.login',
        redirect_uri=url_for('oauth_controller.googleCalendarCallback', _external=True))

    if 'code' not in request.args:
        auth_uri = flow.step1_get_authorize_url()
        return redirect(auth_uri)
    else:
        auth_code = request.args.get('code')
        credentials = flow.step2_exchange(auth_code)
        
        http_auth = credentials.authorize(httplib2.Http())
        calendar_service = discovery.build('plus', 'v1', http_auth)
        user = calendar_service.people().list(userId='me', collection='visible').execute()
        return jsonify(user)

@oauth_api.route('/googleCallback')
def googleCalendarCallback():
    flow = client.flow_from_clientsecrets(
        APP_ROOT+'\client_id.json',
        scope='https://www.googleapis.com/auth/calendar.readonly',
        redirect_uri=url_for('oauth_controller.googleCalendarCallback', _external=True))

    if 'code' not in request.args:
        auth_uri = flow.step1_get_authorize_url()
        return redirect(auth_uri)
    else:
        auth_code = request.args.get('code')
        credentials = flow.step2_exchange(auth_code)
        session['credentials'] = credentials.to_json()
        
        # Save user credentials in the DB
        # refresh token = credentials["refresh_token"]

        return redirect(url_for('oauth_controller.getGoogleCalendarRequest'))