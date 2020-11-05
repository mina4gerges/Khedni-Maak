from flask import Flask, request, jsonify
import mysql.connector
from mysql.connector import Error
from dataBase import host, user, dbname, password

# run flask app:
# set FLASK_APP=app
# flask run

app = Flask(__name__)


def get_final_data(obj):
    final_array = []
    for x in obj:
        each_screen_obj = {'id': x[0], 'title': x[1], 'body': x[2], 'image': x[3], 'imagePath': x[4]}
        final_array.append(each_screen_obj)
    return final_array


@app.route('/screens', methods=['POST', 'GET'])
def data():
    global conn, cursor

    try:
        conn = mysql.connector.connect(host=host,
                                       database=dbname,
                                       user=user,
                                       password=password)
        if conn.is_connected():
            cursor = conn.cursor()

            if request.method == 'POST':
                params = request.json

                title = params.get('intro_title')
                desc = params.get('intro_desc')
                image = params.get('intro_image')
                intro_image_path = params.get('intro_image_path')

                query = (
                    "INSERT INTO screens (intro_title, intro_desc, intro_image, intro_image_path) "
                    "VALUES (%s, %s, %s, %s)"
                )

                data = (title, desc, image, intro_image_path)

                cursor.execute(query, data)
                conn.commit()

                return "success"

            if request.method == 'GET':
                query = "SELECT * FROM screens;"

                cursor.execute(query)
                rows = cursor.fetchall()
                conn.commit()
                return jsonify(get_final_data(rows))

    except Error as e:
        return 'error occurred', e
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()
            print("MySQL connection is closed")


@app.route('/screen/<string:id>', methods=['GET', 'DELETE', 'PUT'])
def onedata(id):
    global conn, cursor

    try:
        conn = mysql.connector.connect(host=host,
                                       database=dbname,
                                       user=user,
                                       password=password)
        if conn.is_connected():
            cursor = conn.cursor()

            if request.method == 'GET':
                query = (
                    "SELECT * FROM screens WHERE intro_id = %s "
                )

                data = id

                cursor.execute(query, data)
                rows = cursor.fetchall()
                return str(rows)

            if request.method == 'DELETE':
                query = "DELETE FROM screens WHERE intro_id = %s;"

                cursor.execute(query, id)
                conn.commit()
                return "deleted"

            if request.method == 'PUT':
                params = request.json

                title = params.get('intro_title')
                desc = params.get('intro_desc')
                image = params.get('intro_image')
                image_path = params.get('intro_image_path')

                query = "UPDATE screens SET intro_title = %s,intro_desc =%s,intro_image=%s,image_path=%s WHERE intro_id = %s;"

                cursor.execute(query, (title, desc, image, id, image_path))
                conn.commit()
                return "updated"

    except Error as e:
        return 'error occurred', e
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()
            print("MySQL connection is closed")


if __name__ == '__main__':
    app.run(debug=True)
