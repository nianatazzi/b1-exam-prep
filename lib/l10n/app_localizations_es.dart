// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loading => 'Cargando...';

  @override
  String get errorGeneric => 'Algo salió mal';

  @override
  String get errorNetwork => 'Sin conexión a internet';

  @override
  String get errorAuth =>
      'Error de autenticación. Por favor, inicia sesión de nuevo.';

  @override
  String get errorNotFound => 'Contenido no encontrado';

  @override
  String get retry => 'Reintentar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get back => 'Atrás';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get authWelcomeTitle => 'Bienvenido a LinguoByte';

  @override
  String get authWelcomeSubtitle => 'Aprende un idioma, paso a paso';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get resetPasswordSent =>
      'Se ha enviado un enlace de restablecimiento a tu correo.';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get hasAccount => '¿Ya tienes una cuenta?';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get chooseLanguage => 'Elige un idioma';

  @override
  String get continueLearning => 'Continuar aprendiendo';

  @override
  String get lessonTitle => 'Lección';

  @override
  String get theory => 'Teoría';

  @override
  String get practice => 'Práctica';

  @override
  String get additional => 'Adicional';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get points => 'Puntos';

  @override
  String get settings => 'Ajustes';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get languageLabel => 'Idioma de la interfaz';

  @override
  String get learningLanguageLabel => 'Idioma de estudio';

  @override
  String get langEnglish => 'Inglés';

  @override
  String get langSpanish => 'Español';

  @override
  String get langFrench => 'Francés';

  @override
  String get langRussian => 'Ruso';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get surnameLabel => 'Apellido';

  @override
  String get profileSaved => 'Perfil guardado';

  @override
  String get editLabel => 'Editar';

  @override
  String get statusDone => 'Hecho';

  @override
  String get statusInProgress => 'En curso';

  @override
  String get statusLocked => 'Bloqueado';

  @override
  String get lexicalSection => 'Vocabulario';

  @override
  String get verbsSection => 'Conjugación verbal';

  @override
  String get additionalSection => 'Material adicional';

  @override
  String get lessonContents => 'Contenido';

  @override
  String get toExercisesButton => 'A los ejercicios';

  @override
  String get nextButton => 'Siguiente';

  @override
  String get completeStepButton => 'Completar';

  @override
  String get lessonCompleteTitle => '¡Lección completada!';

  @override
  String get courseCompleteTitle => '¡Curso completado!';

  @override
  String get backToHomeButton => 'Volver al inicio';

  @override
  String get verbTranslationColumn => 'Traducción';

  @override
  String get nextVerbButton => 'Siguiente verbo';

  @override
  String get tenseFuture => 'Futuro';

  @override
  String get tensePresent => 'Presente';

  @override
  String get tensePast => 'Pasado';

  @override
  String get finalSection => 'Ejercicios finales';

  @override
  String get checkButton => 'Verificar';

  @override
  String get correctLabel => '¡Correcto!';

  @override
  String get incorrectLabel => 'Incorrecto';

  @override
  String get correctAnswerLabel => 'Respuesta correcta:';

  @override
  String get answerHint => 'Tu traducción...';

  @override
  String get mosaicAnswerPlaceholder =>
      'Toca las palabras para construir una oración';

  @override
  String get transcriptLabel => 'Transcripción';

  @override
  String get seeTranslation => 'Toca para ver la traducción';

  @override
  String get hideTranslation => 'Toca para ocultar la traducción';

  @override
  String get cantSpeakNow => 'No puedo hablar ahora';

  @override
  String get tapToRecord => 'Toca para grabar';

  @override
  String get listeningLabel => 'Escuchando...';

  @override
  String get recognizedText => 'Reconocido:';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get interfaceLanguageSection => 'Idioma de la interfaz';

  @override
  String get appearanceSection => 'Apariencia';

  @override
  String get appearanceLabel => 'Apariencia';

  @override
  String get darkMode => 'Oscuro';

  @override
  String get lightMode => 'Claro';

  @override
  String get darkModeSubtitle => 'Modo oscuro';

  @override
  String get lightModeSubtitle => 'Modo claro';

  @override
  String get speechSection => 'Voz';

  @override
  String get speechSpeedLabel => 'Velocidad del habla';

  @override
  String get speechSpeedNormal => 'Normal';

  @override
  String get accountSection => 'Cuenta';

  @override
  String get currentStreakLabel => 'Racha actual';

  @override
  String get daysLabel => 'días';

  @override
  String get dayMon => 'L';

  @override
  String get dayTue => 'M';

  @override
  String get dayWed => 'X';

  @override
  String get dayThu => 'J';

  @override
  String get dayFri => 'V';

  @override
  String get daySat => 'S';

  @override
  String get daySun => 'D';

  @override
  String bestStreakLabel(int count) {
    return 'Mejor: $count';
  }

  @override
  String get proficiencySection => 'Competencias';

  @override
  String get grammarLabel => 'Gramática';

  @override
  String get vocabularyLabel => 'Vocabulario';

  @override
  String get listeningSkillLabel => 'Comprensión auditiva';

  @override
  String get speakingLabel => 'Expresión oral';

  @override
  String get achievementsSection => 'Logros';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get achievementMasterConjugator => 'Maestro conjugador';

  @override
  String get achievementFirstStep => 'Primer paso';

  @override
  String get achievementFocusedLearner => 'Estudiante dedicado';

  @override
  String get achievementInterestedLearner => 'Curioso';

  @override
  String get achievementVocabularyMaster => 'Maestro del vocabulario';

  @override
  String get achievementMasterConjugatorDesc => 'Sin errores';

  @override
  String get achievementFirstStepDesc => 'Completar lección 1';

  @override
  String get achievementFocusedLearnerDesc => '7 días seguidos';

  @override
  String get achievementInterestedLearnerDesc => 'Todos los extras';

  @override
  String get achievementVocabularyMasterDesc => 'Todos los conjuntos léxicos';

  @override
  String get resultTitle => 'Resultados';

  @override
  String resultScore(int correct, int total) {
    return '$correct/$total correctas';
  }

  @override
  String get resultPerfect => '¡Puntuación perfecta!';

  @override
  String get resultGood => '¡Bien hecho!';

  @override
  String get resultNeedsWork => '¡Sigue practicando!';

  @override
  String get firstName => 'Nombre';

  @override
  String get surname => 'Apellido';

  @override
  String get accentWarning =>
      'Tu respuesta se entiende, pero faltan los acentos.';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get validationEmailInvalid =>
      'Introduce una dirección de correo válida';

  @override
  String get validationPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get validationPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get errorWrongPassword =>
      'Correo electrónico o contraseña incorrectos';

  @override
  String get errorUserNotFound =>
      'No se encontró ninguna cuenta con este correo';

  @override
  String get errorEmailAlreadyInUse =>
      'Este correo ya está registrado. Inicia sesión.';

  @override
  String get errorWeakPassword =>
      'Contraseña demasiado débil. Usa al menos 6 caracteres.';

  @override
  String get errorRequiresRecentLogin =>
      'Por seguridad, cierra sesión y vuelve a iniciarla.';

  @override
  String get orLabel => 'o';

  @override
  String get continueWithGoogle => 'Continuar con Google';
}
