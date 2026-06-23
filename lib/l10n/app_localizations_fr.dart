// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get loading => 'Chargement...';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get errorNetwork => 'Pas de connexion internet';

  @override
  String get errorAuth =>
      'Erreur d\'authentification. Veuillez vous reconnecter.';

  @override
  String get errorNotFound => 'Contenu introuvable';

  @override
  String get retry => 'Réessayer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get authWelcomeTitle => 'Bienvenue sur LinguoByte';

  @override
  String get authWelcomeSubtitle => 'Apprenez une langue, étape par étape';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordSent =>
      'Un lien de réinitialisation a été envoyé à votre e-mail.';

  @override
  String get noAccount => 'Pas encore de compte ?';

  @override
  String get hasAccount => 'Vous avez déjà un compte ?';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get chooseLanguage => 'Choisissez une langue';

  @override
  String get continueLearning => 'Continuer l\'apprentissage';

  @override
  String get lessonTitle => 'Leçon';

  @override
  String get theory => 'Théorie';

  @override
  String get practice => 'Pratique';

  @override
  String get additional => 'Suppléments';

  @override
  String get profileTitle => 'Profil';

  @override
  String get points => 'Points';

  @override
  String get settings => 'Paramètres';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get languageLabel => 'Langue de l\'interface';

  @override
  String get learningLanguageLabel => 'Langue étudiée';

  @override
  String get langEnglish => 'Anglais';

  @override
  String get langSpanish => 'Espagnol';

  @override
  String get langFrench => 'Français';

  @override
  String get langRussian => 'Russe';

  @override
  String get nameLabel => 'Prénom';

  @override
  String get surnameLabel => 'Nom de famille';

  @override
  String get profileSaved => 'Profil enregistré';

  @override
  String get editLabel => 'Modifier';

  @override
  String get statusDone => 'Terminé';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusLocked => 'Verrouillé';

  @override
  String get lexicalSection => 'Vocabulaire';

  @override
  String get verbsSection => 'Conjugaison des verbes';

  @override
  String get additionalSection => 'Ressources complémentaires';

  @override
  String get lessonContents => 'Sommaire';

  @override
  String get toExercisesButton => 'Aux exercices';

  @override
  String get nextButton => 'Suivant';

  @override
  String get completeStepButton => 'Terminer';

  @override
  String get lessonCompleteTitle => 'Leçon terminée !';

  @override
  String get courseCompleteTitle => 'Cours terminé !';

  @override
  String get backToHomeButton => 'Retour à l\'accueil';

  @override
  String get verbTranslationColumn => 'Traduction';

  @override
  String get nextVerbButton => 'Verbe suivant';

  @override
  String get tenseFuture => 'Futur';

  @override
  String get tensePresent => 'Présent';

  @override
  String get tensePast => 'Passé';

  @override
  String get finalSection => 'Exercices finaux';

  @override
  String get checkButton => 'Vérifier';

  @override
  String get correctLabel => 'Correct !';

  @override
  String get incorrectLabel => 'Incorrect';

  @override
  String get correctAnswerLabel => 'Bonne réponse :';

  @override
  String get answerHint => 'Votre traduction...';

  @override
  String get mosaicAnswerPlaceholder =>
      'Appuyez sur les mots pour construire une phrase';

  @override
  String get transcriptLabel => 'Transcription';

  @override
  String get seeTranslation => 'Appuyez pour voir la traduction';

  @override
  String get hideTranslation => 'Appuyez pour masquer la traduction';

  @override
  String get cantSpeakNow => 'Je ne peux pas parler maintenant';

  @override
  String get tapToRecord => 'Appuyez pour enregistrer';

  @override
  String get listeningLabel => 'J\'écoute...';

  @override
  String get recognizedText => 'Reconnu :';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get interfaceLanguageSection => 'Langue de l\'interface';

  @override
  String get appearanceSection => 'Apparence';

  @override
  String get appearanceLabel => 'Apparence';

  @override
  String get darkMode => 'Sombre';

  @override
  String get lightMode => 'Clair';

  @override
  String get darkModeSubtitle => 'Mode sombre';

  @override
  String get lightModeSubtitle => 'Mode clair';

  @override
  String get speechSection => 'Parole';

  @override
  String get speechSpeedLabel => 'Vitesse de parole';

  @override
  String get speechSpeedNormal => 'Normale';

  @override
  String get accountSection => 'Compte';

  @override
  String get currentStreakLabel => 'Série en cours';

  @override
  String get daysLabel => 'jours';

  @override
  String get dayMon => 'L';

  @override
  String get dayTue => 'M';

  @override
  String get dayWed => 'M';

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
    return 'Record : $count';
  }

  @override
  String get proficiencySection => 'Compétences';

  @override
  String get grammarLabel => 'Grammaire';

  @override
  String get vocabularyLabel => 'Vocabulaire';

  @override
  String get listeningSkillLabel => 'Écoute';

  @override
  String get speakingLabel => 'Expression orale';

  @override
  String get achievementsSection => 'Succès';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get achievementMasterConjugator => 'Maître conjugueur';

  @override
  String get achievementFirstStep => 'Premier pas';

  @override
  String get achievementFocusedLearner => 'Apprenant assidu';

  @override
  String get achievementInterestedLearner => 'Curieux';

  @override
  String get achievementVocabularyMaster => 'Maître du vocabulaire';

  @override
  String get achievementMasterConjugatorDesc => 'Sans erreurs';

  @override
  String get achievementFirstStepDesc => 'Terminer la leçon 1';

  @override
  String get achievementFocusedLearnerDesc => '7 jours consécutifs';

  @override
  String get achievementInterestedLearnerDesc => 'Tous les extras';

  @override
  String get achievementVocabularyMasterDesc => 'Tous les ensembles lexicaux';

  @override
  String get resultTitle => 'Résultats';

  @override
  String resultScore(int correct, int total) {
    return '$correct/$total correct(s)';
  }

  @override
  String get resultPerfect => 'Score parfait !';

  @override
  String get resultGood => 'Bien joué !';

  @override
  String get resultNeedsWork => 'Continuez à pratiquer !';

  @override
  String get firstName => 'Prénom';

  @override
  String get surname => 'Nom';

  @override
  String get accentWarning =>
      'Votre réponse est comprise, mais les accents manquent.';
}
