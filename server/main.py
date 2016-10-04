from flask import Flask, jsonify
from flask import jsonify
from flask.ext.cors import CORS

#from database import db_session
#from database import init_db
#init_db()

app = Flask("scheddy")
app.secret_key = 'super secret key'

#app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqldb://root:Password1@localhost/aquaman'
#db = SQLAlchemy(app)

from controllers.userController import users_api
from controllers.oauth2callbacksController import oauth_api
from controllers.importersController import importers_api
app.register_blueprint(users_api)
app.register_blueprint(oauth_api)
app.register_blueprint(importers_api)

CORS(app)
'''
@app.teardown_request
def shutdown_session(exception=None):
    db_session.remove()
'''
app.run(debug=True)	
