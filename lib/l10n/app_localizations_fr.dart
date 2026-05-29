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
}
