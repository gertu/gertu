angular.module('mean').config ["$translateProvider", ($translateProvider) ->
  $translateProvider.translations "en-US",
    HOME: "Home"
    PASSWORDS_DO_NOT_MATCH: 'EN_Las contraseñas suministradas no coinciden'
    SHOP_NAME_HAS_TO_BE_PROVIDED: 'EN_Debe proporcionar un nombre para el comercio'
    EMAIL_HAS_TO_BE_PROVIDED: 'EN_Debe proporcionar un email para el comercio'
    PASSWORD_HAS_TO_BE_PROVIDED: 'EN_Debe proporcionar una contraseña para el comercio'
    EMAIL_ALREADY_EXISTS: 'EN_Ya existe un comercio con ese email. Por favor, proporcione otro.'
    NO_SHOP_HAS_BEEN_FOUND: 'EN_No se ha encontrado ningún comercio con los credenciales suministrados'
    PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED: 'EN_Debe indicar una contaseña y un email para poder acceder'
    UNKNOWN_ERROR: 'EN_Error desconocido'
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
    PROFILE_HOME_1: "You haven't completed your profile yet, press "
    PROFILE_HOME_HERE: "here"
    PROFILE_HOME_2: " to complete it"
    MY_BOUGHT_DEALS: "My deals"
    CLOSE_DEALS: "Nearby deals"
    MY_MESSAGES: "My messages"
    NO_NEAR_DEALS: "There are no nearby deals"
    COMMENTS: 'Comments'
    DESCRIPTION: 'Description'
    DESCRIPTION_PLACEHOLDER: 'Description of the deal...'
    RATING: 'Rating'
    COMMENT_200: 'Comment has been added!'
    COMMENT_401: 'You must login to leave a comment'
    COMMENT_404: 'Unknown user'
    COMMENT_409: 'Sorry, but you have already post a comment in this deal'
    COMMENT_422: 'Remember that the rating and description are necessary for leave a comment'
    COMMENT_500: 'It has been impossible to add your comment, please try again in a few minutes'
    # Here we must add translations for english language

  $translateProvider.translations "es-ES",
    HOME: "Inicio"
    PASSWORDS_DO_NOT_MATCH: 'Las contraseñas suministradas no coinciden'
    SHOP_NAME_HAS_TO_BE_PROVIDED: 'Debe proporcionar un nombre para el comercio'
    EMAIL_HAS_TO_BE_PROVIDED: 'Debe proporcionar un email para el comercio'
    PASSWORD_HAS_TO_BE_PROVIDED: 'Debe proporcionar una contraseña para el comercio'
    EMAIL_ALREADY_EXISTS: 'Ya existe un comercio con ese email. Por favor, proporcione otro.'
    NO_SHOP_HAS_BEEN_FOUND: 'No se ha encontrado ningún comercio con los credenciales suministrados'
    PASSWORD_AND_EMAIL_HAVE_TO_BE_PROVIDED: 'Debe indicar una contaseña y un email para poder acceder'
    UNKNOWN_ERROR: 'Error desconocido'
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
    PROFILE_HOME_1: "Todavía no has completado tu perfil, pulsa "
    PROFILE_HOME_HERE: "aquí"
    PROFILE_HOME_2: " para completarlo"
    MY_BOUGHT_DEALS: "Mis ofertas"
    CLOSE_DEALS: "Ofertas cercanas"
    MY_MESSAGES: "Mis mensajes"
    NO_NEAR_DEALS: "No hay ofertas cercanas"
    COMMENTS: 'Comentarios'
    DESCRIPTION: 'Descripción'
    DESCRIPTION_PLACEHOLDER: 'Descripción de la oferta...'
    RATING: 'Puntuación'
    COMMENT_200: '¡El comentario ha sido añadido!'
    COMMENT_401: 'Para dejar un comentario debe iniciar sesión'
    COMMENT_404: 'Usuario desconocido'
    COMMENT_409: 'Lo sentimos, usted ya comentó esta oferta'
    COMMENT_422: 'Recuerde que son necesarios tanto una puntuación como un breve comentario'
    COMMENT_500: 'Ha sido imposible añadir el comentario, por favor inténtelo de nuevo en unos minutos'
    # Here we must add translations for spanish language


  $translateProvider.preferredLanguage (if navigator.language is "es" then "es-ES" else navigator.language)
]