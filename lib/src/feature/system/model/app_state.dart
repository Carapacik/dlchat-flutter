import 'package:rest_client/state/dto/app_state_dto.dart';

class const AppState._({
  required final String latestVersion,
  required final String latestSupportedVersion,
  required final bool technicalWorks,
  required final bool onValidation,
}) {
  factory decodeDao(AppStateDto dao) => AppState._(
    latestVersion: dao.lastVersion,
    latestSupportedVersion: dao.lastSupportedVersion,
    technicalWorks: dao.technicalWorks,
    onValidation: dao.onValidation,
  );
}
