import 'package:engine/core/bases/engine_base_validator.dart';

/// A base class for all models in the Engine.
///
/// This class does not provide any common features for all models.
/// It is just a marker interface to indicate that a class is a model.
abstract class EngineBaseModel<TModel> extends EngineBaseValidator<TModel> {
  String? Function([String?]) formValidate(final String key) => throw UnimplementedError();
}
