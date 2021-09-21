Overview
--------
The Headache Tracker is an app that records headaches and migraines. When the user experiences a headache, they can record the duration and specific time and date of the headaches. Then the app will factor in details about the user's environment, such as the temperature, the ultra-violet index, the humidity, and the wind speed. Over a period of time, the user will form a database full of tracked headaches, which they can use to analyse the conditions in which their headaches occur the most.
 

How it works?
-------------
Once the user is logged in, he can use the app to record the time of headache.
The app tracks the location of the user and fetches the weather details of the place during the time of headache.
It then provides both detailed and average analysis based on the data fetched. 
It also records the duration of headache.


Benefits
---------
- Keeps a record of headaches
- Analyses environmental conditions
- Can be used as a database for doctors to analyse the patient's headaches
- User-friendly
- Gives average about the factors impacting headaches


Design
---------
Modules descriptions:
LoginView Module - allows the returning user to login to the app.
Signup View Module- asks a new user to sign up with few details like age, height, weight etc.

HeadacheTracker Module - calculates the data to an average. It also records headaches.
DetailView Module - displays the factors causing headaches.
Client Module - makes the networking call.
Persistence Module - saves and fetches data in and from the persistence container.

Future plans
-------------
The future plan is to add the aqi details, the elevation, the sex, the BMI, and the age of the user to further analyze the headaches. 