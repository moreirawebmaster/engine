import 'package:engine/lib.dart';

class EngineFormValidatorLanguage extends LanguageManager {
  EngineFormValidatorLanguage() {
    addTranslation(
      Culture('pt-PT'),
      Language.code.equalTo,
      "'{PropertyName}' deve ser igual a '{ComparisonValue}'.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.greaterThan,
      "'{PropertyName}' deve ser maior que '{ComparisonValue}'.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.isEmpty,
      "'{PropertyName}' deve estar vazio.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.isNotNull,
      "'{PropertyName}' não deve ser nulo.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.isNull,
      "'{PropertyName}' deve ser nulo.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.lessThan,
      "'{PropertyName}' deve ser menor que '{ComparisonValue}'.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.matchesPattern,
      "O formato de '{PropertyName}' está incorreto.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.max,
      "O valor de '{PropertyName}' deve ser menor ou igual a {MaxValue}. Você inseriu {PropertyValue}.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.maxLength,
      "O comprimento de '{PropertyName}' deve ter {MaxLength} caracteres ou menos. Você inseriu {TotalLength} caracteres.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.min,
      "'{PropertyName}' deve ser maior ou igual a {MinValue}. Você inseriu {PropertyValue}.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.minLength,
      "O comprimento de '{PropertyName}' deve ter pelo menos {MinLength} caracteres. Você inseriu {TotalLength} caracteres.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.mustHaveLowercase,
      "'{PropertyName}' deve ter pelo menos uma letra min scula.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.mustHaveNumber,
      "'{PropertyName}' deve ter pelo menos um digito ('0'-'9').",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.mustHaveSpecialCharacter,
      "'{PropertyName}' deve ter pelo menos um caracter especial.",
    );
    addTranslation(
      Culture('pt-PT'),
      Language.code.mustHaveUppercase,
      "'{PropertyName}' deve ter pelo menos uma letra maiuscula.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.notEmpty,
      "'{PropertyName}' não o pode estar vazio.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.notEqualTo,
      "'{PropertyName}' não pode ser igual a '{ComparisonValue}'.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.range,
      "'{PropertyName}' deve estar entre {From} e {To}. Você  inseriu {PropertyValue}.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.validEmail,
      "'{PropertyName}' endereço de e-mail inválido.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.greaterThanOrEqualToDateTime,
      "'{PropertyName}' deve ser maior ou igual '{ComparisonValue}'.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.greaterThanDatetime,
      "'{PropertyName}' deve ser maior que a data '{ComparisonValue}'.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.lessThanOrEqualToDateTime,
      "'{PropertyName}' deve ser menor ou igual   data '{ComparisonValue}'.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.lessThanDateTime,
      "'{PropertyName}' deve ser menor que a data '{ComparisonValue}'.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.inclusiveBetweenDatetime,
      "'{PropertyName}' deve ser maior ou igual data '{StartValue}' e menor ou igual  data '{EndValue}'.",
    );
    addTranslation(
      Culture('pt'),
      Language.code.exclusiveBetweenDatetime,
      "'{PropertyName}' deve ser maior que a data '{StartValue}' e menor que a data '{EndValue}'.",
    );
  }
}
