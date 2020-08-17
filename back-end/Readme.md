**Khedni-Maak Screens**

1) Login / Sign-up
2) Home
3) Driver Screen
4) Passenger Screen
5) All available drivers
6) All passengers requests
7) All drivers offer
8) Profile
9) Settings

**Login :**

_Inputs:_
- username (input)
- password (input)
- login (button)

_Functions:_
- get/set username
- get/set password
- toString
- login(username, password)

**Sign-up**

1) First Option : Create new profile
    
    _Inputs:_
    - name (input)
    - lastName (input)
    - userName (input)
    - password (input)
    - phoneNumber (input)
    - email (input)
    - sex (male/female) (radio)
    - birthday (inputMask)
    - image (image)
    - signUp (button)
    
2) Second Option : Using Facebook or Google

    _Inputs:_
    - Facebook or google logins
    
_Functions:_
- get/set name
- get/set lastName
- get/set userName
- get/set password
- get/set phoneNumber
- get/set email
- get/set sex
- get/set birthday
- get/set image
- toString
- signUp(name, lastName, userName, password, phoneNumber, email, sex, birthday, image)

**Home**

_Inputs:_
- userType (passenger or driver) (list)

_Functions:_
- get/set userType
- toString

**Driver Screen**

_Inputs:_
- fromLocation (droDown)
- toLocation (dropDown)
- startTime (inputMask)
- nbrAvailablePlaces (input)
- offerRide (button)

_Functions:_
- get/set fromLocation
- get/set toLocation
- get/set startTime
- toString
- offerRide (driverId, fromLocation, toLocation, startTime, nbrAvailablePlaces)

**Passenger Screen**

_Inputs:_
- fromLocation (droDown)
- toLocation (dropDown)
- startTime (inputMask)
- nbrRequestedPlaces (input)
- offerRide (button)

_Functions:_
- get/set fromLocation
- get/set toLocation
- get/set startTime
- toString
- offerRide (passengerId, fromLocation, toLocation, startTime, nbrRequestedPlaces)

**All available drivers**

_Inputs:_
 - listAvailableDrivers (list)
 
 _Functions:_
 - getAllDrivers
 - toString
 
**All passengers requests**
 
 _Inputs:_
  - listPassengerRequest (list)
  
_Functions:_
- getAllPassengers
- toString

**Profile**

**Settings**


 








 
 
 
