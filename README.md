# README

This is a tool prepared to recieve uploaded CSV files with the following structure

timestamp,id,type,status

2009-12-01T06:59:22Z,1q2w3e4r,sensor,online

2009-12-01T06:59:22Z,1q2w3e4r,gateway,offline

the first columns as you can see are the headers and the rest is information
corresponding to those headers
.

In order for you to upload a CSV file you have reach the following endpoint.

``POST``  /upload

--Headers

{Content-Type: application/json}

--Body

{

    X_Upload_File: Your file object,

    X_User_Email: "The mail you signed up with",

    X_User_Token: "The token assigned yo your account once you register"

}

If you still havn't registered, you can go to '/' and click on sign-up.
As soon as you are logged in, you will see your security token in the top left
corner of the screen.

In there you can select a date to see the most popular devices on the selected date
and If you click the history button, It will take you to another page where you
can see the history of the past 30 days (according to your input) in which all
of devices of the type and status specified were active.

-----------

This app was coded in RoR

---
Models
---

User -
I decided to create this model to implement key recognition and authentication when uploading a CSV file.


Device --
This is the main model. The instance variables assigned to Device are the following: @timestamp, @device_serial_unmber, @device_type, @status.

---
Class and Instance methods
---

Self.get_devices -
this metheod returns an array with the following format [[device_serial_number, number_of_times_for_a_specific_day]]. This array is sorted from most pormted in a day to least.

Self.get_types -
Very similiar to get_devices in the sense that queries the database and organices the result. In this case get types recieves a day a type and a status, and it returns the count of the ammount of devices with those setings that were promted on a selected day.

Find_percentage-
This method finds the amount of times that a device was prompted 7 days before the passed day and calls calculate_percentage.

Calculate_percentage-
takes two numbers and compares the growth in percentage between them

---
Controllers
---


DevicesController
---


Actions--

Index-
This method prepares the information that is going to be transmited to the home page view.

Device_history-
Same purpose as index.

Prces_csv-
This method handles the creation of Devices instances once the end point taking care of the CSV file upload gets called.

Get_all_days-
get all days is incharge of returning an array of arrays with the following format [[count, date]...] making reference to a type of deive with a specific status.

Authenticate_user_key -
Is in charge of authenticating a user uploading a file

Device_params --
Safeguards my app from malicious imput from harmfull users in the forms.







