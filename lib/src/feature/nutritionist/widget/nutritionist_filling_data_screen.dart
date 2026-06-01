import 'package:dlchat/src/core/common/extensions/context_extension.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/path_params.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/chat/model/assistant.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/nutritionist/model/nutritionist_filling_data.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_tonal_button.dart';
import 'package:dlchat/src/feature/shared_widgets/common/plus_description_tile.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rest_client/chat_v2/dto/assistant_type.dart';

class const NutritionistFillingDataScreen({super.key}) extends StatefulWidget {
  @override
  State<NutritionistFillingDataScreen> createState() => _NutritionistFillingDataScreenState();
}

class _NutritionistFillingDataScreenState() extends State<NutritionistFillingDataScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 1;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _healthConditionController = TextEditingController();
  final TextEditingController _foodPreferenceController = TextEditingController();

  final ValueNotifier<String?> _nameError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _ageError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _heightError = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _weightError = ValueNotifier<String?>(null);
  late final Listenable _formListenable;

  final List<String> _validGenders = ['Мужской', 'Женский'];
  final List<String> _validActivityLevels = ['Легкая', 'Средняя', 'Высокая', 'Очень высокая'];
  final List<String> _validMetabolicTypes = ['Быстро набираю вес', 'Долго набираю вес', 'Умеренный, средний'];
  final List<String> _validGoals = ['Похудение', 'Набор массы', 'Поддержание веса'];

  @override
  void initState() {
    super.initState();
    _formListenable = Listenable.merge([
      _nameController,
      _ageController,
      _heightController,
      _weightController,
      _healthConditionController,
      _foodPreferenceController,
    ])..addListener(_onChange);
  }

  void _onChange() {
    _nameError.value = null;
    _ageError.value = null;
    _heightError.value = null;
    _weightError.value = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _healthConditionController.dispose();
    _foodPreferenceController.dispose();
    _formListenable.removeListener(_onChange);
    super.dispose();
  }

  String _gender = '';
  String _activityLevel = '';
  String _metabolicType = '';
  String _goal = '';

  // Add these error state variables
  bool _genderError = false;
  bool _activityLevelError = false;
  bool _metabolicTypeError = false;
  bool _goalError = false;

  void _nextStep() {
    // Reset error states first
    setState(() {
      _genderError = false;
      _activityLevelError = false;
      _metabolicTypeError = false;
      _goalError = false;
    });

    final data = NutritionistFillingData(
      name: _nameController.text,
      age: _ageController.text,
      height: _heightController.text,
      weight: _weightController.text,
      gender: _gender,
      activityLevel: _activityLevel,
      metabolicType: _metabolicType,
      healthCondition: _healthConditionController.text,
      foodPreference: _foodPreferenceController.text,
      goal: _goal,
    );

    if (!_validateCurrentStep(data)) {
      return;
    }

    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });
    } else {
      context.read<ChatsBloc>().add(
        ChatsEvent.addAssistant(
          assistantType: AssistantType.nutritionist,
          name: AssistantEnum.nutritionist.name,
          initialMessage: data.toPrompt(),
        ),
      );
    }
  }

  bool _validateCurrentStep(NutritionistFillingData data) {
    switch (_currentStep) {
      case 1:
        _nameError.value = data.isValidName(context);
        _ageError.value = data.isValidAge(context);
        _heightError.value = data.isValidHeight(context);
        final String? genderError = data.isValidGender(context, validGenders: _validGenders);
        if (genderError != null) {
          setState(() => _genderError = true);
        }
        return _nameError.value == null && _ageError.value == null && _heightError.value == null && genderError == null;

      case 2:
        _weightError.value = data.isValidWeight(context);
        final String? activityError = data.isValidActivityLevel(context, validLevels: _validActivityLevels);
        if (activityError != null) {
          setState(() => _activityLevelError = true);
        }
        return _weightError.value == null && activityError == null;

      case 3:
        final String? metabolicError = data.isValidMetabolicType(context, validTypes: _validMetabolicTypes);
        if (metabolicError != null) {
          setState(() => _metabolicTypeError = true);
        }
        return metabolicError == null;

      case 4:
        return true;

      case 5:
        final String? goalError = data.isValidGoal(context, validGoals: _validGoals);
        if (goalError != null) {
          setState(() => _goalError = true);
        }
        return goalError == null;

      default:
        return true;
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
        _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });
    }
  }

  Widget _buildStep1() {
    return StepContainer(
      step: 1,
      description: 'Система единиц и пол',
      indicator: StepIndicator(currentStep: _currentStep, totalSteps: 5),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          const PlusDescriptionTile(title: 'Ваше имя'),
          ValueListenableBuilder(
            valueListenable: _nameError,
            builder: (context, value, child) {
              return NutritionistTextField(controller: _nameController, errorText: value);
            },
          ),
          const SizedBox(height: 4),
          const PlusDescriptionTile(title: 'Ваш возраст'),
          ValueListenableBuilder(
            valueListenable: _ageError,
            builder: (context, value, child) {
              return NutritionistTextField(
                controller: _ageController,
                errorText: value,
                keyboardType: TextInputType.number,
              );
            },
          ),
          const SizedBox(height: 4),
          const PlusDescriptionTile(title: 'Ваш рост, см'),
          ValueListenableBuilder(
            valueListenable: _heightError,
            builder: (context, value, child) {
              return NutritionistTextField(
                controller: _heightController,
                errorText: value,
                keyboardType: TextInputType.number,
              );
            },
          ),
          const SizedBox(height: 12),
          const PlusDescriptionTile(title: 'Ваш пол'),
          const SizedBox(height: 4),
          Row(
            spacing: 4,
            children: [
              Expanded(
                child: CustomChoiceChip(
                  label: _validGenders[0],
                  isSelected: _gender == _validGenders[0],
                  onSelected: (selected) => setState(() {
                    _gender = _validGenders[0];
                    _genderError = false;
                  }),
                  hasError: _genderError,
                ),
              ),
              Expanded(
                child: CustomChoiceChip(
                  label: _validGenders[1],
                  isSelected: _gender == _validGenders[1],
                  onSelected: (selected) => setState(() {
                    _gender = _validGenders[1];
                    _genderError = false;
                  }),
                  hasError: _genderError,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return StepContainer(
      step: 2,
      description: 'Вес и физическая активность',
      indicator: StepIndicator(currentStep: _currentStep, totalSteps: 5),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          const PlusDescriptionTile(title: 'Ваш вес, кг'),
          ValueListenableBuilder(
            valueListenable: _weightError,
            builder: (context, value, child) {
              return NutritionistTextField(
                controller: _weightController,
                errorText: value,
                keyboardType: TextInputType.number,
              );
            },
          ),
          const SizedBox(height: 12),
          const PlusDescriptionTile(title: 'Физическая активность'),
          const SizedBox(height: 4),
          Row(
            spacing: 8,
            children: _validActivityLevels.sublist(0, 2).map((level) {
              return Expanded(
                child: CustomChoiceChip(
                  label: level,
                  isSelected: _activityLevel == level,
                  onSelected: (selected) => setState(() {
                    _activityLevel = level;
                    _activityLevelError = false;
                  }),
                  hasError: _activityLevelError,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Row(
            spacing: 8,
            children: _validActivityLevels.sublist(2).map((level) {
              return Expanded(
                child: CustomChoiceChip(
                  label: level,
                  isSelected: _activityLevel == level,
                  onSelected: (selected) => setState(() {
                    _activityLevel = level;
                    _activityLevelError = false;
                  }),
                  hasError: _activityLevelError,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return StepContainer(
      step: 3,
      description: 'Метаболический тип',
      indicator: StepIndicator(currentStep: _currentStep, totalSteps: 5),
      child: Column(
        spacing: 4,
        children: _validMetabolicTypes.map((type) {
          return CustomChoiceChip(
            label: type,
            isSelected: _metabolicType == type,
            onSelected: (selected) => setState(() {
              _metabolicType = type;
              _metabolicTypeError = false;
            }),
            hasError: _metabolicTypeError,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStep4() {
    return StepContainer(
      step: 4,
      description: 'Особенности здоровья и питания',
      indicator: StepIndicator(currentStep: _currentStep, totalSteps: 5),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          const PlusDescriptionTile(title: 'Особенности здоровья (гипертония, сахарный диабет, аллергии)'),
          const SizedBox(height: 4),
          NutritionistTextField(controller: _healthConditionController),
          const SizedBox(height: 24),
          const PlusDescriptionTile(
            title: 'Привычки питания: сколько приемов пищи в день, есть ли ограничения и предпочтения по продуктам?',
          ),
          const SizedBox(height: 4),
          NutritionistTextField(controller: _foodPreferenceController),
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return StepContainer(
      step: 5,
      description: 'Цель',
      indicator: StepIndicator(currentStep: _currentStep, totalSteps: 5),
      child: Column(
        spacing: 4,
        children: _validGoals.map((goal) {
          return CustomChoiceChip(
            label: goal,
            isSelected: _goal == goal,
            onSelected: (selected) => setState(() {
              _goal = goal;
              _goalError = false;
            }),
            hasError: _goalError,
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocConsumer<ChatsBloc, ChatsState>(
      listener: (context, state) async {
        if (state is ChatsSuccess) {
          context.goNamedX(Routes.chats.name);
          await context.pushNamedX(Routes.chat.name, pathParameters: {RouteParams.id.path: state.newChat!.id});
        }
      },
      builder: (context, state) {
        return FullScreenLoading(
          inProgress: state.inAddProgress,
          text: 'Пожалуйста подождите, идет анализ',
          child: Scaffold(
            body: SafeArea(
              child: ChatGradient(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [_buildStep1(), _buildStep2(), _buildStep3(), _buildStep4(), _buildStep5()],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: SizedBox(
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 16,
                        children: [
                          if (_currentStep > 1)
                            Expanded(
                              child: CustomFilledTonalButton(onPressed: _previousStep, text: 'Назад'),
                            )
                          else
                            Expanded(
                              child: CustomFilledTonalButton(onPressed: () => context.pop(), text: 'Выйти'),
                            ),
                          Expanded(
                            child: CustomFilledButton(
                              onPressed: _nextStep,
                              text: _currentStep == 5 ? 'Завершить' : 'Далее',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class const StepContainer({
  required final int step,
  required final String description,
  required final Widget indicator,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Column(
            children: [
              Text('Шаг $step', style: AppTypography.bodySemibold),
              const SizedBox(height: 8),
              Text(description, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              indicator,
              const SizedBox(height: 24),
              child,
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}

class const StepIndicator({required final int currentStep, required final int totalSteps, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: currentStep / totalSteps,
      backgroundColor: Colors.grey[300],
      borderRadius: BorderRadius.circular(100),
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.pink1),
    );
  }
}

class const NutritionistTextField({
  final TextEditingController? controller,
  final String? errorText,
  final FocusNode? focusNode,
  final TextInputType? keyboardType,
  final int? maxLength,
  final int? maxLines = 1,
  final TextInputAction? textInputAction,
  super.key,
}) extends StatefulWidget {
  @override
  State<NutritionistTextField> createState() => _NutritionistTextFieldState();
}

class _NutritionistTextFieldState() extends State<NutritionistTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  void _onChange() => setState(() {});

  Color get _statusColor {
    if (widget.errorText != null) {
      return AppColors.error;
    }

    if (_focusNode.hasFocus) {
      return AppColors.success;
    }

    return Colors.transparent;
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onChange);
    _controller.addListener(_onChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.removeListener(_onChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _focusNode.requestFocus,
          child: Material(
            color: AppColors.bgSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              side: BorderSide(color: _statusColor),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: (!_focusNode.hasFocus && _controller.text.isEmpty) ? 32 : 0),
              child: TextField(
                controller: _controller,
                cursorColor: _statusColor,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                scrollPadding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.viewInsetsOf(context).bottom + ((widget.maxLines ?? 1) + 1) * 18,
                ),
                style: AppTypography.bodyMedium,
                textInputAction: widget.textInputAction,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    (!_focusNode.hasFocus && _controller.text.isEmpty) ? 0 : 32,
                  ),
                  counterText: '',
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.errorText!,
              style: AppTypography.bodySettingsRegularHeader.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}

class const CustomChoiceChip({
  required final String label,
  required final bool isSelected,
  required final ValueChanged<bool> onSelected,
  final bool hasError = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      padding: const EdgeInsets.symmetric(vertical: 16),
      showCheckmark: false,
      label: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.bgSecondary,
      backgroundColor: AppColors.bgSecondary,
      shape: StadiumBorder(
        side: BorderSide(color: isSelected ? AppColors.textPrimary : (hasError ? AppColors.error : Colors.transparent)),
      ),
    );
  }
}
