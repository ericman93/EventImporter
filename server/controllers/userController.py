from flask import Blueprint, request

users_api = Blueprint('users_controller', __name__, url_prefix='/user')

@users_api.route('/<int:user_id>', methods=['GET'])
def getUser(user_id):
	return "user id: " + str(user_id)

@users_api.route('/', methods=['POST'])
def signIn():
	return request.data

@users_api.route('/', methods=['GET'])
def getUsers():
	return "list of users"