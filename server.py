from flask import Flask, request, jsonify, json, session
import pymysql
import secrets
#from flask_socketio import SocketIO
from datetime import datetime

# Details about base
config1 = {
    "user": "root",
    "password": "2255",
    "host": "localhost",
    "database": "SwM",
    "charset": "utf8mb4",
    "cursorclass": pymysql.cursors.DictCursor,
}

config = {
    "user": "root",
    "password": "2403",
    "host": "localhost",
    "database": "swm",
    "charset": "utf8mb4",
    "cursorclass": pymysql.cursors.DictCursor,
}

app = Flask(__name__)
# we use keys in order to store the user's data in sessions.
app.secret_key = secrets.token_hex(24)
#socketio = SocketIO(app)

@app.route("/login", methods=['POST'])
def login():
    if request.method == 'POST':
        data = request.get_json() 

        username = data.get('username')
        password = data.get('password')

        conn = pymysql.connect(**config1) # connection with the database

        with conn.cursor() as cursor:
            query = "SELECT * FROM users WHERE username = %s AND password = %s"
            cursor.execute(query, (username, password))
            user = cursor.fetchone()

            if user:
                return jsonify(user)
            else:
                return jsonify({"error": "Invalid credentials"}), 401  # Unauthorized

    return jsonify({"error": "Method not allowed"}), 405  # Method not allowed


@app.route("/signup", methods = ['GET','POST'])
def signup():
    data = request.get_json()  # Assuming data is sent as JSON in the request body

    # Extract data from JSON payload
    username = data.get('username')
    password = data.get('password')
    university = data.get('university')
    email = data.get('email')
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    phone = data.get('phone')
    
    conn = pymysql.connect(**config1) 

    with conn.cursor() as cursor:
        query = "INSERT INTO users(username,password,university,email,first_name,last_name,phone) VALUES(%s,%s,%s,%s,%s,%s,%s)"
        cursor.execute(query, (username,password,university,email,first_name,last_name,phone))
        conn.commit()

        # If cursor.rowcount is greater than 0, it means that some rows were affected by the INSERT statement.
        if cursor.rowcount > 0:
            return jsonify({"message" : "User registered successfully"})
        else:
            return jsonify({"message" : "User could not be registered"})


@app.route("/create_session", methods=['POST'])
def create_session():
    if request.method == 'POST':
        data = request.get_json()

        host_id = data.get('host_id')
        subject = data.get('subject')
        location = data.get('location')
        start_time = data.get('start_time')
        end_time = data.get('end_time')
        max_members=  data.get('max_members')
        print(host_id, subject, location, start_time, end_time)
        # Formatting received date-time strings to match MySQL DATETIME format
        #formatted_start_time = datetime.strptime(start_time, '%Y-%m-%dT%H:%M:%S.%f').strftime('%Y-%m-%d %H:%M:%S')
        #formatted_end_time = datetime.strptime(end_time, '%Y-%m-%dT%H:%M:%S.%f').strftime('%Y-%m-%d %H:%M:%S')
        print(host_id, subject, location, start_time, end_time)

        if not all([host_id, subject, location, start_time, end_time]):
            print(host_id, subject, location, start_time, end_time)
            return jsonify({"error": "Incomplete data"}), 400  # Bad Request

        conn = pymysql.connect(**config1)

        with conn.cursor() as cursor:
            query = "INSERT INTO sessions(host_id, subject, location, start_time, end_time, max_members) VALUES (%s, %s, %s, %s, %s, %s)"
            cursor.execute(query, (host_id, subject, location, start_time, end_time, max_members))
            conn.commit()

            if cursor.rowcount > 0:
                session_id = cursor.lastrowid
                return jsonify({"message": "Session created successfully", "session_id": session_id})
            else:
                return jsonify({"message": "Session creation failed"}), 500  # Server Error

    return jsonify({"error": "Method not allowed"}), 405


@app.route("/join_session", methods=['POST'])
def join_session():
    if request.method == 'POST':
        data = request.get_json()

        session_id = data.get('session_id')
        member_id = data.get('member_id')  # Assuming the ID of the user joining

        conn = pymysql.connect(**config1)

        with conn.cursor() as cursor:
            # Get session details and count current members
            query_count_members = "SELECT member1_id, member2_id, member3_id, member4_id, max_members, current_members FROM sessions WHERE id = %s"
            cursor.execute(query_count_members, session_id)
            session_details = cursor.fetchone()

            members = [session_details[f'member{i}_id'] for i in range(1, 5)]
            if member_id in members:
                return jsonify({"message": "User is already a member of this session", "session_id": session_id})
            if session_details['max_members'] > session_details['current_members']:
                current_members = session_details['current_members']
                if None in members:
                    # Find first available slot and add the user
                    index = members.index(None) + 1
                    current_members += 1
                    query_update_member = f"UPDATE sessions SET member{index}_id = %s ,current_members = %s WHERE id = %s"
                    cursor.execute(query_update_member, (member_id,current_members, session_id))
                    conn.commit()
                    return jsonify({"message": f"Joined session successfully as member {index}", "session_id": session_id})
                else:
                    return jsonify({"message": "Session is full", "session_id": session_id})
            elif session_details['max_members'] == session_details['current_members']:
                return jsonify({"message": "Session is full", "session_id": session_id})

    return jsonify({"error": "Method not allowed"}), 405



if __name__ == "__main__":
    app.run(debug=True)

