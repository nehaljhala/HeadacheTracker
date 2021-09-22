Overview
--------
The Headache Tracker is an app that records headaches and migraines. When the user experiences a headache, they can record the duration and specific time and date of the headaches. Then the app will factor in details about the user's environment, such as the temperature, the ultra-violet index, the humidity, and the wind speed. Over a period of time, the user will form a database full of tracked headaches, which they can use to analyse the conditions in which their headaches occur the most.
 

How it works?
-------------
The new user need to signUp first with details such as username, height, age etc. These details would be than saved in coredata/database. The user needs to login to record headache.
Once the user logs in, the first view appears with a "start" button. The button records the current headache and behind the scenes will go and fetch the weather details of the current location. The app than further calculates the average of each factor, along with duration . The app saves the duration when the user presses "stop" button. The user can check the saved data in both UIView and TableView format. Thus provides both detailed and average analysis based on the data fetched. The app displays the location of the headache on a map.


Benefits
---------
- Keeps a record of headaches with the start time, the date and the duration of the headache
- Analyses environmental conditions
- Can be used as a database for doctors to analyse the patient's headaches
- User-friendly
- Gives average about the factors impacting headaches


Design
---------
Modules descriptions:
LoginView Module - allows the returning user to login to the app.
Signup View Module- asks a new user to sign up with few details like age, height, weight etc.
HeadacheTracker Module - records beginning and end of a headache/migraine. The button displayed in this view show the average degree of temperature, UVIndex, humidity, windspeed and duration during the headache or the average of all the headaches occured. 
TableView Module - displays the recorded headaches with start time and date.
DetailView Module - Displays the temperature, UVIndex, windspeed and humidity parameters of a particular headache selected by the user by tapping the detail view icon of tableview Module
Client Module - makes the networking call.
Persistence Module - saves and fetches data in and from the persistence container.

Future plans
-------------
The future plan is to add the aqi details, the elevation, the BMI, and the age of the user to further analyze the headaches. 
The user can share the data with a medical professional.

How to build the app
---------------------
Building Headache Tracker was interesting and challenging. It has multiple views, and each view is different from the other. Navigation Controller makes it easy to navigate between the views. Navigation buttons such as "done", "back" and "loggout" on the top of each views helps the app to navigate through the views. Both storyboard and programmatic segue present the views. The Login and Sign up views are build mainly of UILabels and UITextfields, with different keyboard settings and picker controller settings. Different font size and font colors are used through the app with the help of NSMutableAttributes.
The Headache Tracker and Detail View displays labels and buttons with the help of stackview. With MKMapkit a mapview presents the location of the user. Location Manager fetches the latitude and longitude coordinates.
Table View delegate and datasource functions display the recorded data in detail. A user friendly "detail icon" displays in each cell.
Persistence controller saves the data in xcdatamodel. 
Different functions and methods present the text in the labels. Math calculations calculate the duration of time and the average of the weather factors. Alerts are shown in case of unexpected errors. 

Requirement
------------
Swift 5
Xcode 12
iOS version 



