<div><h1>Khedni Maak</h1></div>
   
![Logo](front-end/assets/images/truck.png?raw=true)

1. [Introduction et idee generale](#ideeGenerale)
2. [Développeurs](#developpeurs)
3. [Installation](#installation)
   1. [Front end installation](#frontEndInstallation)
      - [Installation Flutter](#installationFlutter)
      - [Installation Android](#installationAndroid)
      - [Configurer votre appareil Android](#configurerVotreAppareilAndroid)
      - [Emulator Android, procédez comme suit](#emulatorAndroid)
   2. [Back end installation](#backEndInstallation)
4. [Documentation](#documentation)
5. [Exemples et screenshots](#exemplesEtScreenshots)
6. [Architecture](#architecture)
7. [Technologie utilise](#technologieUtilise)
8. [Problème Rencontré](#problemeRencontre)
9. [Conclusion](#conclusion)


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
    
-  <h2 name="developpeurs">Développeurs</h2>
    a. Mina gerges mina.gerges@isae.edu.lb.
    
    b. Samer Barhouche samer.barhouche@isae.edu.lb.
    
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
            
            - Update PATH environment variable.
                Cliquer sur start, dans la barre de recherche saisissez **"env"** et sectionner modifier les variables 
                d'environnement pour votre compte.
                Si l'entrée existe, ajoutez le chemin complet à **flutter\bin** en utilisant; comme séparateur des valeurs 
                existantes.
                Si l’entrée n’existe pas, créez une nouvelle variable utilisateur nommé Path avec le chemin complet vers 
                **flutter\bin** comme valeur.
                
            - Assurer que Flutter est bien installer, dans command line (cmd), saisissez '**flutter doctor**'. Cette 
                commande verifier votre environment et affiche u rapport sur l'État de votre installation Flutter. 
                **Verifier attentivement la sortie pour d'autres logiciels que vous pourriez avoir besoin d'installer ou 
                d'autres taches a effectuer, par exemple l'installation de l'Android ou vsCode**...
            
        2. <h4 name="installationAndroid">Installation Android</h4>
        
            **Note :** Flutter requis une installation complete de **Android Studio** pour fournir ses dependence de plate-forme
            Android et pour installer et utiliser les emulator.Cependant, vous pouvez utiliser Flutter dans certain nomber d'éditeurs.
            
            - Installer Android Studio <a href="https://developer.android.com/studio">Android Studio</a>.
            
            - Demarrez Android Studio et suivez l'assistant de configuration d'Android Stuido. Cela installe le dernier 
               SDK Android,, les outils de ligne de commande du SDK Android et les outils de construction du SDK Android, 
               qui sont requis par Flutter lors du développement pour Android.
           
        3. <h4 name="configurerVotreAppareilAndroid">Configurer votre appareil Android</h4>
    
            Pour vous préparer à exécuter et tester votre application Flutter sur un 
            appareil Android, vous avez besoin d'un appareil Android exécutant Android 4.1 (niveau d'API 16) ou supérieur.
                   
            - Activez **Developer options** et le **USB debugging** sur votre appareil. Des instructions détaillées 
            sont disponibles dans la <a href="https://developer.android.com/studio/debug/dev-options">Documentation Android</a>. 
            
            - Windows uniquement: installez le <a href="https://developer.android.com/studio/run/win-usb">Google USB Driver</a>.
            
            - À l'aide d'un câble USB, branchez votre téléphone sur votre ordinateur. Si vous y êtes invité sur votre 
            appareil, autorisez votre ordinateur à accéder à votre appareil. 
            
            - Dans le terminal, exécutez la commande **Flutter devices** pour vérifier que Flutter reconnaît votre appareil 
            Android connecté. Par défaut, Flutter utilise la version du SDK Android sur laquelle est basé votre outil adb. 
            Si vous souhaitez que Flutter utilise une installation différente du SDK Android, vous devez définir la variable 
            d'environnement ANDROID_SDK_ROOT sur ce répertoire d'installation. Configurer l'émulateur Android.
              
        4. <h4 name="emulatorAndroid">Emulator Android, procédez comme suit</h4>
              
            - Activez <a href="https://developer.android.com/studio/run/emulator-acceleration">VM acceleration</a> sur votre machine.
            
            - Lancez **Android Studio**, cliquez sur l'icône **AVD Manager** et sélectionnez **Create Virtual Device…**.
            Dans les anciennes versions d'Android Studio, vous devriez plutôt lancer Android Studio> Outils> Android> 
            AVD Manager et sélectionner Créer un appareil virtuel…. (Le sous-menu Android n'est présent que dans un projet Android.)
            Si vous n'avez pas de projet ouvert, vous pouvez choisir Configurer> AVD Manager et sélectionner Créer un périphérique virtuel…
            
            - Choisissez une définition de périphérique et sélectionnez **Next**.
            
            - Sélectionnez une ou plusieurs images système pour les versions d'Android que vous souhaitez émuler, puis 
            sélectionnez Suivant. Une image x86 ou x86_64 est recommandée. 
            
            - Sous **Emulated Performance**, sélectionnez **Hardware - GLES 2.0** pour activer <a href="https://developer.android.com/studio/run/emulator-acceleration">hardware acceleration</a>
            
            - Vérifiez que la configuration AVD est correcte et sélectionnez **Finish**.
          
            Pour plus de détails sur les étapes ci-dessus, voir <a href="https://developer.android.com/studio/run/managing-avds">Managing AVDs.</a>
          
            - Dans Android Virtual Device Manager, cliquez sur **Run** dans la barre d'outils. L'émulateur démarre et 
            affiche le canevas par défaut pour la version du système d'exploitation et l'appareil sélectionnés.
      
        <h4 style="color: red;">Pour plus d'information a propos l'installation de Flutter: <a href="https://flutter.dev/docs/get-started/install/windows">Flutter installation</a></h4>  
        
   
   2. <h3 name="backEndInstallation">Back end installation</h3>
   
    



