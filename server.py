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
        #print(host_id, subject, location, start_time, end_time)

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

@app.route("/get_session_data", methods=['GET']) 
def get_session_data():
    if request.method == 'GET':
        session_id = request.args.get('session_id')
        
        conn = pymysql.connect(**config1)
        
        with conn.cursor() as cursor:
            query_session_data = "SELECT * FROM sessions WHERE id = %s"
            cursor.execute(query_session_data, session_id)
            session_data = cursor.fetchone()
            
            if session_data:
                return jsonify(session_data), 200
            else:
                return jsonify(f"Session with id: {session_id} not found."), 404
    return jsonify({"error": "Method not allowed"}), 405

@app.route("/get_user_data", methods=['GET'])
def get_user_data():
    if request.method == 'GET':
        user_id = request.args.get('user_id')
        
        conn = pymysql.connect(**config1)
        
        with conn.cursor() as cursor:
            query_user_data = "SELECT username, university, first_name, last_name, email, phone, coins, bio, avatar FROM users WHERE id = %s"
            cursor.execute(query_user_data, user_id)
            user_data = cursor.fetchone()
            
            if user_data:
                query_avatars = "SELECT a.* FROM avatar a INNER JOIN users_avatars ua ON a.id = ua.avatar_id INNER JOIN users u WHERE u.id = %s"
                cursor.execute(query_avatars, user_id)
                avatars_data = cursor.fetchall()
                # Adding avatars data to the user_data dictionary
                user_data['avatars'] = [avatar[0] for avatar in avatars_data]

                return jsonify(user_data), 200
            else:
                return jsonify(f"User with id: {user_id} not found."), 404
    return jsonify({"error": "Method not allowed"}), 405

@app.route("/get_session_details", methods=['GET']) 
def get_session_details():
    if request.method == 'GET':
        session_id = request.args.get('session_id')
        
        conn = pymysql.connect(**config1)
        
        with conn.cursor() as cursor:
            query_session_data = """SELECT 
                                    s.*,
                                    u_host.username AS host_username,
                                    u_host.university AS host_university,
                                    u_host.email AS host_email,
                                    u_host.first_name AS host_first_name,
                                    u_host.last_name AS host_last_name,
                                    u_host.phone AS host_phone,
                                    u_host.coins AS host_coins,
                                    u_host.bio AS host_bio,
                                    u_member1.username AS member1_username,
                                    u_member1.university AS member1_university,
                                    u_member1.email AS member1_email,
                                    u_member1.first_name AS member1_first_name,
                                    u_member1.last_name AS member1_last_name,
                                    u_member1.phone AS member1_phone,
                                    u_member1.coins AS member1_coins,
                                    u_member1.bio AS member1_bio,
                                    u_member2.username AS member2_username,
                                    u_member2.university AS member2_university,
                                    u_member2.email AS member2_email,
                                    u_member2.first_name AS member2_first_name,
                                    u_member2.last_name AS member2_last_name,
                                    u_member2.phone AS member2_phone,
                                    u_member2.coins AS member2_coins,
                                    u_member2.bio AS member2_bio,
                                    u_member3.username AS member3_username,
                                    u_member3.university AS member3_university,
                                    u_member3.email AS member3_email,
                                    u_member3.first_name AS member3_first_name,
                                    u_member3.last_name AS member3_last_name,
                                    u_member3.phone AS member3_phone,
                                    u_member3.coins AS member3_coins,
                                    u_member3.bio AS member3_bio,
                                    u_member4.username AS member4_username,
                                    u_member4.university AS member4_university,
                                    u_member4.email AS member4_email,
                                    u_member4.first_name AS member4_first_name,
                                    u_member4.last_name AS member4_last_name,
                                    u_member4.phone AS member4_phone,
                                    u_member4.coins AS member4_coins,
                                    u_member4.bio AS member4_bio
                                FROM sessions s
                                LEFT JOIN users u_host ON s.host_id = u_host.id
                                LEFT JOIN users u_member1 ON s.member1_id = u_member1.id
                                LEFT JOIN users u_member2 ON s.member2_id = u_member2.id
                                LEFT JOIN users u_member3 ON s.member3_id = u_member3.id
                                LEFT JOIN users u_member4 ON s.member4_id = u_member4.id
                                WHERE s.id = %s;
                                """
            cursor.execute(query_session_data, session_id)
            session_data = cursor.fetchone()
            
            if session_data:
                return jsonify(session_data), 200
            else:
                return jsonify(f"Session with id: {session_id} not found."), 404
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
                return jsonify({"message": "User is already a member of this session", "session_id": session_id}), 203
            if session_details['max_members'] > session_details['current_members']:
                current_members = session_details['current_members']
                if None in members:
                    # Find first available slot and add the user
                    index = members.index(None) + 1
                    current_members += 1
                    query_update_member = f"UPDATE sessions SET member{index}_id = %s ,current_members = %s WHERE id = %s"
                    cursor.execute(query_update_member, (member_id,current_members, session_id))
                    conn.commit()
                    return jsonify({"message": f"Joined session successfully as member {index}", "session_id": session_id}), 200
                else:
                    return jsonify({"message": "Session is full", "session_id": session_id}), 201
            elif session_details['max_members'] == session_details['current_members']:
                return jsonify({"message": "Session is full", "session_id": session_id}), 202

    return jsonify({"error": "Method not allowed"}), 405


@app.route("/get_all_sessions", methods=['POST'])
def get_all_sessions():
    if request.method == 'POST':
        data = request.get_json()
        subject = data.get('subject')
        location = data.get('location')
        start_time_str = data.get('start_time')
        end_time_str = data.get('end_time')

        conn = pymysql.connect(**config1)
        query_session_data = "SELECT * FROM sessions WHERE 1=1"
        parameters = []

        if subject:
            query_session_data += " AND subject = %s"
            parameters.append(subject)
        if location:
            query_session_data += " AND location = %s"
            parameters.append(location)

        current_time = datetime.now()

        if start_time_str:
            start_time = datetime.strptime(start_time_str, "%Y-%m-%dT%H:%M:%S.%f")
            if start_time >= current_time:
                query_session_data += " AND start_time = %s"
                parameters.append(start_time)
        if end_time_str:
            end_time = datetime.strptime(end_time_str, "%Y-%m-%dT%H:%M:%S.%f")
            if end_time >= current_time:
                query_session_data += " AND end_time = %s"
                parameters.append(end_time)

        with conn.cursor() as cursor:
            cursor.execute(query_session_data, tuple(parameters))
            session_data = cursor.fetchall()

            if session_data:
                return jsonify(session_data), 200
            else:
                return jsonify({"message": "No sessions found."}), 404

    return jsonify({"error": "Method not allowed"}), 405





if __name__ == "__main__":
    app.run(debug=True)

