from flask import Flask, jsonify
from pymongo import MongoClient



mongolab_uri = "mongodb://test:test@ds035046.mlab.com:35046/schedy"

client = MongoClient(mongolab_uri)
db = client.get_default_database()
app = Flask(__name__)

@app.route('/todo/api/v1.0/tasks', methods=['GET'])
def get_tasks():
	return jsonify({'tasks': tasks})

@app.route('/todo/api/v1.0/business/<int:business_id>', methods=['GET'])
def get_task(business_id):
	customer_temp_list = []
	events_temp_list = []
	cursor = db.test1_events.find({"business_id": str(business_id)})
	for document in cursor:
		events_temp_list.append([document["start"],document["end"]])
	return jsonify({'events': events_temp_list})

if __name__ == '__main__':
	app.run(debug=True)