import firebase_admin  # type: ignore
from firebase_admin import credentials, firestore  # type: ignore
from datetime import datetime
from langchain_core.tools import tool
import os

# Global variable to track if Firebase is already initialized
firebase_initialized = False
db = None

def initialize_firebase():
    global firebase_initialized, db
    if not firebase_initialized:
        # Try the first path first, then the second path
        try:
            try:
                cred = credentials.Certificate('wellcarebot-71cca-firebase-adminsdk-v1v74-74fce68f5b.json')
                firebase_admin.initialize_app(cred)
                db = firestore.client()
                firebase_initialized = True
                print("Firebase initialized successfully with the first path.")
                return
            except Exception as e:
                print(f"Error initializing Firebase with the first path: {e}")
            
            try:
                cred = credentials.Certificate('Backend/wellcarebot-71cca-firebase-adminsdk-v1v74-74fce68f5b.json')
                firebase_admin.initialize_app(cred)
                db = firestore.client()
                firebase_initialized = True
                print("Firebase initialized successfully with the second path.")
                return
            except Exception as e:
                print(f"Error initializing Firebase with the second path: {e}")
        except Exception as e:
            print(f"Error initializing Firebase with the second path: {e}")

        # If initialization fails, try the second path first, then the first path
        try:
            try:
                cred = credentials.Certificate('Backend/wellcarebot-71cca-firebase-adminsdk-v1v74-74fce68f5b.json')
                firebase_admin.initialize_app(cred)
                db = firestore.client()
                firebase_initialized = True
                print("Firebase initialized successfully with the second path.")
                return
            except Exception as e:
                print(f"Error initializing Firebase with the second path: {e}")
            
            try:
                cred = credentials.Certificate('wellcarebot-71cca-firebase-adminsdk-v1v74-74fce68f5b.json')
                firebase_admin.initialize_app(cred)
                db = firestore.client()
                firebase_initialized = True
                print("Firebase initialized successfully with the first path.")
                return
            except Exception as e:
                print(f"Error initializing Firebase with the first path: {e}")

        except Exception as e:
            print(f"Error initializing Firebase: {e}")


def get_all_therapists(*args, **kwargs):
    try:
        # Initialize Firebase
        initialize_firebase()
        therapists_ref = db.collection('therapists')
        docs = therapists_ref.stream()
        
        therapists = []
        for doc in docs:
            therapist_data = doc.to_dict()
            therapist_data['id'] = doc.id
            therapists.append(therapist_data)
        
        return therapists
    except Exception as e:
        print(f"Error: {e}")
        return []

def get_therapist_by_name(therapist_name):
    initialize_firebase()
    therapists_ref = db.collection('therapists')
    query = therapists_ref.where('name', '==', therapist_name)
    results = query.stream()
    
    for doc in results:
        therapist_data = doc.to_dict()
        therapist_data['id'] = doc.id  # Include the document ID if needed
        return therapist_data
    
    return None

def get_user_by_email(email):
    initialize_firebase()
    users_ref = db.collection('users')
    query = users_ref.where('email', '==', email).limit(1)
    results = query.stream()

    for doc in results:
        print(f"User found: {doc.id}")
        return doc.id, doc.to_dict()

    print("User not found")
    return None, None

def is_slot_available(therapist_data, appointment_datetime):
    initialize_firebase()
    day_name = appointment_datetime.strftime('%A')
    appointment_time = appointment_datetime.time()
    
    availability_list = therapist_data.get('availability', [])
    
    print(f"Checking availability for {day_name} at {appointment_time}")
    print(f"Therapist availability: {availability_list}")
    
    for period in availability_list:
        print(f"Checking period: {period}")
        if day_name in period:
            time_range = period.split(' ', 1)[1]  # Extract time range (e.g., "9:00 AM - 1:00 PM")
            start_time_str, end_time_str = time_range.split(' - ')
            start_time = datetime.strptime(start_time_str.strip(), '%I:%M %p').time()
            end_time = datetime.strptime(end_time_str.strip(), '%I:%M %p').time()

            if start_time <= appointment_time <= end_time:
                print(f"Slot available: {start_time} - {end_time}")
                return True

    return False

# Function to create a booking
@tool
def create_booking_tool(therapist_name: str, user_email: str, appointment_date: str) -> str:
    """
    Create a booking for the user with the specified therapist and appointment date.
    
    Args:
        therapist_name: The full name of the chosen therapist.
        user_email: The email address of the user.
        appointment_date: The chosen appointment date and time in ISO format (YYYY-MM-DDTHH:MM:SS).
    
    Returns:
        A string indicating whether the booking was created successfully or if there was an error.
    """
    initialize_firebase()
    therapist_data = get_therapist_by_name(therapist_name)
    if not therapist_data:
        return "Therapist not found"
    
    user_id, user_data = get_user_by_email(user_email)
    if not user_id:
        return "User not found"

    try:
        appointment_datetime = datetime.fromisoformat(appointment_date)
        print(f"Parsed appointment_date: {appointment_datetime}")
    except ValueError:
        return "Invalid date format. Please use YYYY-MM-DDTHH:MM:SS"

    if not is_slot_available(therapist_data, appointment_datetime):
        return "Slot not available"

    year = appointment_datetime.year
    month = appointment_datetime.month
    day = appointment_datetime.day
    time = appointment_datetime.time().isoformat()

    booking_data = {
        'user_id': user_id,
        'user_name': user_data['fullName'],
        'user_email': user_data['email'],
        'user_phone': user_data['phoneNumber'],
        'user_profile_picture_url': user_data['profilePictureURL'],
        'therapist_id': therapist_data['id'],
        'appointment_date': appointment_date,
        'year': year,
        'month': month,
        'day': day,
        'time': time,
        'status': 'confirmed',
        'notes': ''
    }
    # Add booking to the 'bookings' collection
    booking_ref = db.collection('bookings').add(booking_data)[1]  # Extracting the DocumentReference from the tuple
    print(f"Booking created successfully. Booking ID: {booking_ref.id}")
    return f"Booking created successfully. Booking ID: {booking_ref.id}"

@tool
def get_user_by_email_tool(email: str) -> dict:
    """
    Retrieve user details from the database based on the provided email address.
    
    Args:
        email: The email address of the user.
    
    Returns:
        A dictionary containing the user details if the user is found, or None if the user is not found.
    """
    initialize_firebase()
    user_id, user_data = get_user_by_email(email)
    if user_id:
        user_data['id'] = user_id
        return user_data
    return None


@tool
def get_all_therapists_tool() -> list:
    """
    Retrieve a list of all therapists from the database.
    
    Returns:
        A list of dictionaries containing the details of all therapists.
    """
    return get_all_therapists()


@tool
def get_therapist_by_name_tool(therapist_name: str) -> dict:
    """
    Retrieve the details of a therapist based on the provided name.
    
    Args:
        therapist_name: The full name of the therapist.
    
    Returns:
        A dictionary containing the details of the therapist if found, or None if the therapist is not found.
    """
    return get_therapist_by_name(therapist_name)