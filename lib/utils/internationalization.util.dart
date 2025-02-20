import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['it', 'en'];

  String get languageCode => locale.toString();

  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
  }) =>
      [enText][languageIndex] ?? '';
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      FFLocalizations.languages().contains(locale.toString());

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  {
    'saluto': {
      'it': 'Ciao',
      'en': 'Hi',
    },

    'Crop': {
      'it': 'Taglia',
      'en': 'Crop',
    },

    'Text': {
      'it': 'Testo',
      'en': 'Text',
    },

    'Flip': {
      'it': 'Inverti',
      'en': 'Flip',
    },
    'Rotate right': {
      'it': 'Ruota a destra',
      'en': 'Rotate right',
    },

    'Rotate left': {
      'it': 'Ruota a sinistra',
      'en': 'Rotate left',
    },

    'Blur': {
      'it': 'Sfoca',
      'en': 'Blur',
    },
    'Blur radius': {
      'it': 'Raggio sfocatura',
      'en': 'Blur radius',
    },
    'Color opacity': {
      'it': 'Opacità colore',
      'en': 'Color opacity',
    },
    'Filter': {
      'it': 'Filtri',
      'en': 'Filter',
    },'Freeform': {
      'it': 'Forma libera',
      'en': 'Freeform',
    },'Square': {
      'it': 'Quadrato',
      'en': 'Square',
    },

    'Nome e cognome': {
      'it': 'Nome e cognome',
      'en': 'Name and surname',
    },
    'Impostazioni': {
      'it': 'Impostazioni',
      'en': 'Settings',
    },
    'Non ci sono altri post per oggi!': {
      'it': 'Non ci sono altri post per oggi!',
      'en': 'There are no more posts for today!',
    },
    'scopri': {
      'it': 'Scopri nuovi corsi',
      'en': 'Discover new courses',
    },
    'conferma password': {
      'it': 'Conferma password',
      'en': 'Confirm password',
    },
    'avanti': {
      'it': 'Avanti',
      'en': 'Next',
    },
    'Scadenza abbonamento': {
      'it': 'Scadenza abbonamento',
      'en': 'Subscription expire at',
    },
    'Nome utente': {
      'it': 'Nome utente',
      'en': 'Username',
    },
    'Nome': {
      'it': 'Nome',
      'en': 'Name',
    },
    'Passa a Premium per sbloccare gli allenamenti personalizzati': {
      'it': 'Passa a Premium per sbloccare gli allenamenti personalizzati',
      'en': 'Upgrade to Premium to unlock custom trainings',
    },
    'data di nascita': {
      'it': 'Data di nascita',
      'en': 'Born Date',
    },'Tema scuro': {
      'it': 'Tema scuro',
      'en': 'Dark theme',
    },
    'isPasswordValid': {
      'it':
          'La password deve rispettare i seguenti requisiti: minimo 6 caratteri, la prima lettera deve essere maiuscola, 1 lettera minuscola, minimo 1 numero.',
      'en':
          'Password must respect these requirement: minimum 6 letters, first letter must be uppercase, 1 number minimum.'
    },
    'isEmailValid': {
      'it': 'Inserisci un\'email valida.',
      'en': 'Insert a valid email.',
    },
    'isEmailValid': {
      'it': 'Inserisci un\'email valida.',
      'en': 'Insert a valid email.',
    },
    'isConfirmPasswordValid': {
      'it': 'Le password non coincidono.',
      'en': 'Passwords don\'t match.',
    },
    'isNameValid': {
      'it': 'Il nome deve essere almeno di 3 caratteri.',
      'en': 'Insert a valid email.',
    },
    'isBioValid': {
      'it': 'La bio deve contenere almeno 3 caratteri.',
      'en': 'Bio must be at least 3 letters.',
    },
    'isWeightValid': {
      'it': 'Inserisci un peso valido.',
      'en': 'Insert a valid weight.',
    },
    'isHeightValid': {
      'it': 'Inserisci un\'altezza valida.',
      'en': 'Insert a valid height',
    },
    'isUsernameValid': {
      'it': 'L\'username deve essere almeno di 3 caratteri',
      'en': 'Username must be at least 3 letters.',
    },
    'isDateBornValid': {
      'it': 'Inserisci una data di nascita valida.',
      'en': 'Insert a valid born date.',
    },
    'otp': {
      'it': 'Richiedi codice OTP',
      'en': 'Send OTP',
    },
    'altezza': {
      'it': 'Altezza',
      'en': 'Height',
    },
    'peso': {
      'it': 'Peso',
      'en': 'Weight',
    },
    'benvenuto': {
      'it': 'Benvenuto',
      'en': 'Welcome',
    },
    'corsi': {
      'it': 'I tuoi corsi preferiti',
      'en': 'Your Favourite Courses',
    },
    'cors': {
      'it': 'Corsi',
      'en': 'Courses',
    },
    'lezioni': {
      'it': 'Lezioni',
      'en': 'Lessons',
    },
    'schede custom': {
      'it': 'Schede personalizzate',
      'en': 'Custom plans',
    },
    'allenamentiPersonalizzati': {
      'it': 'Allenamenti personalizzati',
      'en': 'Custom Trainings',
    },
    'scheda': {
      'it': 'Scheda',
      'en': 'Training Schedule',
    },
    'dieta': {
      'it': 'Dieta',
      'en': 'Diet',
    },
    'schede': {
      'it': 'Schede',
      'en': 'Plans',
    },
    'home': {
      'it': 'Home',
      'en': 'Home',
    },
    'social': {
      'it': 'Social',
      'en': 'Social',
    },
    'profilo': {
      'it': 'Profilo',
      'en': 'Profile',
    },
    'unisciti': {
      'it': 'Unisciti alla chiamata',
      'en': 'Join the room',
    },
    'stanza': {
      'it': 'ID Stanza',
      'en': 'Room ID',
    },
    'nome': {
      'it': 'Nome',
      'en': 'Name',
    },
    'partecipa': {
      'it': 'Partecipa',
      'en': 'Join',
    },
    'audio': {
      'it': 'Disattiva Audio',
      'en': 'Mute',
    },
    'camera': {
      'it': 'Disattiva la videocamera',
      'en': 'Turn off Camera',
    },
    'login': {
      'it': 'Accedi',
      'en': 'Log In',
    },
    'email': {
      'it': 'Email',
      'en': 'Email',
    },
    'password': {
      'it': 'Password',
      'en': 'Password',
    },
    'accedi': {
      'it': 'Accedi via SMS',
      'en': 'Login with SMS',
    },
    'inserisci': {
      'it': 'Inserisci il numero di cellulare',
      'en': 'Insert your phone number',
    },
    'numero': {
      'it': 'Numero di telefono',
      'en': 'Phone Number',
    },
    'requisitiNumero': {
      'it': 'Numero di telefono richiesto e deve iniziare con +.',
      'en': 'Phone Number is required and has to start with +.',
    },
    'accediNumero': {
      'it': 'Accedi con il numero di cellulare',
      'en': 'Log In with phone numeber',
    },
    'conferma': {
      'it': 'Conferma codice',
      'en': 'Confirm code',
    },
    'messaggio': {
      'it': 'Questo codice contribuisce a tenere al sicuro il tuo account',
      'en': 'This code helps keep your account safe and secure',
    },
    'inserisciCodice': {
      'it': 'Inserisci il codice di verifica',
      'en': 'Insert the verification code',
    },
    'step': {
      'it': 'Conferma e Continua',
      'en': 'Confirm and Continue',
    },
    'stanzaNuova': {
      'it': 'Crea una nuova stanza',
      'en': 'Create new room',
    },
    'stanzaEntra': {
      'it': 'Entra in una stanza',
      'en': 'Join Room',
    },
    'registrati': {
      'it': 'Registrati',
      'en': 'Register',
    },
    'insertNumber': {
      'it': 'Inserisci il numero di cellulare per registrarti',
      'en': 'Insert phone number to register',
    },
    'assistenza': {
      'it': 'Hai bisogno di aiuto?',
      'en': 'Need Help?',
    },
    'registratiNumero': {
      'it': 'Registrati con OTP',
      'en': 'Register with OTP',
    },
    'username': {
      'it': 'Username',
      'en': 'Username',
    },
    'nascita': {
      'it': 'Data di nascita',
      'en': 'Date of birth',
    },
    'cambia': {
      'it': 'Modifica',
      'en': 'Change',
    },
    'abbonamenti': {
      'it': 'I miei abbonamenti',
      'en': 'My subscriptions',
    },
    'bio': {
      'it': 'Biografia',
      'en': 'Biography',
    },
    'altezza': {
      'it': 'Altezza',
      'en': 'Height',
    },
    'peso': {
      'it': 'Peso',
      'en': 'Weight',
    },
    'sub': {
      'it': 'Seleziona un piano',
      'en': 'Choose a plan',
      //ho dei seri dubbi sulla correttezza in inglese di sta cosa ma vabbe
    },
    'info': {
      'it': 'Info',
      'en': 'Info',
    },
    'scegli': {
      'it': 'Scegli il piano',
      'en': 'Choose plain',
    },
    'amici': {
      'it': 'Amici',
      'en': 'Friends',
    },
    'esplora1': {
      'it': 'I miei corsi',
      'en': 'My Courses',
    },
    'esplora2': {
      'it': 'Esplora nuovi corsi',
      'en': 'Explore courses',
    },
    'incorso': {
      'it': 'Allenamenti in corso',
      'en': 'Started Workouts',
    },
    'finiti': {
      'it': 'Allenamenti conclusi',
      'en': 'Completed Workouts',
    },
    "Alimentazione": {
      'it': 'Alimentazione',
      'en': 'Diet',
    },
    'cerca': {
      'it': 'Cerca corso per nome',
      'en': 'Find course by name',
    },
    'salva': {
      'it': 'Salva',
      'en': 'Save',
    },
    'impostazioni': {
      'it': 'Impostazioni',
      'en': 'Settings',
    },
    'modifica': {
      'it': 'Modifica Profilo',
      'en': 'Edit Profile',
    },
    'uomo': {
      'it': 'Uomo',
      'en': 'Man',
    },
    'donna': {
      'it': 'Donna',
      'en': 'Woman',
    },
    'altro': {
      'it': 'Non specificato',
      'en': 'Not defined',
    },
    'sesso': {
      'it': 'Sesso',
      'en': 'Gender',
    },
    'virtualclasses': {'it': "Classi virtuali", 'en': "Virtual classes"},
    'myvirtualclasses': {
      'it': "Le mie classi virtuali",
      'en': "My virtual classes"
    },
    'Piani personalizzati': {
      'it': "Piani personalizzati",
      'en': "Personal plans"
    },
    'Allenamenti personalizzati': {
      'it': "Allenamenti personalizzati",
      'en': "Personal workouts"
    },
    'Allenamenti preferiti': {
      'it': "Allenamenti preferiti",
      'en': "Favourite trainings"
    },
    "Seleziona lingua": {
      'it': "Seleziona lingua",
      'en': "Select language"
    },

    "Passa a Premium per sbloccare la sezione di alimentazione": {
      'it': "Passa a Premium per sbloccare la sezione di alimentazione",
      'en': "Upgrade to Premium to unlock Diet section"
    },
    'Allenamenti preferiti': {
      'it': "Allenamenti preferiti",
      'en': "Favourite trainings"
    },
    "Non hai nessun corso preferito": {
      'it': "Non hai nessun corso preferito",
      'en': "You have no favourite trainings"
    },
    "La tua FC Card": {'it': "La tua FC Card", 'en': "Your FC Card"},
    "or": {'it': "OPPURE", 'en': "OR"},
    "less": {'it': "meno", 'en': "less"},
    "reel": {'it': "Reel", 'en': "Reel"},
    "like": {'it': "Mi Piace", 'en': "Like"},
    "post": {'it': "Post", 'en': "Post"},
    "live": {'it': "Live", 'en': "Live"},
    "viewAll": {'it': "Vedi tutti", 'en': "View All"},
    "view": {'it': "Vedi", 'en': "View"},
    "more": {'it': "di più", 'en': "more"},
    "story": {'it': "Storia", 'en': "Story"},
    "posts": {'it': "Posts", 'en': "Posts"},
    "block": {'it': "Block", 'en': "Block"},
    "reply": {'it': "rispondi", 'en': "reply"},
    "posting": {'it': "Posting", 'en': "Posting"},
    "unSend": {'it': "Non Inviare", 'en': "UnSend"},
    "send": {'it': "Invia", 'en': "Send"},
    "rememberPassword": {'it': "Ricorda Password", 'en': "Remember password"},
    "undo": {'it': "Indietro", 'en': "Undo"},
    "done": {'it': "Fatto", 'en': "Done"},
    "cancel": {'it': "Cancella", 'en': "Cancel"},
    "slideToCancel": {'it': "Scorri per cancellare", 'en': "Slide to Cancel"},
    "followings": {'it': "Followers", 'en': "Followers"},
    "writeMessage": {
      'it': "Scrivi un messaggio...",
      'en': "Write a message..."
    },
    "name": {'it': "Nome", 'en': "Name"},
    "likes": {'it': "Mi Piace", 'en': "Likes"},
    "reels": {'it': "REELS", 'en': "REELS"},
    "postsCap": {'it': "POSTS", 'en': "POSTS"},
    "videos": {'it': "VIDEOS", 'en': "VIDEOS"},
    "logIn": {'it': "Entra", 'en': "Log in"},
    "follow": {'it': "Segui", 'en': "Follow"},
    "followBack": {'it': "Segui anche tu", 'en': "Follow Back"},
    "activity": {'it': "Attività", 'en': "Activity"},
    "noActivity": {
      'it': "Non c'è nessun attività",
      'en': "There is no activity yet!"
    },
    "suggestionsForYou": {
      'it': "Suggerimenti per te",
      'en': "Suggestions for you"
    },
    "create": {'it': "Crea", 'en': "Create"},
    "noUsers": {'it': "Non c'è nessun utente", 'en': "There is no users yet!"},
    "followPeopleToSee": {
      'it': "Segui qualcuno per iniziare a vedere foto e",
      'en': "Follow people to start seeing the photos and"
    },
    "videosTheyShare": {
      'it': "video che loro condividono",
      'en': "videos they share."
    },
    "signUp": {'it': "Registrati", 'en': "Sign up"},
    "menu": {'it': "Menu", 'en': "Menu"},
    "fullName": {'it': "Nome Completo", 'en': "Full Name"},
    "email": {'it': "E-Mail", 'en': "E-Mail"},
    "next": {'it': "Avanti", 'en': "Next"},
    "createUserName": {'it': "CREA USERNAME", 'en': "CREATE USERNAME"},
    "addUserName": {'it': "Aggiungi un username.", 'en': "Add a username."},
    "youCanChangeUserNameLater": {
      'it': "Puoi cambiarlo in qualsiasi momento",
      'en': "You can change this at any time."
    },
    "thisUserNameExist": {
      'it': "Questo username già esiste",
      'en': "This user name is already exist"
    },
    "report": {'it': "Segnala", 'en': "TReport."},
    "username": {'it': "Username", 'en': "Username"},
    "gallery": {'it': "GALLERIA", 'en': "GALLERY"},
    "photo": {'it': "FOTO", 'en': "PHOTO"},
    "video": {'it': "VIDEO", 'en': "VIDEO"},
    "noVideos": {'it': "Non c'è nessun video!", 'en': "There's no videos yet!"},
    "pronouns": {'it': "Pronomi", 'en': "Pronouns"},
    "noSecondaryCameraFound": {
      'it': "Nessuna fotocamera secondaria trovata",
      'en': "No secondary camera found"
    },
    "pressAndHold": {
      'it': "Premi e trascina per registrare",
      'en': "Press and hold to record"
    },
    "website": {'it': "Sito web", 'en': "Website"},
    "search": {'it': "Cerca", 'en': "Search"},
    "clearSelectedImages": {
      'it': "Elimina immagine selezionata",
      'en': "Clear selected images"
    },
    "noFollowers": {
      'it': "Non hai nessun follower",
      'en': "There is no followers yet!"
    },
    "noFollowings": {
      'it': "Non segui nessuno",
      'en': "There is no followings yet!"
    },
    "comment": {'it': "commento", 'en': "comment"},
    "bio": {'it': "Bio", 'en': "Bio"},
    "personalInformationSettings": {
      'it': "Impostazioni informazioni personali",
      'en': "Personal information settings"
    },
    "noRecordsYet": {'it': "Nessuna registrazione", 'en': "No records yet"},
    "userNotExist": {'it': "L'utente non esiste!", 'en': "the user not exist!"},
    "messageP": {'it': "Messaggio...", 'en': "Message..."},
    "message": {'it': "Messaggio", 'en': "Message"},
    "unLike": {'it': "Non mi piace", 'en': "Un Like"},
    "replies": {'it': "risposte", 'en': "replies"},
    "addToStory": {'it': "Aggiungi una storia", 'en': "Add to story"},
    "limitOfPhotos": {
      'it': "Il limite è di 10 foto o video",
      'en': "The limit is 10 photo or videos."
    },
    "theName": {'it': "Il Nome", 'en': "The Name"},
    "newPost": {'it': "Nuovo Post", 'en': "New Post"},
    "loading": {'it': "Caricamento...", 'en': "Loading..."},
    "password": {'it': "Password", 'en': "Password"},
    "viewProfile": {'it': "Vedi profilo", 'en': "View Profile"},
    "restrict": {'it': "Restringi", 'en': "Restrict"},
    "share": {'it': "condividi", 'en': "share"},
    "followers": {'it': "Followers", 'en': "Followers"},
    "follower": {'it': "Follower", 'en': "Follower"},
    "explore": {'it': "Esplora", 'en': "Explore"},
    "allCaughtUp": {
      'it': "Hai visto tutti i post",
      'en': "You're all caught up"
    },
    "following": {'it': "Segui", 'en': "Following"},
    "hide": {'it': "Nascondi", 'en': "Hide"},
    "unfollow": {'it': "Non seguire", 'en': "Unfollow"},
    "delete": {'it': "Cancella", 'en': "Delete"},
    "edit": {'it': "Modifica", 'en': "Edit"},
    "hideLikeCount": {'it': "Nascondi numero like", 'en': "Hide like count"},
    "turnOffCommenting": {
      'it': "Disabilita commenti",
      'en': "Turn off commenting"
    },
    "archive": {'it': "Archivio", 'en': "Archive"},
    "facebook": {'it': "Facebook", 'en': "Facebook"},
    "changeLanguage": {'it': "Cambia lingua", 'en': "Change language"},
    "changeTheme": {'it': "Cambia tema", 'en': "Change theme"},
    "recordedSent": {'it': "Registrazione inviata", 'en': "Recorded sent"},
    "photoSent": {'it': "Foto inviata", 'en': "Photo sent"},
    "logOut": {'it': "Esci", 'en': "Log Out"},
    "sendMessage": {'it': "Invia Messaggio", 'en': "Send message"},
    "passwordWrong": {'it': "Password Sbagliata!", 'en': "Password wrong !"},
    "yourStory": {'it': "La tua storia", 'en': "Your story"},
    "youFollowHim": {'it': "Segui già", 'en': "You follow him"},
    "allowRecordingFromSettings": {
      'it': "Per piacere, abilita le registrazioni dalle impostazioni",
      'en': "Please allow recording from settings."
    },
    "noPosts": {'it': "Non ci sono posts", 'en': "There's no posts..."},
    "tryAddPost": {'it': "Prova a creare il post", 'en': "Try add post"},
    "noMorePostToday": {
      'it': "Non ci sono altri post per ora",
      'en': "There's no more posts today!"
    },
    "noAccount": {'it': "Non hai un account?", 'en': "Don't have an account?"},
    "haveAccount": {
      'it': "Hai già un account?",
      'en': "Already have an account?"
    },
    "tagPeople": {'it': "Menziona qualcuno", 'en': "Tag People"},
    "addLocation": {'it': "Aggiungi posizione", 'en': "Add location"},
    "confirmPassword": {
      'it': "Conferma la password",
      'en': "Confirm the password"
    },
    "alsoPostTo": {'it': "Posta anche su", 'en': "Also post to"},
    "addComment": {'it': "Aggiungi un commento...", 'en': "Add a comment..."},
    "noImageSelected": {
      'it': "Nessuna immagine selezionata",
      'en': "No image selected."
    },
    "writeACaption": {
      'it': "Scrivi una didascalia...",
      'en': "Write a caption..."
    },
    "likedAPhoto": {
      'it': "ha messo mi piace ad una tua foto",
      'en': "liked your photo"
    },
    "likedAComment": {
      'it': "ha messo mi piace ad un tuo commento",
      'en': "liked your comment"
    },
    "noMoreData": {'it': "no more data", 'en': "no more data."},
    "clickRetry": {'it': "fallito, riprova", 'en': "failed,click retry"},
    "phoneOrEmailOrUserName": {
      'it': "Numero di telefono, email o username",
      'en': "Phone number, email or username"
    },
    "comments": {'it': "Commenti", 'en': "Comments"},
    "somethingWrong": {
      'it': "Qualcosa è andato storto",
      'en': "There is something wrong"
    },
    "noComments": {
      'it': "Non ci sono commenti!",
      'en': "There is no comments!"
    },
    "replyingTo": {'it': "Rispondi a", 'en': "Replying to"},
    "fromCamera": {'it': "Dalla fotocamera", 'en': "From camera"},
    "fromGallery": {'it': "Dalla galleria", 'en': "From gallery"},
    "aboutThisAccount": {
      'it': "Riguardo quest'account",
      'en': "About this account"
    },
    "hideYourStory": {'it': "Nascondi la tua storia", 'en': "Hide your story"},
    "editInfo": {'it': "Modifica informazioni", 'en': "Edit info"},
    "copyProfileURL": {'it': "Copia il link profilo", 'en': "Copy profile URL"},
    "shareThisProfile": {
      'it': "Condividi questo profilo",
      'en': "Share this profile"
    },
    "editProfile": {'it': "Modifica profilo", 'en': "Edit profile"},
    "changeProfilePhoto": {
      'it': "Cambia immagine del profilo",
      'en': "Change profile photo"
    },
  }
].reduce((a, b) => a..addAll(b));
