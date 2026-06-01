import 'package:flutter/material.dart';

class NutritionistFillingData({
  required final String name,
  required final String age,
  required final String height,
  required final String weight,
  required final String gender,
  required final String activityLevel,
  required final String metabolicType,
  required final String healthCondition,
  required final String foodPreference,
  required final String goal,
}) {
  String? isValidName(BuildContext context) {
    if (name.isEmpty) {
      return 'Имя не может быть пустым';
    }
    if (name.length < 2) {
      return 'Имя должно содержать минимум 2 символа';
    }
    return null;
  }

  String? isValidAge(BuildContext context) {
    if (age.isEmpty) {
      return 'Возраст не может быть пустым';
    }
    final int? value = int.tryParse(age);
    if (value == null) {
      return 'Возраст должен быть числом';
    }
    if (value <= 0) {
      return 'Возраст должен быть больше 0';
    }
    return null;
  }

  String? isValidHeight(BuildContext context) {
    if (height.isEmpty) {
      return 'Рост не может быть пустым';
    }
    final double? value = double.tryParse(height);
    if (value == null) {
      return 'Рост должен быть числом';
    }
    if (value < 50 || value > 250) {
      return 'Рост должен быть в пределах от 50 до 250 см';
    }
    return null;
  }

  String? isValidWeight(BuildContext context) {
    if (weight.isEmpty) {
      return 'Вес не может быть пустым';
    }
    final double? value = double.tryParse(weight);
    if (value == null) {
      return 'Вес должен быть числом';
    }
    if (value < 20 || value > 200) {
      return 'Вес должен быть в пределах от 20 до 200 кг';
    }
    return null;
  }

  String? isValidGender(BuildContext context, {List<String>? validGenders}) {
    if (gender.isEmpty) {
      return 'Пол не может быть пустым';
    }
    return null;
  }

  String? isValidActivityLevel(BuildContext context, {List<String>? validLevels}) {
    if (activityLevel.isEmpty) {
      return 'Уровень активности не может быть пустым';
    }
    return null;
  }

  String? isValidMetabolicType(BuildContext context, {List<String>? validTypes}) {
    if (metabolicType.isEmpty) {
      return 'Тип метаболизма не может быть пустым';
    }
    return null;
  }

  String? isValidHealthCondition(BuildContext context) {
    if (healthCondition.isEmpty) {
      return 'Состояние здоровья не может быть пустым';
    }
    return null;
  }

  String? isValidFoodPreference(BuildContext context) {
    if (foodPreference.isEmpty) {
      return 'Пищевые предпочтения не могут быть пустыми';
    }
    return null;
  }

  String? isValidGoal(BuildContext context, {List<String>? validGoals}) {
    if (goal.isEmpty) {
      return 'Цель не может быть пустой';
    }
    return null;
  }

  String toPrompt() =>
      '''
    Имя: $name
    Возраст: $age
    Рост: $height
    Вес: $weight
    Пол: $gender
    Уровень активности: $activityLevel
    Тип метаболизма: $metabolicType
    Состояние здоровья: $healthCondition
    Пищевые предпочтения: $foodPreference
    Цель: $goal
    ''';
}
