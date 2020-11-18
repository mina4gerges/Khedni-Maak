<div><h1>Khedni Maak</h1></div>
   
![Logo](front-end/assets/images/truck.png?raw=true)

1. [Introduction et idee generale](#ideeGenerale)
2. [Application Screens](#applicationScreens)
   1. [All users screens](#allUsersScreens)
   2. [Driver screens](#driverScreens)
   3. [Rider screens](#riderScreens)
3. [Développeurs](#developpeurs)
4. [Technologie utilise](#technologieUtilise)
5. [API externe utilise](#apiExterneUtilise)
   1. [Google Map](#googleMap)
   2. [Firebase (Notification)](#firebaseNotification)
6. [Architecture](#architecture)
    1. [Diagramme de cas d'utilisation](#architecture)
    2. [Cas d'utilisation "Choisir Driver"](#choisirDriver)
    3. [Cas d'utilisation "Choisir Rider"](#choisirRider)
7. [Installation](#installation)
   1. [Front end installation](#frontEndInstallation)
      - [Installation Flutter](#installationFlutter)
      - [Installation Android](#installationAndroid)
      - [Configurer votre appareil Android](#configurerVotreAppareilAndroid)
      - [Emulator Android, procédez comme suit](#emulatorAndroid)
   2. [Back end installation](#backEndInstallation)
      - [Backend Installation ](#binstallation)
      - [Cloud Deployment ](#cloudDeployment)
      - [API ](#API)
8. [Faire Run](#faireRun)
   1. [Faire Run partie front-end](#faireRunPartieFrontEnd)
   2. [Faire Run partie back-end](#faireRunPartieBackEnd)

-  <h2 name="ideeGenerale">Introduction et idee generale</h2>

    “*Khedni Maak*” est une application mobile dont son idée générale est d'aider les travailleurs, les étudiant ou 
    chaque personne qui n’a pas une voiture pour qu’il puisse se déplacer facilement.
    
    Alors c’est une programme a pour objectif de répondre au besoin d’une personne qui souhaite de se déplacer d’un 
    endroit à un autre gratuitement ou avec honoraires où l’utilisateur qui va répondre au service le décide.
    
    Par exemple, si un étudiant souhaite de se déplacer de sa maison a l'université / école, il ouvre l’application 
    indique le point de départ A et le point d'arrivée B, tout les autre utilisateur reçoive un (notification) que cette
    personne veut déplace de A vers B, il confirme s’il peuvent répondre à cette demande et reject s’il ne peuvent pas.
    Dans le cas où un des utilisateurs confirmé, la personne qui demande le service reçoive une notification qu'une 
    personne répondre à ce service.
    
    D’une autre manière, les utilisateurs peuvent aussi indiquée sur la carte l’endroit de destination, ainsi la personne 
    qui veuille de se déplacer peut savoir qui sont les personne ont pour destination qu’il souhaite, alors il click sur 
    cette personne, une notification est envoyée il peut l’accepter ou la rejeter.
    
    L’utilisateur qui demande le service peut voir de déplacement de la personne qui va répondre à leur service en temp 
    réelle. De même cette application comporte un outfile de communication chatting ou les 2 utilisateurs peut se 
    communiquer facilement sans utiliser d’autre application.
    
    Chaque utilisateur a un profile détaillé est vérifié, ce profilé comporte deux choses important tous les informations 
    de la voiture et la photo d’utilisateur pour bien identique la voiture et la personne et d'éviter tout arnaque. De 
    plus une section pour le rating pour savoir plus d’information sur l’utilisateur par exemple son comportement, 
    faire confiance ...
    
    Khedni Maak application mobile pour aide les personnes qui non pas une voiture à se déplace d'un endroit à un autre 
    a l'aide d'autre personne
    
-  <h2 name="applicationScreens">Application Screens</h2>

   1. <h3 name="allUsersScreens">All users screens</h3>
   
         Introduction Screen     |   Login Screen            |  Dashboard Screen
      :-------------------------:|:-------------------------:|:-------------------------:
      ![Introduction Screen](front-end/screenshots/introductionScreen.PNG?raw=true)  |  ![dashboard Screen](front-end/screenshots/dashboardScreen.PNG?raw=true)  |  ![login Screen](front-end/screenshots/loginScreen.PNG?raw=true)  
   
   2. <h3 name="driverScreens">Driver screens</h3>

         Map Screen              |   Adding new Route        
      :-------------------------:|:-------------------------:
      ![driver Map Screen](front-end/screenshots/driverMapScreen.PNG?raw=true)  |  ![driver Add Route Screen](front-end/screenshots/driverAddRouteScreen.PNG?raw=true)   
   
         New Added Route Display on Map |  All driver routes        |  Driver Notification
      :--------------------------------:|:-------------------------:|:-------------------------:
      ![driver New Route Display On Map](front-end/screenshots/driverNewRouteDispalyOnMap.PNG?raw=true)  |  ![driver Rides Screen](front-end/screenshots/driverRidesScreen.PNG?raw=true)  |  ![driver Notification](front-end/screenshots/driverNotification.PNG?raw=true) 
   
   3. <h3 name="riderScreens">Rider screens</h3>
   
        Available Rides Screen          |  History Screen           
      :--------------------------------:|:-------------------------:
      ![rider Available Rides Screen](front-end/screenshots/riderAvailableRidesScreen.PNG?raw=true)  |  ![rider History Screen](front-end/screenshots/riderHistoryScreen.PNG?raw=true)
    
-  <h2 name="developpeurs">Développeurs</h2>
    a. Mina gerges mina.gerges@isae.edu.lb.
    
    b. Samer Barhouche samer.barhouche@isae.edu.lb.
    
-  <h2 name="technologieUtilise">Technologie utilise</h2>

    - **Flutter** developer par google pour l'application mobile (https://flutter.dev/)
    
    - **Firebase** pour les notifications (https://firebase.google.com/)
    
    - **Google API** pour tous ce qui concerne "Map" (https://console.developers.google.com/)
    
    - **Flask** (Python 3.8) microservice pour "Introduction Screen" (https://flask.palletsprojects.com/en/1.1.x/)
    
    - **Spring Boot** (Java) microservice pour "Login/Sign up" et "Routes" (https://spring.io/)
    
    - **MongoDB** base de donne le microservice "Login/Signup" (https://www.mongodb.com/)
    
    - **MySql** base de donne le microservice "Routes" et "Introduction Screen" (https://www.mysql.com/)
    
    - **AWS** pour le hosting des microservice (https://aws.amazon.com/)
    
    - **Docker** container (https://www.docker.com/)
    
-  <h2 name="apiExterneUtilise">API externe utilise</h2>

    Les API utilise qui ne sont pas cree par nous, sont de Google. Par exemple API pour **Google Map**, **Firebase** pour les notifications.
    
    - <h3 name="googleMap">Google Map</h3>
        
        Lien officiel et documentation : https://console.cloud.google.com/apis/library
        
         API                     |   Utilisation / Description                           |  Price
      :-------------------------:|:---------------------------------------------------:|:-------------------------:
      Maps SDK for Android       |  Utilise pour MAP sur les telephone mobile android  |  Gratuit
      Maps SDK for IOS       |  Utilise pour MAP sur les telephone mobile IOS  |  Gratuit
      Places API  |  Avoir les details de million de places  |  Gratuit pour basic data
      Directions API  |  Direction entre plusieurs location  |  USD5.00 --> 0-100K requests/month OU USD4.00 --> 100K+ requests/month
      Geocoding API   |  Convertissez les adresses en coordonnées géographiques (géocodage), que vous pouvez utiliser pour placer des marqueurs ou positionner la carte  |  USD5.00 --> 0-100K requests/month OU USD4.00 --> 100K+ requests/month
      Distance Matrix API  |  Accédez à la distance et au temps de trajet pour une matrice d'origines et de destinations avec l'API Distance Matrix  |  USD10.00 --> 0-100K elements/month OU USD8.00 --> 100K+ elements/month  
    
    - <h3 name="firebaseNotification">Firebase (Notification)</h3>
    
        Lien officiel et documentation : https://firebase.google.com/
        
         API                     |   Utilisation / Description                           |  Price
      :-------------------------:|:---------------------------------------------------:|:-------------------------:
      Cloud Messaging       |  Firebase Cloud Messaging (FCM). À l'aide de FCM, vous pouvez informer une application cliente qu'un nouvel e-mail ou d'autres données sont disponibles pour la synchronisation  |  Gratuit
      Firebase Installations API       |  Le service d'installation Firebase (FIS) fournit un ID d'installation Firebase (FID) pour chaque instance installée d'une application Firebase |  Gratuit
      Cloud Functions API       |  Cloud Functions est une solution de calcul légère permettant aux développeurs de créer des fonctions autonomes à usage unique qui répondent aux événements Cloud sans avoir besoin de gérer un serveur ou un environnement d'exécution  |  Gratuit
    
-  <h2 name="architecture">Architecture</h2>

    1. <h3 name="diagrammeDeCasDutilisation">Diagramme de cas d'utilisation</h3>
    
        ![use case](Use-case.png?raw=true)
    
    2. <h3 name="choisirDriver">Cas d'utilisation "Choisir Driver"</h3>
    
    3. <h3 name="choisirRider">Cas d'utilisation "Choisir Rider"</h3>
    
-  <h2 name="installation">Installation</h2>

   1. <h3 name="frontEndInstallation">Front end installation</h3>
        "Khedni Maak" est une application mobile, donc elle doit être accessible au utilisateur qui utilise l’IOS ou 
        l’Android. Pour gagner du temp et de ne ma pas écrire un code pour IOS et un autre code pour Android, de meme pour 
        suivre la technologie on a decide de developer notre projet en utilisant Flutter. 
        Flutter est Google UI toolkit permettant de créer de superbes applications compilées de manière native pour 
        mobile, Web et ordinateur à partir d'une seule base de code.
        
        1. <h4 name="installationFlutter">Installation Flutter</h4>
        
            - Installer <a href="https://storage.googleapis.com/flutter_infra/releases/stable/windows/flutter_windows_1.22.3-stable.zip">flutter_windows+11.22.3-stable.zip</a>.
            
            - Extraire lee zip file et le metre dans **(C:\src\flutter)**.
            
            ![flutter-location](front-end/screenshots/flutter-location.PNG?raw=true)
            
            - Update PATH environment variable.
                Cliquer sur start, dans la barre de recherche saisissez **"env"** et sectionner modifier les variables 
                d'environnement pour votre compte.
                Si l'entrée existe, ajoutez le chemin complet à **flutter\bin** en utilisant ; comme séparateur des valeurs 
                existantes.
                Si l’entrée n’existe pas, créez une nouvelle variable utilisateur nommé Path avec le chemin complet vers 
                **flutter\bin** comme valeur.
                
                ![environment](front-end/screenshots/environment.PNG?raw=true)
                
            - Assurer que Flutter est bien installer, dans command line (cmd), saisissez '**flutter doctor**'. Cette 
                commande verifier votre environment et affiche u rapport sur l'État de votre installation Flutter. 
                **Verifier attentivement la sortie pour d'autres logiciels que vous pourriez avoir besoin d'installer ou 
                d'autres taches a effectuer, par exemple l'installation de l'Android ou vsCode**...
                
                ![driver New Route Display On Map](front-end/screenshots/flutter-doctor.PNG?raw=true)
            
        2. <h4 name="installationAndroid">Installation Android</h4>
        
            **Note :** Flutter requis une installation complete de **Android Studio** pour fournir ses dependence de plate-forme
            Android et pour installer et utiliser les emulator.Cependant, vous pouvez utiliser Flutter dans certain nombre d'éditeurs.
            
            - Installer Android Studio <a href="https://developer.android.com/studio">Android Studio</a>.
            
            - Démarrez Android Studio et suivez l'assistant de configuration d'Android Studio. Cela installe le dernier 
               SDK Android, les outils de ligne de commande du SDK Android et les outils de construction du SDK Android, 
               qui sont requis par Flutter lors du développement pour Android.
           
        3. <h4 name="configurerVotreAppareilAndroid">Configurer votre appareil Android</h4>
    
            Pour vous préparer à exécuter et tester votre application Flutter sur un 
            appareil Android, vous avez besoin d'un appareil Android exécutant Android 4.1 (niveau d'API 16) ou supérieur.
                   
            - Activez **Developer options** et le **USB debugging** sur votre appareil. Des instructions détaillées 
            sont disponibles dans la <a href="https://developer.android.com/studio/debug/dev-options">Documentation Android</a>. 
            
            - Windows uniquement: installez le <a href="https://developer.android.com/studio/run/win-usb">Google USB Driver</a>.
            
            - À l'aide d'un câble USB, branchez votre téléphone sur votre ordinateur. Si vous y êtes invité sur votre 
            appareil, autorisez votre ordinateur à accéder à votre appareil. 
            
            - Dans le terminal, exécutez la commande **flutter devices** pour vérifier que Flutter reconnaît votre appareil 
            Android connecté. Par défaut, Flutter utilise la version du SDK Android sur laquelle est basé votre outil adb. 
            Si vous souhaitez que Flutter utilise une installation différente du SDK Android, vous deviez devinerai la variable 
            d'environnement ANDROID_SDK_ROOT sur ce répertoire d'installation. Configurer l'émulateur Android.
            
            ![driver New Route Display On Map](front-end/screenshots/flutter-devices.PNG?raw=true)
              
        4. <h4 name="emulatorAndroid">Emulator Android, procédez comme suit</h4>
              
            - Activez <a href="https://developer.android.com/studio/run/emulator-acceleration">VM acceleration</a> sur votre machine.
            
            - Lancez **Android Studio**, cliquez sur l'icône **AVD Manager** et sélectionnez **Create Virtual Device…**.
            Dans les anciennes versions d'Android Studio, vous devriez plutôt lancer Android Studio> Outils> Android> 
            AVD Manager et sélectionner Créer un appareil virtuel…. (Le sous-menu Android n'est présent que dans un projet Android.)
            Si vous n'avez pas de projet ouvert, vous pouvez choisir Configurer> AVD Manager et sélectionner Créer un périphérique virtuel…
            
            - Choisissez une définition de périphérique et sélectionnez **Next**.
            
            - Sélectionnez une ou plusieurs images systèmes pour les versions d'Android que vous souhaitez émuler, puis 
            sélectionnez Suivant. Une image x86 ou x86_64 êtres recommandé. 
            
            - Sous **Emulated Performance**, sélectionnez **Hardware - GLES 2.0** pour activer <a href="https://developer.android.com/studio/run/emulator-acceleration">hardware acceleration</a>
            
            - Vérifiez que la configuration AVD est correcte et sélectionnez **Finish**.
            
            - Assurez que emulator est bien installez: **C:\Users\USER.NAME\AppData\Local\Android\Sdk\emulator>**, vous devez voir list des emulator installer.
            
            ![driver Map Screen](front-end/screenshots/emulator.PNG?raw=true)
          
            Pour plus de détails sur les étapes ci-dessus, voir <a href="https://developer.android.com/studio/run/managing-avds">Managing AVDs.</a>
          
            - Dans Android Virtual Device Manager, cliquez sur **Run** dans la barre d'outils. L'émulateur démarre et 
            affiche le canevas par défaut pour la version du système d'exploitation et l'appareil sélectionnés.
      
        <h4 style="color: red;">Pour plus d'information a propos l'installation de Flutter: <a href="https://flutter.dev/docs/get-started/install/windows">Flutter installation</a></h4>  
        
   
   2. <h3 name="backEndInstallation">Back end installation</h3>
   
        Our backend consists of three microservices: Users, Routes and Server.
        The users microservice will consist of all the users actions: SignIn, signup, list of users, generate authentication token… This is a spring microservice   connected to standalone MongoDB database and uses the new reactive spring boot technologies (Flux, Mono, Reactive Mongo, etc. ) Also this service is registered with the Eureka Server.
        The routes microservice will allow the users to create, edit, add and delete routes. These routes will appear on the mobile app. This is a spring microservice connected to a standalone MySQL database. (not reactive). Also, this service is registered with the Eureka Server.
        The server microservice is an Eureka Server, which is an application that holds the information about all client-service applications. Every Micro service will register into the Eureka server and Eureka server knows all the client applications running on each port and IP address. Eureka Server is also known as Discovery Server.

        1. <h4 name="binstallation">Backend Installation</h4>
        
            1) **clone into the full directory**

                  Git clone https://github.com/mina4gerges/Khedni-Maak.git

            2) **navigate to the backend folder**

            3) **Go to eclipse and import as maven folder**

                  It is important to import the eureka server first then the microservices

            4) **After successful import, eclipse will start downloading the jars from the Maven Repos**

            5) **First install and run the server microservice using maven install**

                  This will generate a .jar file as configured in the pom.xml file

                  java -jar target/server-0.0.1-SNAPSHOT.jar

                  The eureka server will start in port 8761

            6) **Import the two other projects using Import Maven Project from Eclipse**

            7) **Wait for the projects to download missing jars from the Maven repo**

            8) **Enable the local config**

                  #Case Routes Microservice

                  Make sure to comment the production connection and switch to the localhost in the ressources/application.properties

                  After the development phase, we have deployed our microservices to the AWS cloud in order to use them with a 		  production environment.

                  ![eclipse1](back-end/Screenshots/eclipse1.png?raw=true)

                  As you can see, if you are running our microservices locally, you need to uncomment the localhost entries for spring.datasource.url and      eureka.client.serviceUrl.defaultZone and comment the production entries.

                  Proceed with the same concept for the Users Microservice

            9) **install the projects using**

                  maven install

            10) **launch the projects using**

                  java -jar Microservice-Users/target/khednimaak-users-0.0.1-SNAPSHOT.jar

                  java -jar Microservice-Routes/target/khednimaak-routes-0.0.1-SNAPSHOT.jar

            11) **Check the terminal for any error in the logs**

            12) **Using your web browser, navigate to [http://localhost:8761](http://localhost:8761) and look for the two microservices: Routes, Users.**

                  If all went well, these two should appear as registered clients in your Eureka Server

            13) **if all is ok, you can now follow the API Documentation to use our REST API.**
            
            
        2. <h4 name="cloudDeployment">Cloud Deployment</h4>
            We have decided to use Amazon Web Services since we are familiar with it and is one of the best cloud providers. Below are the steps to make this environment work with Amazon.
        
        
              1) **Provision a Linux instance using Ec2 (Elastic cloud compute) service. Since this will behave as a production instance and we will be installing    docker on it, I have decided that we need it to be a t3.medium type. (2vcpu, 4gb memory, 5gbps network bandwidth…)**
              
              2) **It is important to place the linux instance in a public subnet where it will be reachable to the public and assign a static ip to it. In our case, the public ip is: 35.180.35.89**
              
              ![aws1](back-end/Screenshots/aws1.png?raw=true)
              
              3) **Generate a new private key to use in order to login with SSH into this linux server and impose the correct access permissions to this key using** 

                  chmod 400 khedni_private_key.pem


              4) **Store the key in a secret location on the local machine. Navigate there and ssh to the server**

                  Ssh -I khedni_private_key.pem ec2-user@35.180.35.89


              5) **Once in the server, Install Git and Docker**

                  sudo yum update -y
                  sudo amazon-linux-extras install docker
                  sudo service docker start
                  sudo usermod -a -G docker ec2-user
                  sudo systemctl enable docker
                  sudo reboot -n


              6) **Install java 8**
                  sudo yum install java


              7) **Install maven**

                  wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
                  tar xvf apache-maven-3.0.5-bin.tar.gz
                  mv apache-maven-3.0.5  /usr/local/apache-maven
                  sudo mv apache-maven-3.0.5  /usr/local/apache-maven
                  export M2_HOME=/usr/local/apache-maven
                  export M2=$M2_HOME/bin
                  export PATH=$M2:$PATH
                  source ~/.bashrc
                  mvn -version



              8) **Clone and checkout into the master branch**

                  mkdir microservices
                  cd microservices
                  git clone https://github.com/mina4gerges/Khedni-Maak.git
                  git checkout master


              9) **Create production database**

                  a) **MySQL**: Create MySQL instance using Amazon RDS 


                  b) **MongoDB**: Create mongodb instance on the Linux instance 

                    grep ^NAME  /etc/*release : it should be Amazon Linux 
                    Create a /etc/yum.repos.d/mongodb-org-4.4.repo file so that you can install MongoDB directly using yum

                  File content:
                     [mongodb-org-4.4]
                     name=MongoDB Repository
                     baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
                     gpgcheck=1
                     enabled=1
                     gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc

                  
                  install and start mongo using these command 

                  sudo yum install -y mongodb-org
                  sudo systemctl start mongod


            10) **Build jars**

                  cd back-end/Microservice-Routes/
                  ./mvnw install 


                  cd back-end/Microservice-Users/
                  ./mvnw install 

                  cd back-end/server/
                  ./mvnw install 



            11) **Create docker images**

                  We have previously configured Dockerfiles in each project in order to run these microservices independently as Docker containers.

                  cd back-end/Microservice-Routes/
                  docker build -t routes-microservice .


                  cd back-end/Microservice-Users/
                  docker build -t users-microservice .


                  cd back-end/servers/
                  docker build -t server .

                  This will create three docker images: routes-microservice, users-microservice and server 

                  ![docker](back-end/Screenshots/docker1.png?raw=true)

            
            12) **Launch docker containers from these images and expose application ports**

                  docker run -d -p 8761:8761 server
                  docker run -d -p 9292:9292 microservice-routes
                  docker run -d -p 8090:8090 users-microservice

                  These commands will run three containers from the images we recently created and expose the corresponding ports. Also, using -d flag will make docker run in a detached mode. (the container will start and run in the background)
                  
                  ![docker](back-end/Screenshots/docker2.png?raw=true)
                  
             13) **Install apache web server to serve images**
             
                  sudo yum install -y httpd
                  sudo service httpd start

                  Make sure port 80 is open in the AWS EC2 security group and load the images under an image folder

                  /var/www/html/img

-  <h2 name="faireRun">Faire Run</h2>
   
   Apres l'installation complete, Utilisez CMD pour accede au projet : **cd khedni-maak**:
  
      - <h3 name="faireRunPartieFrontEnd">Faire Run partie front-end</h3>
      
         - Démarrez emulator Android sur votre PC ou connecter votre telephone Android.
         - Changez le directory pour accéder a 'front end' directory: **cd front-end**
         - Utilisez la commande : **flutter run** pour démarrer le projet
         
         ![flutter run](front-end/screenshots/flutter-run.PNG?raw=true)
         
      - <h3 name="faireRunPartieBackEnd">Faire Run partie back-end</h3>
      
         -  Changez le directory pour accéder au 'back end' directory: **cd back-end**
         -  Changez le directory pour accéder au 'server' directory: **cd server**
            - Installer tous les dependency du server en utilisant **mvnw install**
            - Apres l'installation des dependency, démarrez le server en utilisant : **cd target** puis **java -jar server-0.0.1-SNAPSHOT.jar**
            
            ![flutter run](back-end/Screenshots/java-jar-server.PNG?raw=true)
            
         -  Changez le directory pour accéder Au 'Microservice-Users' directory: **cd Microservice-Users**
            - Installer tous les dependency du server en utilisant **mvnw install**
            - Apres l'installation des dependency, démarrez le micro service des users en utilisant : **cd target** puis **java -jar khednimaak-users-0.0.1-SNAPSHOT.jar** 
            
            ![flutter run](back-end/Screenshots/java-jar-users.PNG?raw=true)
            
         -  Changez le directory pour accéder au 'Microservice-Routes' directory: **cd Microservice-Routes**
            - Installer tous les dependency du server en utilisant **mvnw install**
            - Apres l'installation des dependency, démarrez le micro service des routes en utilisant : **cd target** puis **java -jar khednimaak-routes-0.0.1-SNAPSHOT.jar** 
            
            ![flutter run](back-end/Screenshots/java-jar-routes.PNG?raw=true)
            
         -  Changez le directory pour accéder au 'Microservice-introduction-screen' directory: **cd Microservice-introduction-screen**
            - Installer tous les dependency convenable pour **flask**: **pip install flask** R.Q: bien sure il faut installer **Python** https://www.python.org/downloads/
            - Apres l'installation des dependency, démarrez le micro service des introductions screen en utilisant : **cd screens** puis **flask run** 
            
            ![flutter run](back-end/Screenshots/flask-run.PNG?raw=true)
   
   
     
