from flask import Flask, render_template, make_response, jsonify
import awsgi

application = Flask(__name__)

@application.route('/')
def home():
    return render_template('index.html')

@application.route('/healthcheck')
def healthcheck():
    return make_response(jsonify({"Message": "healthy"}), 200)

def handler(event, context):
    return awsgi.response(application, event, context)

if __name__ == '__main__':
    application.run(debug=False)