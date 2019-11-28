# README

Hi there!

This is a tool prepared to recieve CSV files with the following structure

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

This app was coded in RoR Trying to make the least ammount of querys as possible.

It has one model Devices

the instance variables you'll get to see are the following.
id, device_serial_number, device_type, device_status

Class and Instance Methods.

Class Methods ----

Create_records -
Handle creation of records in this case "Device records", to be saved to the Database

Popular_devices -
This is in charge of recieving a list of devise id's already in order of popularity from a specific date. The problem, is that the method responsible to get the popular IDs, returns a hash only with the ID of the device and the count. This is due to the way Active Record handles the .count method on an Active Record instance, and once it gets sorted, it becomes an array. So popular devices is in charge of keeping the order of this array and replacing each id with a Device instance corresponding to this ID WITHOUT! making any querys to the database.

Top_occurrances -
Top Ocurrances queries the database for a specific date and returns an array of arrays, each childs' first item correspond to the ID of the Device, and the second the ammount of times it was prompted.

Sort_prev_occurrances_to_occurrences -
This method takes two arrays of device_id - count pairs. The function of this method is to have the two arrays with their IDs in the same index as the other. So if we had a1 = [[aa,4], [ab,7], [ac,2]] and b1 = [[ac,2], [aa,1], [ab,3]], it will change  b2 to align its id's to a1. So this method would return b1 = [[aa,1], [ab,3], [ac,2]]

Get_device_and_status -
This method takes care of asking the database for Devices of a certain type and status who where active on a specific date. It will list them and ordered them according to their timestamp.


Instance Mehods ------

Dif_percentage -
Takes to Integers and calculates how much percentagge difference there is between the first number given, and the second.

--------------

On the Controller part, there is also only one with the following actions.

Index -
Prepares or all the information that is going to be used on the home page ("/")

Proces_csv -
Takes care of the csv handling to create instances of devises that are going to be used later on.

Devise_history -
Similar to index where it prepares information to be used in the Devise_history view


----------
Private methods
-----------

Group by day -
It filters an array of device instances, and groups them by a certain date, and it counts it.

Fill_missing_pairs -
When you get all the popular devices, and you look for the corresponding entries a week a go. Some times, a certain device was not triggered the week before, so this method just fills an extra ghost entry with the value of cero to the devise entry that wasn't there.

Authenticate_user_key -
This method takes charge of identifying the user and the key for when there is a CSV upload file

Device_params -
When working with forms, I don't want harmfull users passing information through the form that can leave my Database vulnerable. Therefore this method takes charge of only permiting certain information input.




