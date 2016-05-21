from flask import Blueprint, request, jsonify
from oauth2client import client
from model.user import User
from database import db_session
	
users_api = Blueprint('users_controller', __name__, url_prefix='/user')

@users_api.route('/<int:user_id>', methods=['GET'])
def getUser(user_id):
	return "user id: " + str(user_id)

@users_api.route('/', methods=['POST'])
def signIn():
	data = request.get_json()
	provider_user = {}
	if(data["provider"] == "google"):
		provider_user = client.verify_id_token(data['id'], '1058234090303-derenhna8oi3h32bf47j77rqtrfalrcd.apps.googleusercontent.com')
		user = User(name="<name>", provider="google", provider_id=provider_user['sub'])

	create_user_if_needed(user)
	
	return jsonify(provider_user)

@users_api.route('/', methods=['GET'])
def getUsers():
	return "list of users"

def create_user_if_needed(user):
	if(user.is_exsits() == False):
		db_session.add(user)
		db_session.commit()
