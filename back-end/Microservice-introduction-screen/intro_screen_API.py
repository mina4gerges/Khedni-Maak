import json
# pip install flask
from flask import Flask, request, jsonify
# pip install Flask-JSON
from flask_json import json_response, as_json, JsonError
# pip install mysql-connector-python
import mysql.connector
from mysql.connector import Error
from db_data import host, user, dbname, password

app = Flask(__name__)


def get_final_data(obj):
    final_array = []
    for x in obj:
        each_screen_obj = {'id': x[0], 'title': x[1], 'body': x[2], 'image': x[3]}
        final_array.append(each_screen_obj)
    return final_array


@app.route('/', methods=['GET'])
# @as_json
def data():
    global conn, cursor

    try:
        conn = mysql.connector.connect(host=host,
                                       database=dbname,
                                       user=user,
                                       password=password)
        if conn.is_connected():
            cursor = conn.cursor()

            if request.method == 'GET':
                query = "SELECT * FROM screens;"

                cursor.execute(query)
                rows = cursor.fetchall()
                conn.commit()
                # return jsonify(get_final_data(rows)),
                # return get_final_data(rows) used with @as_json (import from flask_json)
                return json_response(status_=200, data_=json.dumps(get_final_data(rows)))
        else:
            # return 'MYSql not connected', 400
            return JsonError(status_=400, description='MYSql not connected')

    except Error as e:
        # return 'error occurred', e
        return JsonError(status_=5000, description=e)

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()
            print("MySQL connection is closed")


if __name__ == '__main__':
    app.run(debug=True)
