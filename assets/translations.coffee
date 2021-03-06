angular.module("mean").config ["$translateProvider", ($translateProvider) ->
  $translateProvider.translations "en-US",
    # /
    HOME: "Home"
    DEALS: "Deals"
    FIND: "Find"
    ABOUT: "About"
    CONTACT: "Contact"
    WELCOME: "Welcome"
    PROFILE: "Profile"
    SIGNOUT: "Logout"

    SIGNUP: "Sign up"
    SIGNIN: "Sign in"
    PASSWORD: "Password"
    REPEAT_PASSWORD: "Repeat password"
    DONOT_WASTE_TIME: "Do not waste time"
    REGISTER_FOR_FREE: "Register for free and start taking advantage"
    REGISTER_NOW: "Register now"
    WHAT_WE_HAVE: "What we have"
    DONOT_LOSE_CHANCE: "Do not miss the opportunity to take advantage of them"
    I_AM_A_SHOP: "I'm a shop"
    SIGNUP_FORM_TITLE: "SIGN UP"
    PASSWORDS_DO_NOT_MATCH: "The passwords do not match"
    SHOP_NAME_HAS_TO_BE_PROVIDED: "The name must be required"
    EMAIL_HAS_TO_BE_PROVIDED: "The email must be required"
    PASSWORD_HAS_TO_BE_PROVIDED: "The password must be required"
    EMAIL_ALREADY_EXISTS: "This email is in use, please you check another one"
    NO_SHOP_HAS_BEEN_FOUND: "Does not exist any shop with these credentials"
    PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED: "The email and password must required for login"
    UNKNOWN_ERROR: "Unknown error"
    FOR_FREE: "We do not charge anything"
    GET_IN: "Enter and discover the deals"
    DONT_HESITATE: "Do not think twice"

    ACTIVE_DEALS: "active deals"
    RESERVED_DEALS: "reserved deals"
    ACTIVE_USERS: "active users"
    ACTIVE_SHOPS: "active shops"

    STEP_FIND: "Find"
    STEP_FIND_DESC: "Find out in the deals list one you like the most. There are thousands to choose, don't let yours go away"
    STEP_RESERVE: "Reserve"
    STEP_RESERVE_DESC: "Once chosen, you simply have to reserve it and you will be assigned a reserve number; it's important you don't lose it"
    STEP_REDEEM: "Redeem"
    STEP_REDEEM_DESC: "Go to the shop that offers the deal and show the shop assistant your reservation number. Once validated you will be able to redeem it"
    STEP_ENJOY: "Enjoy!"
    STEP_ENJOY_DESC: "With the deal redeemed and in your hands, it's time to enjoy it. So don't think any more about it and run to enjoy it!"

    MY_BUYS: "My buys"
    NO_BUYS: "You have not bought any deal yet"
    BUYED: "Buyed the "
    MY_RESERVES: "My reserves"
    NO_RESERVES: "You have not got any pending reserve"
    RESERVED: "Reserved the "
    NEARBY_DEALS: "Nearby deals"
    NO_NEAR_DEALS: "You have not got any nearby deal"
    MY_COMMENTS: "My comments"
    NO_COMMENTS: "You have not writed any comment yet"
    YOU_ARE_IN: "You are in "
    RESERVE_CODE: "Reserve code"

    #contact
    CONTACT_US: "Contact us"
    ADDRESS: "Address:"
    OUR_PHONE: "Phone:"
    NAME: "Name"
    NAME_PLACEHOLDER: "Enter your name"
    EMAIL_PLACEHOLDER: "Enter your email"
    PHONE: "Phone"
    PHONE_PLACEHOLDER: "Enter your phone"
    MESSAGE_PLACEHOLDER: "Enter your comments"
    SEND: "Send"

    # /profile
    MY_PERFIL: "My perfil"
    EMAIL: "Email"
    FIRSTNAME: "First name"
    LASTNAME: "Last name"
    BIRTHDAY: "Birthday"
    RADIUS_DISTANCE: "Radius distance"
    METERS: "meters"
    SAVE: "Save"
    UPLOAD: "Upload image"
    CHANGE_IMAGE: "Change image"
    SAVING: "Saving..."
    UPLOADING: "Uploading..."
    RADIUS_DISTANCE_TOOLTIP: "Meter radius from your position that they find the deals"

    #deals
    DEALNAME_PLACEHOLDER: "Deal name..."
    SEARCH_BY: "Search by:"
    ALL_CATEGORIES: "All categories"
    ANY_PRICE: "Any price"

    #deal/:dealId
    RESERVE: "Reserve"
    COMMENTS: "Comments"
    DESCRIPTION: "Description"
    DESCRIPTION_PLACEHOLDER: "Description of the deal..."
    RATING: "Rating"
    COMMENT_200: "Comment has been added!"
    COMMENT_401: "You must login to leave a comment"
    COMMENT_404: "Unknown user"
    COMMENT_409: "Sorry, but you have already post a comment in this deal"
    COMMENT_422: "Remember that the rating and description are necessary for leave a comment"
    COMMENT_500: "It has been impossible to add your comment, please try again in a few minutes"

################################################################################
################################################################################

  $translateProvider.translations "es-ES",
    # /
    HOME: "Inicio"
    DEALS: "Ofertas"
    FIND: "Buscar"
    ABOUT: "Acerca de"
    CONTACT: "Contacto"
    WELCOME: "Bienvenido"
    PROFILE: "Perfil"
    SIGNOUT: "Cerrar sesión"

    SIGNUP: "Registrarse"
    SIGNIN: "Acceder"
    PASSWORD: "Contraseña"
    REPEAT_PASSWORD: "Repetir contraseña"
    DONOT_WASTE_TIME: "No pierda más el tiempo"
    REGISTER_FOR_FREE: "Regístrese gratuitamente y empiece a aprovecharse"
    REGISTER_NOW: "Regístrese ahora"
    WHAT_WE_HAVE: "Lo que tenemos"
    DONOT_LOSE_CHANCE: "No pierda la oportunidad de aprovecharlas"
    I_AM_A_SHOP: "Soy empresa"
    SIGNUP_FORM_TITLE: "CREAR UNA CUENTA"
    PASSWORDS_DO_NOT_MATCH: "Las contraseñas suministradas no coinciden"
    SHOP_NAME_HAS_TO_BE_PROVIDED: "Debe proporcionar un nombre para el comercio"
    EMAIL_HAS_TO_BE_PROVIDED: "Debe proporcionar un email para el comercio"
    PASSWORD_HAS_TO_BE_PROVIDED: "Debe proporcionar una contraseña para el comercio"
    EMAIL_ALREADY_EXISTS: "Ya existe un comercio con ese email. Por favor, proporcione otro."
    NO_SHOP_HAS_BEEN_FOUND: "No se ha encontrado ningún comercio con los credenciales suministrados"
    PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED: "Debe indicar una contraseña y un email para poder acceder"
    UNKNOWN_ERROR: "Error desconocido"
    FOR_FREE: "No cobramos nada"
    GET_IN: "Entre y descubra las ofertas"
    DONT_HESITATE: "No lo piense más"

    ACTIVE_DEALS: "ofertas activas"
    RESERVED_DEALS: "ofertas reservadas"
    ACTIVE_USERS: "usuarios activos"
    ACTIVE_SHOPS: "tiendas asociadas"

    STEP_FIND: "Busca"
    STEP_FIND_DESC: "Busca dentro de nuestra lista de ofertas la que más te guste. Hay miles entre las que elegir, no dejes que se escape la tuya"
    STEP_RESERVE: "Reserva"
    STEP_RESERVE_DESC: "Una vez elegida, simplemente tienes que reservarla y se te asignará un número de reserva; es muy importante que no lo pierdas"
    STEP_REDEEM: "Canjea"
    STEP_REDEEM_DESC: "Acércate a la tienda que ofrece la oferta y muéstrale al dependiente tu número de reserva. Una vez validado podrás canjearla"
    STEP_ENJOY: "¡Disfruta!"
    STEP_ENJOY_DESC: "Con la oferta ya canjeada y en tu poder, es hora de disfrutar de ella. Así que no lo pienses más y ¡corre a disfrutar de ella!"

    MY_BUYS: "Mis compras"
    NO_BUYS: "No has realizado ninguna compra"
    BUYED: "Comprado el "
    MY_RESERVES: "Mis reservas"
    NO_RESERVES: "No tienes ninguna reserva pendiente"
    RESERVED: "Reservado el "
    NEARBY_DEALS: "Ofertas cercanas"
    NO_NEAR_DEALS: "No hay ofertas cercanas"
    MY_COMMENTS: "Mis comentarios"
    NO_COMMENTS: "No tienes comentarios aún"
    YOU_ARE_IN: "Usted se encuentra en "
    RESERVE_CODE: "Codigo de reserva"


    #contact
    CONTACT_US: "Contacte con nosotros"
    ADDRESS: "Dirección:"
    OUR_PHONE: "Teléfono:"
    NAME: "Nombre"
    NAME_PLACEHOLDER: "Introduzca su nombre"
    EMAIL_PLACEHOLDER: "Introduzca su correo electrónico"
    PHONE: "Teléfono"
    PHONE_PLACEHOLDER: "Introduzca su teléfono"
    MESSAGE_PLACEHOLDER: "Introduzca su comentario"
    SEND: "Enviar"

    # / profile
    MY_PERFIL: "Mi perfil"
    EMAIL: "Correo electrónico"
    FIRSTNAME: "Nombre"
    LASTNAME: "Apellidos"
    BIRTHDAY: "Fecha de nacimiento"
    RADIUS_DISTANCE: "Radio de detección"
    METERS: "metros"
    SAVE: "Guardar"
    UPLOAD: "Subir imagen"
    CHANGE_IMAGE: "Cambiar imagen"
    SAVING: "Guardando..."
    UPLOADING: "Subiendo..."
    RADIUS_DISTANCE_TOOLTIP: "Metros a la redonda, desde tu posición, en los que se buscarán ofertas"

    #deals
    DEALNAME_PLACEHOLDER: "Nombre de oferta..."
    SEARCH_BY: "Buscar por:"
    ALL_CATEGORIES: "Todas las categorías"
    ANY_PRICE: "Cualquier precio"

    # deal/:dealId
    RESERVE: "Reservar"
    COMMENTS: "Comentarios"
    DESCRIPTION: "Descripción"
    DESCRIPTION_PLACEHOLDER: "Descripción de la oferta..."
    RATING: "Puntuación"
    COMMENT_200: "¡El comentario ha sido añadido!"
    COMMENT_401: "Para dejar un comentario debe iniciar sesión"
    COMMENT_404: "Usuario desconocido"
    COMMENT_409: "Lo sentimos, usted ya comentó esta oferta"
    COMMENT_422: "Recuerde que son necesarios tanto una puntuación como un breve comentario"
    COMMENT_500: "Ha sido imposible añadir el comentario, por favor inténtelo de nuevo en unos minutos"

    $translateProvider.translations "eu",
    # /
    HOME: "Hasiera"
    DEALS: "Eskeintzak"
    FIND: "Aurkitu"
    ABOUT: "Guri bruz"
    CONTACT: "Kontaktua"
    WELCOME: "Ongi etorri"
    PROFILE: "Profila"
    SIGNOUT: "Irten"

    SIGNUP: "Kontua sortu"
    SIGNIN: "Sartu"
    PASSWORD: "Pasahitza"
    REPEAT_PASSWORD: "Pasahitza errepikatu"
    DONOT_WASTE_TIME: "Denbora gehiagorik ez galdu"
    REGISTER_FOR_FREE: "Sortu kontua dohainik eta hasi erabiltzan"
    REGISTER_NOW: "Kontua sortu"
    WHAT_WE_HAVE: "Bertan aurkituko duzuna"
    DONOT_LOSE_CHANCE: "Ez galdu onura hauek izateko aukera"
    I_AM_A_SHOP: "Denda naiz"
    SIGNUP_FORM_TITLE: "KONTUA SORTU"
    PASSWORDS_DO_NOT_MATCH: "Sarturiko pasahitzak ez datoz bat"
    SHOP_NAME_HAS_TO_BE_PROVIDED: "Dendaren izena sartu behar duzu"
    EMAIL_HAS_TO_BE_PROVIDED: "Dendarendako email bat sartu behar duzu"
    PASSWORD_HAS_TO_BE_PROVIDED: "Dendaren pasahitza sartu behar duzu"
    EMAIL_ALREADY_EXISTS: "Bada helbide hau erabiltzen ari den denda. Mesedez, sartu beste bat."
    NO_SHOP_HAS_BEEN_FOUND: "Ez da dendarik aurkitu sartutako datuekin"
    PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED: "Helbide eta pasahitz bat beharrezkoa da sartzeko"
    UNKNOWN_ERROR: "Akats ezezaguna"
    FOR_FREE: "Ez dugu ezer kobratzen"
    GET_IN: "Sartu eta eskaintzez gozatu"
    DONT_HESITATE: "Ez pentsatu gehiago"

    ACTIVE_DEALS: "uskaintzak"
    RESERVED_DEALS: "eskaintza erreserba"
    ACTIVE_USERS: "erabiltzaile"
    ACTIVE_SHOPS: "denda"

    STEP_FIND: "Aurkitu"
    STEP_FIND_DESC: "Gure eskaintzen artean gehien gustuko duzuna bilatu. Hamaika eskaintza ditugu, lortu zurea."
    STEP_RESERVE: "Erreserba"
    STEP_RESERVE_DESC: "Behin aukeratutakoan, erreserba egin eta zenbaki bat egokituko zaizu"
    STEP_REDEEM: "Trukatu"
    STEP_REDEEM_DESC: "Gerturatu eskaintzaren dendara eta erakutsi zure kodea. Baieztatu ostean trukatu ahal izango duzu"
    STEP_ENJOY: "Gozatu!"
    STEP_ENJOY_DESC: "Behin eskaintza eskuratuta, gozatzen hasi zaitezke. Beraz, ez gehiago pentsatu eta arineketan joan zaitez!"


    MY_BUYS: "Nire erosketak"
    NO_BUYS: "Ez duzu erosketarik egin"
    BUYED: "Erosketa eguna: "
    MY_RESERVES: "Nire erreserbak"
    NO_RESERVES: "Ez duzu erreserbarik trukatzeko"
    RESERVED: "Erreserbatutako eguna: "
    NEARBY_DEALS: "Gertuko eskaintzak"
    NO_NEAR_DEALS: "Ez dago gertuko eskaintzarik"
    MY_COMMENTS: "Nire iruzkinak"
    NO_COMMENTS: "Ez duzu iruzkinik idatzi"
    YOU_ARE_IN: "Zure kokapena: "
    RESERVE_CODE: "Erreserba kodea"

    #contact
    CONTACT_US: "Gurekin harremanetan jarri"
    ADDRESS: "Helbidea:"
    OUR_PHONE: "Telefonoa:"
    NAME: "Izena"
    NAME_PLACEHOLDER: "Sartu zure izena"
    EMAIL_PLACEHOLDER: "Sartu zure helbidea"
    PHONE: "Telefonoa"
    PHONE_PLACEHOLDER: "Sartu zure telefonoa"
    MESSAGE_PLACEHOLDER: "Idatzi zure iruzkina"
    SEND: "Bidali"

    # / profile
    MY_PERFIL: "Nire profila"
    EMAIL: "Helbide elektronikoa"
    FIRSTNAME: "Izena"
    LASTNAME: "Abizenak"
    BIRTHDAY: "Jaiotze data"
    RADIUS_DISTANCE: "Kokapen eremua"
    METERS: "metro"
    SAVE: "Gorde"
    UPLOAD: "Irudia igo"
    CHANGE_IMAGE: "Irudia aldatu"
    SAVING: "Gordetzen..."
    UPLOADING: "Igotzen..."
    RADIUS_DISTANCE_TOOLTIP: "Eskaintzak aurkitzeko distantzia eremua"

    #deals
    DEALNAME_PLACEHOLDER: "Eskaintzaren izena..."
    SEARCH_BY: "Parametro hauengatik bilatu:"
    ALL_CATEGORIES: "Kategoria guztiak"
    ANY_PRICE: "Edozein prezio"

    # deal/:dealId
    RESERVE: "Erreserbatu"
    COMMENTS: "Iruzkinak"
    DESCRIPTION: "Deskribapena"
    DESCRIPTION_PLACEHOLDER: "Eskeintzaren deskribapena..."
    RATING: "Puntuazioa"
    COMMENT_200: "Iruzkina gehitua izan da!"
    COMMENT_401: "Iruzkina idazteko saioa hasi beharra duzu"
    COMMENT_404: "Erabiltzaile ezezaguna"
    COMMENT_409: "Barkatu, eskaintza hau komentatu duzu jada"
    COMMENT_422: "Bai puntuazioa, bai deskribapena beharrezkoak dira"
    COMMENT_500: "Iruzkina gehitzea ezinezkoa izan da, mesedez saia zaitze hemenidk minutu batzuetara"


  $translateProvider.preferredLanguage (if navigator.language is "es" then "es-ES" else navigator.language)
]